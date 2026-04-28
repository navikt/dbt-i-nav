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

## Vanlige argumenter mot dbt i NAV

### «Datateam må håndtere hele ETL‑kjeden, også ingest»
Dette stemmer i dag, men er ikke et teknisk krav.

En moden dataplattform tilbr standardisert ingest, slik at data allerede er tilgjengelig i target‑basene (Oracle i første omgang). Da kan datateam bruke dbt der verdien faktisk ligger: transformasjon, modellering og kvalitet.
dbt erstatter PowerCenter‑mappinger – ikke hele dataplattformen.

### «NAV har et komplekst datalandskap»
NAV er kompleks på systemnivå, men et dedikert datateam jobber mot et eller få avgrensede domener og mest innenfor en database.

dbt håndterer kompleksitet ved å gjøre interne avhengigheter eksplisitte og versjonskontrollerte, isteden for å skjule alt i et sentralv verktøy.

## «Vi trenger et grafisk verktøy for å få oversikt»
Det som etterspørres er som regel oversikt og trygghet, ikke selve GUI‑en. Det er for ekspempel en tydelig terkel å komme igang med git og GitHub.
PowerCenter skjuler kode og avhengigheter i flere lag; dbt gjør alt åpent i kode og gir et tydelig dependency‑graph.
Målet er at utviklingsopplevelsen i dbt skal ligne sprøøringer i Oracle SQL Developer, noe PowerCenter‑utviklere allerede er komfortable med.

## «Vi trenger enterprise‑skalering»
dbt er i dag brukt i store, regulerte virksomheter til kritiske pipelines. Det som skalerer dårlig i NAV er monolittiske ETL‑verktøy med sentral styring og lav endringshastighet.

### dbt gir:
- tydelig eierskap
- testbarhet
- sporbarhet
- CI/CD‑vennlig utvikling

dbt er enterprise‑modent, bare ikke et enterprise‑monolitt‑verktøy.

### Kan jeg ikke bare kjøre SQL med Python?

Ja – for noen enkle spørringer kan det fungere fint. Men når antall spørringer eller kompleksiteten øker, hjelper dbt med å strukturere koden og holde oversikt over kjørerekkefølgen. Det er ikke uvanlig at en komponent består av 30 eller flere SQL-filer som avhenger av hverandre.
