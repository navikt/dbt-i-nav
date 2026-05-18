
# dbt standarder

Denne seksjonen beskriver hvordan reglene for dataprodukter skal implementeres i dbt.

Den svarer ikke først og fremst på hva et dataprodukt bør love. Det er beskrevet i seksjonen [Dataprodukt](../dataprodukt/index.md).

Denne seksjonen svarer i stedet på:

- hvordan reglene uttrykkes i dbt-prosjektet
- hvordan de dokumenteres i yml og dbt docs
- hvordan de gjøres maskinlesbare i `meta`
- hvordan de verifiseres med dbt-tester

## Skillet vi bruker

Bruk seksjonen `Dataprodukt` når du skal definere:

- granularitet
- historikkprinsipp
- kontrakt
- dokumentasjonskrav
- hva som skal testes

Bruk seksjonen `dbt standarder` når du skal implementere disse valgene i dbt med:

- modellnavn og kolonnenavn
- `description` og `meta`
- prefiks og prosjektstruktur
- generiske tester og singular tester

## Sider i denne seksjonen

- [Granularitet i dbt](grain.md)
- [Historikk i dbt](historikk.md)
- [Navnestandard i dbt](navnestandard.md)
- [Kontrakter i dbt](modellkontrakter.md)
- [Dokumentasjon i dbt](dokumentasjon.md)
- [Testing i dbt](testing.md)

## Hovedregel

Et valg som påvirker kontrakten til dataproduktet skal defineres i `Dataprodukt` først og implementeres i dbt etterpå.

Hvis en side i `dbt standarder` begynner å forklare hva produktet bør love på et konseptuelt nivå, er det som regel et tegn på at innholdet hører hjemme i `Dataprodukt` i stedet.
