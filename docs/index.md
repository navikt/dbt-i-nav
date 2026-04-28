# Introduksjon til dbt

Data Build Tool (dbt) er et åpen kildekode-verktøy som hjelper dataanalytikere og data engineers med å transformere data mer effektivt. dbt fokuserer på transformasjonsdelen (T) i ETL-prosessen (Extract, Transform, Load) – det forutsetter at data allerede er lastet til databasen. Du skriver SQL, og dbt sørger for riktig kjørerekkefølge, håndterer DDL/DML og holder orden på avhengigheter. Det er ikke noe behov for å ha kjennskap til Python for å komme i gang.

dbt Labs har en egen introduksjonsside: [What is dbt? (dbt Labs)](https://docs.getdbt.com/docs/introduction)

## Fordeler med dbt

1. **Modularisering og gjenbruk**: SQL skrives som moduler som er enkle å vedlikeholde og gjenbruke.
2. **Versjonskontroll**: Integrasjon med Git gjør det mulig å spore endringer og samarbeide effektivt.
3. **Automatisert testing**: Innebygd teststøtte sikrer at datamodellene er nøyaktige og pålitelige.
4. **Dokumentasjon**: dbt genererer dokumentasjon automatisk fra kode og skjemadefinisjonene.
5. **Skalerbarhet**: Egnet for alt fra enkle transformasjoner til komplekse pipelines med 30+ avhengige SQL-filer.

Lurer du på om dbt passer bedre enn å kjøre SQL direkte fra Python? Med en gang antall spørringer eller kompleksiteten øker, hjelper dbt med å strukturere koden og holde oversikt over kjørerekkefølgen.

## dbt-core eller dbt-cloud hos NAV

dbt finnes som open source ([`dbt-core`](https://docs.getdbt.com/docs/core/installation)) og som skybasert tjeneste ([`dbt Cloud`](https://www.getdbt.com/product/dbt-cloud/)). dbt Cloud støtter kun skydatabaser som BigQuery og Snowflake, og kan ikke brukes mot Oracle on-prem.

For Oracle on-prem bruker vi [`dbt-oracle`](https://docs.getdbt.com/docs/core/connect-data-platform/oracle-setup) – en community-connector vedlikeholdt av Oracle, basert på dbt-core. Utviklingsmiljøet er Knast.

For materialisering og arkitekturvalg, se [Materialiseringsstrategier](arkitektur/materialisering.md).

## Lenker

### Kurs - dbt fundamentals

Det finnes et [fundamentals kurs](https://courses.getdbt.com/courses/fundamentals) hos dbt labs. Dette kurset bruker dbt cloud, men mesteparten av innholdet kan overføres til dbt-core.

Det finnes også et kursmiljø basert på GitHub Codespaces og dbt-core: [dbt-i-nav-intro-kurs](https://github.com/navikt/dbt-i-nav-intro-kurs).

### Designprinsipper

[How to design a dbt model from scratch](https://towardsdatascience.com/how-to-design-a-dbt-model-from-scratch-8c72c7684203) – hvordan tenke når du designer nye modeller.

### Dimensjonsmodellering

Kimball er fortsatt relevant med dbt:
[Building a Kimball dimensional model with dbt](https://docs.getdbt.com/blog/kimball-dimensional-model)

### Bok

[Data Engineering with dbt](https://learning.oreilly.com/library/view/-/9781803246284/) – introduksjon til data engineering og grunnleggende dbt-bruk. Kapittel 8 om testing er særlig relevant.

### Nyttige lenker

- dbt's egne guider: [Lessons](https://www.getdbt.com/dbt-learn/lessons/)
- Community-samling av ressurser: [awesome-dbt](https://github.com/Hiflylabs/awesome-dbt)