# Testoppsett i dbt

Testing er en av de viktigste styrkene i dbt: tester bor tett på modellene og kjøres som en naturlig del av `dbt build`.

## Grunnleggende testsyntaks

Fra dbt 1.8 brukes `data_tests:` i stedet for det gamle `tests:`.

```yaml
models:
  - name: dim_person
    columns:
      - name: pk_dim_person
        data_tests:
          - unique
          - not_null
```

!!! warning "Bruk `data_tests`, ikke `tests`"
    `tests:` er deprecated fra dbt 1.8. Bruk `data_tests:` i alle nye og oppdaterte filer.

## Standard tester per lag

| Lag | Minimum | Anbefalt i tillegg |
|---|---|---|
| Staging | `not_null` og `unique` på primærnøkkel | `accepted_values` på statuskoder |
| Intermediate | `not_null` på primærnøkkel | `relationships` mot staging-modeller |
| Marts | `not_null` og `unique` på primærnøkkel | `relationships`, `accepted_values`, egendefinerte tester |

## Innebygde testtyper

### `not_null`
Sjekker at kolonnen ikke inneholder NULL-verdier.

```yaml
- name: pk_dim_person
  data_tests:
    - not_null
```

### `unique`
Sjekker at alle verdier i kolonnen er unike.

```yaml
- name: pk_dim_person
  data_tests:
    - unique
```

### `accepted_values`
Sjekker at kolonnen kun inneholder verdier fra en gitt liste.

```yaml
- name: status
  data_tests:
    - accepted_values:
        values: ['aktiv', 'inaktiv', 'slettet']
```

### `relationships`
Sjekker referanseintegritet mot en annen modell – tilsvarer en fremmednøkkel-sjekk.

```yaml
- name: fk_dim_person
  data_tests:
    - relationships:
        to: ref('dim_person')
        field: pk_dim_person
```

## Eksempel: komplett modell-YAML

```yaml
models:
  - name: fak_hendelser
    description: Faktatabell over hendelser per person.
    columns:
      - name: pk_fak_hendelser
        description: Primærnøkkel.
        data_tests:
          - unique
          - not_null

      - name: fk_dim_person
        description: Referanse til dim_person.
        data_tests:
          - not_null
          - relationships:
              to: ref('dim_person')
              field: pk_dim_person

      - name: hendelse_type
        description: Type hendelse.
        data_tests:
          - not_null
          - accepted_values:
              values: ['A', 'B', 'C']

      - name: hendelse_ts
        description: Tidspunkt for hendelsen i UTC.
        data_tests:
          - not_null
```

## Egendefinerte tester

Egendefinerte tester legges i `tests/`-mappen som SQL-filer. En test består av en spørring som returnerer rader ved feil – ingen rader betyr bestått.

```sql
-- tests/assert_positive_amount.sql
select *
from {{ ref('fak_hendelser') }}
where belop_nok < 0
```

## Kjøre tester

```shell
dbt test                          # Alle tester
dbt test --select modellnavn      # Tester for én modell
dbt build --select modellnavn     # Bygg og test i ett steg
```

## Tester og `dbt-utils`

[`dbt-utils`](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/)-pakken gir tilgang til flere nyttige tester, blant annet:

- `dbt_utils.unique_combination_of_columns` – unik kombinasjon av flere kolonner (sammensatt primærnøkkel)
- `dbt_utils.expression_is_true` – sjekk at et SQL-uttrykk er sant for alle rader
- `dbt_utils.not_constant` – sjekk at en kolonne ikke har samme verdi i alle rader

Eksempel:

```yaml
- name: fak_hendelser
  data_tests:
    - dbt_utils.unique_combination_of_columns:
        combination_of_columns:
          - fk_dim_person
          - hendelse_ts
```

For å bruke `dbt-utils`, legg det til i `packages.yml`:

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: [">=1.0.0", "<2.0.0"]
```

Og kjør `dbt deps` for å installere.
