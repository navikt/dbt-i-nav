# Hvorfor dbt?

## dbt vs. tradisjonelle ETL-verktøy

dbt fokuserer utelukkende på **transformasjon** (T i ETL) og forutsetter at data allerede er lastet til databasen. Tradisjonelle ETL-verktøy håndterer hele kjeden fra utvinning til lasting.

| | dbt | Tradisjonelle ETL-verktøy |
|---|---|---|
| **Fokus** | Transformasjon | Hele ETL-kjeden |
| **Grensesnitt** | SQL | Grafisk eller proprietært språk |
| **Modularitet** | Høy – modeller kan gjenbrukes | Varierer, ofte lav |
| **Testing** | Innebygd | Manuell innsats |
| **Versjonskontroll** | Git-native | Varierer |

**Referanser**:
- [DBT vs Traditional ETL Tools](https://learn.growdataskills.com/blog/DBT_vs_Traditional_ETL_Tools)
- [dbt or traditional ETL – which fits your needs?](https://celerdata.com/glossary/dbt-or-traditional-etl-which-fits-your-needs)

## Kan jeg ikke bare kjøre SQL med Python?

Ja – for noen enkle spørringer kan det fungere fint. Men når antall spørringer eller kompleksiteten øker, hjelper dbt med å strukturere koden og holde oversikt over kjørerekkefølgen. Det er ikke uvanlig at en komponent består av 30 eller flere SQL-filer som avhenger av hverandre.
