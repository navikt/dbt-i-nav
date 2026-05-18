
# Granularitet

Granularitet er den viktigste egenskapen ved et dataprodukt etter innhold og historikk. Hvis granulariteten er uklar, blir joins, filtrering, aggregering og testing uforutsigbart.

I dbt-miljøer brukes ofte ordet `grain` om det samme. I denne dokumentasjonen bruker vi `granularitet` i løpende tekst, men `grain` i `meta`, kontraktsfelt og andre maskinlesbare nøkler. Det gjør teksten mer naturlig på norsk uten å skape kluss i kontraktene.

Målet med denne siden er å beskrive hva granularitet er, hvordan den skal velges, og hvordan den skal dokumenteres og deles i dbt.

## Hva granularitet er

Granularitet beskriver hva én rad i en modell representerer.

Granulariteten skal kunne uttrykkes som en kort setning, for eksempel:

- Én rad per person
- Én rad per person per dag
- Én rad per vedtak
- Én rad per arbeidsforhold per gyldighetsintervall
- Én rad per utbetalingstransaksjon

Hvis en modell ikke kan beskrives på denne måten, er granulariteten sannsynligvis for uklar.

## Hvorfor granularitet er viktig

Tydelig granularitet gjør det mulig å:

- forstå hva modellen kan brukes til
- vite om en join er trygg eller vil multiplisere rader
- vite når en modell må aggregeres før bruk
- teste om modellen faktisk oppfører seg som forventet
- dele dataprodukter på tvers av domener uten at konsumenter må lese SQL-en

I praksis er mange feil i dataprodukter egentlig feil i granularitet.

## Hovedregel

Granularitet skal være eksplisitt for alle eksponerte modeller.

Det betyr:

- alle `dim_`-modeller skal ha tydelig definert granularitet
- alle `fak_`-modeller skal ha tydelig definert granularitet
- alle `obt_`-modeller skal ha tydelig definert granularitet
- granulariteten skal være forståelig uten å lese implementasjonen

## Granularitet og modelltype

Historikk og navnestandard gjør det enklere å beskrive granularitet, men de erstatter det ikke. Granulariteten må fortsatt sies eksplisitt.

### Dimensjoner

Dimensjoner skal ha en stabil og forståelig granularitet.

Typiske eksempler:

- én rad per person
- én rad per arbeidsgiver
- én rad per person per gyldighetsintervall

Hvis en dimensjon er historisert, skal granulariteten uttrykke dette eksplisitt. Det holder ikke å si at modellen er en persondimensjon hvis den egentlig har flere rader per person over tid.

### Fakta

Fakta skal beskrive en hendelse, tilstand eller måling på et konkret nivå.

Typiske eksempler:

- én rad per vedtak
- én rad per utbetaling
- én rad per person per måned per ytelse

Hvis granulariteten i en fakttabell er sammensatt, skal alle relevante akser med i beskrivelsen.

### OBT-er

OBT-er er ofte de vanskeligste modellene å forstå. Derfor må granulariteten være ekstra tydelig.

Typiske eksempler:

- én rad per person med gjeldende status
- én rad per person per måned
- én rad per vedtak med påberikede dimensjonsattributter

En OBT skal ikke beskrives bare som en bred tabell for analyse. Det sier ingenting om granulariteten.

## Granularitet og historikk

Hvis modellen er historisert, er historikk en del av granulariteten.

Det betyr at følgende beskrivelser ikke er like:

- én rad per person
- én rad per person per gyldighetsintervall
- én rad per person per dag

Dette må være tydelig i både dokumentasjon og tester.

## Granularitet og joins

En modell skal bare eksponeres bredt hvis granulariteten gjør den trygg å bruke.

Før en modell deles, bør det være tydelig:

- hvilke kolonner som identifiserer granulariteten
- om granulariteten er unik i modellen
- om modellen kan joines direkte mot andre modeller
- om konsumenter må aggregere først

Hvis disse spørsmålene ikke har tydelige svar, er modellen ikke godt nok beskrevet.

## Hvordan granularitet skal dokumenteres

Ja: granularitet bør dokumenteres i modellens yml i dbt.

Det bør gjøres på to nivåer:

- i `description`, slik at det er synlig i dbt docs og lett å lese for konsumenter
- i tester, slik at granulariteten også er verifiserbar

I `meta` skal vi bruke `grain` og `grain_keys`, slik at kontrakter og maskinlesbare metadata er koordinerte på tvers av produkter. Det er ikke et krav fra dbt, men det er kravet i denne dokumentasjonen.

## Anbefalt praksis i yml

For hver eksponert modell bør yml minst inneholde:

- en kort beskrivelse av hva modellen er
- en eksplisitt setning om granularitet
- hvilke kolonner som identifiserer granulariteten
- tester som bekrefter granulariteten der det er mulig

Eksempel:

```yaml
models:
  - name: fak_vedtak
    description: |
      Vedtak i komponenten arbeid.
      Granularitet: En rad per vedtak.
    meta:
      grain: En rad per vedtak
      grain_keys:
        - vedtak_id
    columns:
      - name: vedtak_id
        description: Unik identifikator for vedtaket.
        tests:
          - not_null
          - unique
```

Eksempel med historikk:

```yaml
models:
  - name: dim_person
    description: |
      Persondimensjon med historikk.
      Granularitet: En rad per person per gyldighetsintervall.
    meta:
      grain: En rad per person per gyldighetsintervall
      grain_keys:
        - person_id
        - gyldig_fom_dato
    columns:
      - name: person_id
        tests:
          - not_null
      - name: gyldig_fom_dato
        tests:
          - not_null
```

## Hvordan granularitet deles for hvert dataprodukt

For hvert dataprodukt skal granulariteten være synlig der konsumentene faktisk leter:

- i modellens yml
- i dbt docs
- i eventuell kontrakt eller produktdokumentasjon

Hvis dataproduktet består av flere sentrale modeller, bør hver modell ha sin egen beskrivelse av granularitet. Det holder ikke med én generell beskrivelse på toppen av prosjektet.

## Granularitet skal også testes

Granularitet som bare står i tekst er ikke nok. Hvis granulariteten er viktig, bør den også testes.

Typiske eksempler:

- `unique` på én kolonne når granulariteten er én rad per nøkkel
- kombinerte unikhetstester når granulariteten er sammensatt
- egne datatester når granulariteten avhenger av historikk eller mer kompleks logikk

Dokumentasjon og test skal peke på samme forståelse av modellen.

## Praktisk tommelfingerregel

- Hvis du ikke kan forklare hva én rad representerer i én setning, er granulariteten for uklar.
- Hvis granulariteten ikke står i yml, er den ikke godt nok dokumentert.
- Hvis granulariteten ikke kan testes, er den ikke godt nok kontrollert.
- Hvis historikk inngår i granulariteten, må det sies eksplisitt.