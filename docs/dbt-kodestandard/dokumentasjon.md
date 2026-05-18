# Dokumentasjon

Dokumentasjon i dbt skal ikke være pynt. Den skal gjøre det mulig å forstå, bruke og forvalte et dataprodukt uten å lese SQL-en.

Målet med denne siden er å beskrive minimumsstandarden for dokumentasjon av modeller i dbt.

## Formål

Dokumentasjonen skal gjøre det mulig å forstå:

- hva modellen representerer
- hva én rad representerer
- hvilke nøkkelkolonner som identifiserer granulariteten
- hvordan historikk skal tolkes
- hvilke kolonner som er sentrale for konsum
- hvem som eier modellen

Hvis dette ikke er dokumentert, er modellen ikke godt nok delt.

## Hovedregel

Alle eksponerte modeller skal dokumenteres i yml.

Dette gjelder for:

- `dim_`-modeller
- `fak_`-modeller
- `obt_`-modeller
- andre modeller som deles på tvers av team

I praksis betyr dette at dokumentasjonen skal ligge tett på modellen, versjoneres sammen med koden og publiseres i dbt docs.

## Minimumskrav for en eksponert modell

For hver eksponert modell skal følgende være dokumentert:

- modellbeskrivelse
- granularitet
- nøkkelkolonner som identifiserer granulariteten
- historikk, hvis modellen er historisert
- beskrivelse av sentrale kolonner
- grunnleggende tester som støtter dokumentasjonen

Dette henger tett sammen med [Granularitet](grain.md), [historikk.md](historikk.md), [navnestandard.md](navnestandard.md) og [modellkontrakter.md](modellkontrakter.md).

## Hva som skal stå i modellbeskrivelsen

Beskrivelsen av modellen skal være kort, men presis.

Den bør minst svare på:

- hva modellen inneholder
- hvem eller hva modellen beskriver
- om modellen er historisert
- hva granulariteten er

En god modellbeskrivelse er ofte 3 til 6 linjer, ikke én vag setning.

Eksempel:

```yaml
models:
  - name: fak_vedtak
    description: |
      Vedtak i komponenten arbeid.
      Modellen brukes som grunnlag for analyse av vedtak og vedtaksstatus.
      Granularitet: En rad per vedtak.
      Historikk: Modellen er ikke historisert.
```

    ## Granularitet skal dokumenteres eksplisitt

    Granularitet skal stå i modellens dokumentasjon, ikke bare være implisitt i navn eller tester.

Eksempel:

    - `Granularitet: En rad per person.`
    - `Granularitet: En rad per person per gyldighetsintervall.`
    - `Granularitet: En rad per person per måned.`

    Hvis granulariteten er sammensatt eller historisert, skal dette komme tydelig frem.

## Historikk skal dokumenteres eksplisitt

Hvis modellen er historisert, skal dokumentasjonen forklare:

- at modellen er historisert
- hva gyldighetsintervallet betyr
- hvilken oppløsning som brukes
- hvilke kolonner som uttrykker historikken

Eksempel:

```yaml
models:
  - name: dim_person
    description: |
      Persondimensjon med historikk.
      Granularitet: En rad per person per gyldighetsintervall.
      Historikk: Gyldighetsintervallet beskriver perioden raden var gyldig i kilden.
```

## Kolonner skal dokumenteres selektivt, men tydelig

Ikke alle kolonner trenger lange beskrivelser, men alle sentrale kolonner skal ha dokumentasjon.

Særlig viktig er:

- nøkler
- forretningskritiske felter
- historikkfelter
- felter som ofte misforstås
- felter med kodeverdier eller avledet logikk

En kolonnebeskrivelse bør forklare hva feltet betyr, ikke bare gjenta navnet.

Dårlig eksempel:

- `person_id: Id for person`

Bedre eksempel:

- `person_id: Stabil identifikator for personen slik den brukes i dataproduktet.`

## Meta skal brukes for strukturert dokumentasjon

Der det er nyttig, skal dokumentasjonen også legges i `meta`, slik at den blir maskinlesbar.

I løpende tekst bruker vi `granularitet`, men i `meta` skal vi bruke `grain` og `grain_keys`. Det er en bevisst standard for å unngå sprik i kontraktene.

Anbefalte metadata for eksponerte modeller:

- `owner`
- `grain`
- `grain_keys`
- `historikk`
- `historikk_kolonner`

Eksempel:

```yaml
models:
  - name: dim_person
    meta:
      owner: arbeid
      grain: En rad per person per gyldighetsintervall
      grain_keys:
        - person_id
        - gyldig_fom_dato
      historikk: dato
      historikk_kolonner:
        - gyldig_fom_dato
        - gyldig_tom_dato
        - er_gjeldende
```

## Dokumentasjon og tester skal henge sammen

Dokumentasjon uten tester blir fort foreldet. Tester uten dokumentasjon er vanskelige å forstå.

Derfor skal sentrale påstander i dokumentasjonen normalt støttes av tester, for eksempel:

- `not_null` på nøkkelkolonner
- `unique` når granulariteten er én rad per nøkkel
- sammensatte unikhetstester for sammensatt granularitet
- egne tester for historikk når modellen er historisert

## Dokumentasjon i dbt docs

Det som ligger i yml skal være nok til at dbt docs blir nyttig for andre team.

Det betyr at en konsument skal kunne åpne modellen i dbt docs og forstå:

- hva modellen er
- hva granulariteten er
- om modellen er historisert
- hvilke kolonner som er sentrale

Hvis man fortsatt må lese SQL for å forstå modellen, er dokumentasjonen for svak.

## Praktisk minimum før en modell deles

Før en modell regnes som delt eller eksponert, skal følgende være på plass:

- beskrivelse i yml
- eksplisitt granularitet
- dokumenterte nøkkelkolonner
- historikkbeskrivelse hvis relevant
- dokumentasjon av sentrale kolonner
- grunnleggende tester

## Tommelfingerregel

- Dokumentasjon skal bo i yml.
- Granularitet og historikk skal stå i klartekst.
- Viktige kolonner skal beskrives, ikke bare listes.
- dbt docs skal være nok til å forstå modellen på høyt nivå.
- Hvis dokumentasjonen ikke hjelper en annen produsent eller konsument, er den ikke god nok.
