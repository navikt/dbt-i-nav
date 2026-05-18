
# Granularitet i dbt

Denne siden beskriver hvordan reglene for granularitet skal implementeres i dbt.

Selve regelen for hva et dataprodukt skal love om granularitet er beskrevet i [../dataprodukt/granularitet.md](../dataprodukt/granularitet.md).

## Hovedregel i dbt

Når en modell er eksponert, skal granulariteten uttrykkes på en måte som er både lesbar for mennesker og maskinlesbar for videre bruk.

I praksis betyr det:

- `Granularitet: ...` i `description`
- `grain` i `meta`
- `grain_keys` i `meta`
- tester som verifiserer samme forståelse

## Hvordan skrive dette i yml

Anbefalt minimum for en eksponert modell er:

- en kort modellbeskrivelse
- en eksplisitt setning om granularitet i `description`
- `meta.grain`
- `meta.grain_keys`
- relevante tester på kolonnene som identifiserer granulariteten

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

## Hvorfor vi bruker `grain` i `meta`

I løpende norsk tekst bruker vi `granularitet`.

I `meta` bruker vi `grain` og `grain_keys` konsekvent. Det gjør kontraktene enklere å koordinere på tvers av produkter og ligger tett på innarbeidet språkbruk i dbt-miljøer.

## Hva som skal henge sammen

Følgende skal peke på samme forståelse:

- teksten i `description`
- `meta.grain`
- `meta.grain_keys`
- testene på modellen

Hvis disse peker i ulike retninger, er modellen ikke godt nok implementert i dbt.