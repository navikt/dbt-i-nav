# Kjøre `dbt deps`

!!! warning "Arkiv"
  Denne siden er arkivert og er ikke del av anbefalt oppsett lenger. Innholdet beholdes kun for historikk og overgangsbehov. For nytt arbeid, bruk de aktive sidene for Knast og DVH.

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