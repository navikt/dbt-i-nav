# Testing i dbt

Denne siden beskriver hvordan kontraktskrav verifiseres i dbt.

For bakgrunn og produktregler, se [../dataprodukt/testing.md](../dataprodukt/testing.md).

## Hovedregel

Eksponerte modeller skal ha dbt-tester som støtter kontrakten.

## Vanlige testmønstre i dbt

- `not_null` på nøkkelkolonner
- `unique` når granulariteten er én rad per nøkkel
- kombinasjonsunikhet når granulariteten består av flere kolonner
- singular tester for historikkregler som overlapp, hull eller etterregistreringer

## Enkel modell

```yaml
models:
  - name: fak_vedtak
    columns:
      - name: vedtak_id
        tests:
          - not_null
          - unique
```

## Sammensatt granularitet

```yaml
models:
  - name: fak_person_maaned
    columns:
      - name: person_id
        tests:
          - not_null
      - name: maaned
        tests:
          - not_null
    tests:
      - dbt_utils.unique_combination_of_columns:
          combination_of_columns:
            - person_id
            - maaned
```

## Historisert modell

```yaml
models:
  - name: dim_person
    tests:
      - dbt_utils.unique_combination_of_columns:
          combination_of_columns:
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

Eksempel på singular test:

```sql
select
    person_id,
    gyldig_fom_dato,
    count(*) as antall
from {{ ref('dim_person') }}
group by 1, 2
having count(*) > 1
```

## OBT eller bred joinet modell

```yaml
models:
  - name: obt_oppfolging_person
    columns:
      - name: person_id
        tests:
          - not_null
          - unique
```

## Hva som bør henge sammen

- teksten i `description`
- `meta.grain` og `meta.grain_keys`
- testene på modellen

Hvis disse peker i ulike retninger, er kontrakten ikke godt nok verifisert i dbt.