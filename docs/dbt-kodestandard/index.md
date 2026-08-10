
# dbt standarder

Denne seksjonen beskriver bare dbt-spesifikke konsepter og hvordan regler fra `Dataprodukt` skal implementeres i dbt.

For bakgrunn, prinsipper og produktregler, se [../dataprodukt/index.md](../dataprodukt/index.md).

## Denne seksjonen dekker

- modelltyper og navnekonvensjoner i dbt
- hvordan metadata uttrykkes i `description` og `meta`
- hvordan kontrakter gjøres maskinlesbare
- hvordan kontrakter verifiseres med dbt-tester
- hvilke prosjektmønstre vi bruker for eksponerte og interne modeller

## Denne seksjonen dekker ikke

- hvilke løfter dataproduktet bør gi
- hvorfor produktet bør velge en bestemt granularitet
- hvilket historikkprinsipp som er riktig
- hvilke forretningsregler som skal inngå i kontrakten

Slike spørsmål hører hjemme i `Dataprodukt`.

## Sider i denne seksjonen

- [Granularitet i dbt](grain.md)
- [Historikk i dbt](historikk.md)
- [Navnestandard i dbt](navnestandard.md)
- [Kontrakter i dbt](modellkontrakter.md)
- [Dokumentasjon i dbt](dokumentasjon.md)
- [Testing i dbt](testing.md)
