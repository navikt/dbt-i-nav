# Kjøre `dbt deps`

For å kjøre `dbt deps` i Knast, følgende URL må åpnes under Internettåpninger på `Min Knast` side:

- `codeload.github.com/dbt-labs/dbt-utils/tar.gz/*`
- `hub.getdbt.com/api/v1/*`
- `github.com/dbt-labs/dbt-utils.git`

Oppsett for `packages.yml`:
```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.3.3
```


!!!question "Spørsmål?"
    Skriv gjerne på [Slack](https://nav-it.slack.com/archives/C0859E82VA6)