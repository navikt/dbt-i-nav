# Modellkontrakter

Eksponerte modeller, det være seg interne, mellom dataprodusenter, eller eksternt mot sluttbrukere, må ha tydelige metadata landet i en kontrakt.

Kontrakten skal gjøre det mulig å forstå og bruke modellen uten å lese SQL-en.

## Formål

En modellkontrakt skal gjøre det tydelig:

- hva modellen representerer
- hva én rad i modellen representerer
- hvilke kolonner som identifiserer raden
- hvordan historikk skal forstås
- hvilke felter som er stabile og trygge å bruke videre

Hvis dette ikke er dokumentert, er modellen ikke godt nok eksponert.

## Hovedregel

Alle eksponerte modeller skal ha en modellkontrakt.

Dette gjelder for:

- `dim_`-modeller
- `fak_`-modeller
- `obt_`-modeller
- andre modeller som deles på tvers av team eller brukes som konsumflate

## Minimumskrav i kontrakten

Følgende metadata er obligatoriske i kontrakten for alle eksponerte modeller:

- formål: hva modellen brukes til
- granularitet: hva én rad representerer
- nøkkelkolonner: hvilke kolonner som identifiserer granulariteten
- historikk: om modellen er historisert, og hvordan historikken skal forstås
- sentrale forretningskolonner: hvilke felt konsumenter forventes å bruke

## Granularitet er obligatorisk

Granularitet skal alltid beskrives eksplisitt i kontrakten.

Det holder ikke å skrive at modellen er en dimensjon, faktamodell eller OBT. Kontrakten skal si hva én rad faktisk representerer.

Eksempler:

- En rad per person
- En rad per vedtak
- En rad per person per gyldighetsintervall
- En rad per person per måned

Se også [Granularitet](grain.md).

## Historikk er obligatorisk når modellen er historisert

Hvis modellen inneholder historikk, skal kontrakten beskrive dette eksplisitt.

Det skal minst fremgå:

- om modellen er historisert
- hva gyldighetsintervallet betyr
- hvilken oppløsning historikken bruker, for eksempel dato, tid eller timestamp
- hvilke kolonner som uttrykker historikken

Kontrakten skal gjøre det mulig å forstå forskjellen på:

- når noe gjaldt i kilden
- når det ble lastet eller oppdatert i dataproduktet

Se også [historikk.md](historikk.md) og [navnestandard.md](navnestandard.md).

## Nøkkelkolonner er obligatoriske

Kontrakten skal alltid gjøre det tydelig hvilke kolonner som identifiserer granulariteten.

Dette gjelder både:

- forretningsnøkler, for eksempel `person_id` eller `vedtak_id`
- tekniske nøkler, for eksempel surrogate nøkler som `person_key`
- sammensatte nøkler der granulariteten avhenger av flere kolonner

Hvis granulariteten identifiseres av en kombinasjon av kolonner, skal hele kombinasjonen dokumenteres.

## Hvor kontrakten skal ligge

I dbt skal kontrakten ligge i modellens yml.

Som minimum bør kontrakten uttrykkes i:

- `description`, for mennesker og dbt docs
- `meta`, for maskinlesbare metadata
- tester, for å verifisere at kontrakten faktisk holder

I denne dokumentasjonen bruker vi `granularitet` i løpende tekst, men `grain` og `grain_keys` i `meta`. Det er en bevisst regel for å holde kontraktene koordinerte.

## Anbefalt struktur i yml

Eksempel:

```yaml
models:
  - name: fak_vedtak
    description: |
      Vedtak i komponenten arbeid.
      Granularitet: En rad per vedtak.
      Historikk: Modellen er ikke historisert.
    meta:
      owner: arbeid
      grain: En rad per vedtak
      grain_keys:
        - vedtak_id
      historikk: ingen
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
      Historikk: Gyldighetsintervallet beskriver perioden raden var gyldig i kilden.
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
    columns:
      - name: person_id
        tests:
          - not_null
      - name: gyldig_fom_dato
        tests:
          - not_null
```

## Kontrakten skal kunne testes

En kontrakt som bare finnes i fritekst er ikke sterk nok.

Derfor skal kontrakten så langt som mulig støttes av tester, for eksempel:

- `not_null` på nøkkelkolonner
- `unique` når granulariteten er én rad per nøkkel
- sammensatte unikhetstester når granulariteten består av flere kolonner
- egne tester for historikk når modellen er historisert

## Praktisk minimum

Før en modell eksponeres, skal følgende være på plass:

- modellbeskrivelse
- eksplisitt granularitet
- identifiserte nøkkelkolonner
- historikkbeskrivelse hvis relevant
- grunnleggende tester som støtter kontrakten

Hvis dette ikke finnes i yml, er kontrakten ikke ferdig.