# Installere dbt-oracle på VDI

## Forutsetninger

For å kunne utvikle dbt mot oracle må man ha tilgang til utviklerimage som er et VDI som kjører i i NAV datahall. Dette er for å kunne få kontakt med Oracle databaser. Du må også har fått en eller felere databasebrukere og det er nyttig å kunne koble seg opp mot databasene med SQL Developer. Se følgende lenker:

- [Utviklerimage](https://confluence.adeo.no/x/LCQSF)
- [SQL Developer med databasebruker](https://confluence.adeo.no/x/pIzzFg)


## Installasjon av dbt-oracle

For å installere dbt-core for Oracle må du installere følgende:

1. [Python 3.11.x](python.md)
2. [PIP og oppsett av dbt-miljø](pip-og-oppsett.md)
3. [Git / GitHub Desktop](git.md)
4. [dbt](dbt.md)

## Anbefalinger

For en god utvikleropplevelse anbefaler vi deg å ha følgende installert:

- [Visual studio code](vscode.md) eller en annen tekst editor
    - [dbt Power User](dbt-power-user.md) En svært nyttig VS Code extension
- [SQLFluff](sqlfluff.md)
