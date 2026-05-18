# Kontrakter i dbt

Denne siden beskriver hvordan kontrakter implementeres i dbt.

For bakgrunn og produktregler, se [../dataprodukt/kontrakter.md](../dataprodukt/kontrakter.md).

## Hvor kontrakten skal ligge

I dbt skal kontrakten ligge i modellens yml.

Som minimum bør kontrakten uttrykkes i:

- `description`, for mennesker og dbt docs
- `meta`, for maskinlesbare metadata
- tester, for å verifisere at kontrakten faktisk holder

I denne dokumentasjonen bruker vi `granularitet` i løpende tekst, men `grain` og `grain_keys` i `meta`.

## Anbefalt struktur i yml

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

## Hvordan kontrakten verifiseres

Kontrakten bør i dbt støttes av tester, for eksempel:

- `not_null` på nøkkelkolonner
- `unique` når granulariteten er én rad per nøkkel
- sammensatte unikhetstester når granulariteten består av flere kolonner
- egne tester for historikk når modellen er historisert