# SQL-formattering med SQLFluff

[SQLFluff](https://sqlfluff.com/) er et linting- og formatteringsverktøy for SQL. I dbt-prosjekter brukes det til å holde SQL-koden konsistent på tvers av bidragsytere – tilsvarende det `black` gjør for Python.

## Installer SQLFluff

SQLFluff er allerede tilgjengelig i Knast. Sjekk versjon med:

```shell
sqlfluff version
```

Vil du installere det lokalt:

```shell
pip install sqlfluff sqlfluff-templater-dbt
```

## Konfigurasjon

SQLFluff konfigureres via en `.sqlfluff`-fil i roten av dbt-prosjektet. Eksempel tilpasset NAV/Oracle/dbt:

```ini
[sqlfluff]
templater = dbt
dialect = ansi
exclude_rules = RF05

[sqlfluff:templater:dbt]
project_dir = .

[sqlfluff:indentation]
tab_space_size = 4

[sqlfluff:rules:capitalisation.keywords]
capitalisation_policy = upper

[sqlfluff:rules:capitalisation.identifiers]
capitalisation_policy = lower

[sqlfluff:rules:capitalisation.functions]
capitalisation_policy = upper

[sqlfluff:rules:layout.long_lines]
max_line_length = 120
```

!!! note "Oracle og dialect"
    SQLFluff støtter ikke Oracle-dialect direkte. Bruk `ansi` som dialect og legg eventuelt til Oracle-spesifikke unntak ved behov.

## Bruk

### Lint én fil

```shell
sqlfluff lint models/staging/stg_kilde__hendelser.sql
```

### Lint hele prosjektet

```shell
sqlfluff lint models/
```

### Fiks automatisk

```shell
sqlfluff fix models/staging/stg_kilde__hendelser.sql
```

!!! warning "Sjekk endringer etter fix"
    `sqlfluff fix` endrer filer på disk. Gjennomgå diff-en i Git før du committer.

## Integrasjon med dbt-templater

For at SQLFluff skal forstå `{{ ref() }}`, `{{ source() }}` og Jinja-kode i dbt-modeller, må du bruke `dbt`-templater. Dette krever at dbt er installert i samme miljø og at prosjektet er konfigurert.

```ini
[sqlfluff]
templater = dbt
```

Alternativt kan du bruke `jinja`-templater som er raskere, men som ikke forstår dbt-makroer fullt ut:

```ini
[sqlfluff]
templater = jinja
```

## Legg til i CI/CD

For å hindre dårlig formatert SQL i main, kan SQLFluff kjøres i GitHub Actions:

```yaml
- name: Lint SQL
  run: sqlfluff lint models/ --dialect ansi
```

## Ignorer filer

Legg til en `.sqlfluffignore`-fil for å ekskludere mapper eller filer:

```
target/
dbt_packages/
macros/
```

## Lenker

- [SQLFluff-dokumentasjon](https://docs.sqlfluff.com/)
- [SQLFluff-regler](https://docs.sqlfluff.com/en/stable/reference/rules.html)
- [dbt + SQLFluff oppsett](https://docs.sqlfluff.com/en/stable/configuration/templating/dbt.html)
