
# Granularitet i dbt

Denne siden beskriver hvordan granularitet uttrykkes i dbt.

For bakgrunn og produktregler, se [../dataprodukt/granularitet.md](../dataprodukt/granularitet.md).

## Hovedregel i dbt

Når en modell er eksponert, skal granulariteten uttrykkes både som lesbar tekst og som strukturert metadata.

I praksis betyr det:

- `Granularitet: ...` i `description`
- `grain` i `meta`
- `grain_keys` i `meta`
- tester som verifiserer samme forståelse

## Anbefalt struktur i yml

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

## Hva som skal henge sammen i dbt

- teksten i `description`
- `meta.grain`
- `meta.grain_keys`
- testene på modellen

Hvis disse peker i ulike retninger, er modellen ikke godt nok implementert i dbt.