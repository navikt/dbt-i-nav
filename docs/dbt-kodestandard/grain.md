
# Grain

Grain er den viktigste egenskapen ved et dataprodukt etter innhold og historikk. Hvis grain er uklart, blir joins, filtrering, aggregering og testing uforutsigbart.

Målet med denne siden er å beskrive hva grain er, hvordan det skal velges, og hvordan det skal dokumenteres og deles i dbt.

## Hva grain er

Grain beskriver hva én rad i en modell representerer.

Grain skal kunne uttrykkes som en kort setning, for eksempel:

- Én rad per person
- Én rad per person per dag
- Én rad per vedtak
- Én rad per arbeidsforhold per gyldighetsintervall
- Én rad per utbetalingstransaksjon

Hvis en modell ikke kan beskrives på denne måten, er grain sannsynligvis for uklar.

## Hvorfor grain er viktig

Tydelig grain gjør det mulig å:

- forstå hva modellen kan brukes til
- vite om en join er trygg eller vil multiplisere rader
- vite når en modell må aggregeres før bruk
- teste om modellen faktisk oppfører seg som forventet
- dele dataprodukter på tvers av domener uten at konsumenter må lese SQL-en

I praksis er mange feil i dataprodukter egentlig grain-feil.

## Hovedregel

Grain skal være eksplisitt for alle eksponerte modeller.

Det betyr:

- alle `dim_`-modeller skal ha tydelig definert grain
- alle `fak_`-modeller skal ha tydelig definert grain
- alle `obt_`-modeller skal ha tydelig definert grain
- grain skal være forståelig uten å lese implementasjonen

## Grain og modelltype

Historikk og navnestandard gjør det enklere å beskrive grain, men de erstatter det ikke. Grain må fortsatt sies eksplisitt.

### Dimensjoner

Dimensjoner skal ha et stabilt og forståelig grain.

Typiske eksempler:

- én rad per person
- én rad per arbeidsgiver
- én rad per person per gyldighetsintervall

Hvis en dimensjon er historisert, skal grain uttrykke dette eksplisitt. Det holder ikke å si at modellen er en persondimensjon hvis den egentlig har flere rader per person over tid.

### Fakta

Fakta skal beskrive en hendelse, tilstand eller måling på et konkret nivå.

Typiske eksempler:

- én rad per vedtak
- én rad per utbetaling
- én rad per person per måned per ytelse

Hvis grain i en fakttabell er sammensatt, skal alle relevante akser med i beskrivelsen.

### OBT-er

OBT-er er ofte de vanskeligste modellene å forstå. Derfor må grain være ekstra tydelig.

Typiske eksempler:

- én rad per person med gjeldende status
- én rad per person per måned
- én rad per vedtak med påberikede dimensjonsattributter

En OBT skal ikke beskrives bare som en bred tabell for analyse. Det sier ingenting om grain.

## Grain og historikk

Hvis modellen er historisert, er historikk en del av grain.

Det betyr at følgende beskrivelser ikke er like:

- én rad per person
- én rad per person per gyldighetsintervall
- én rad per person per dag

Dette må være tydelig i både dokumentasjon og tester.

## Grain og joins

En modell skal bare eksponeres bredt hvis grain gjør den trygg å bruke.

Før en modell deles, bør det være tydelig:

- hvilke kolonner som identifiserer grain
- om grain er unik i modellen
- om modellen kan joins direkte mot andre modeller
- om konsumenter må aggregere først

Hvis disse spørsmålene ikke har tydelige svar, er modellen ikke godt nok beskrevet.

## Hvordan grain skal dokumenteres

Ja: grain bør dokumenteres i modellens yml i dbt.

Det bør gjøres på to nivåer:

- i `description`, slik at det er synlig i dbt docs og lett å lese for konsumenter
- i tester, slik at grain også er verifiserbart

I tillegg kan grain legges i `meta` hvis dere ønsker å gjøre det maskinlesbart og mulig å hente ut på tvers av produkter.

## Anbefalt praksis i yml

For hver eksponert modell bør yml minst inneholde:

- en kort beskrivelse av hva modellen er
- en eksplisitt setning om grain
- hvilke kolonner som identifiserer grain
- tester som bekrefter grain der det er mulig

Eksempel:

```yaml
models:
  - name: fak_vedtak
    description: |
      Vedtak i komponenten arbeid.
      Grain: En rad per vedtak.
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
      Grain: En rad per person per gyldighetsintervall.
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

## Hvordan grain deles for hvert dataprodukt

For hvert dataprodukt skal grain være synlig der konsumentene faktisk leter:

- i modellens yml
- i dbt docs
- i eventuell kontrakt eller produktdokumentasjon

Hvis dataproduktet består av flere sentrale modeller, bør hver modell ha sin egen grainbeskrivelse. Det holder ikke med én generell beskrivelse på toppen av prosjektet.

## Grain skal også testes

Grain som bare står i tekst er ikke nok. Hvis grain er viktig, bør det også testes.

Typiske eksempler:

- `unique` på én kolonne når grain er én rad per nøkkel
- kombinerte unikhetstester når grain er sammensatt
- egne datatester når grain avhenger av historikk eller mer kompleks logikk

Dokumentasjon og test skal peke på samme forståelse av modellen.

## Praktisk tommelfingerregel

- Hvis du ikke kan forklare hva én rad representerer i én setning, er grain for uklar.
- Hvis grain ikke står i yml, er den ikke godt nok dokumentert.
- Hvis grain ikke kan testes, er den ikke godt nok kontrollert.
- Hvis historikk inngår i grain, må det sies eksplisitt.