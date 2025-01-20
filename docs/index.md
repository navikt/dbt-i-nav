# Introduksjon til dbt

Data Build Tool (dbt) er et åpen kildekode-verktøy som hjelper dataanalytikere og data engineers med å transformere data mer effektivt. dbt fokuserer på transformasjonsdelen (T) i ETL-prosessen (Extract, Transform, Load). Det lar brukere skrive SQL-spørringer for å definere hvordan data skal transformeres. dbt sørger for at SQLene blir kjørt i riktig rekkefølge slik at sluttproduktet blir oppdatert korrekt. dbt tar seg da av DML og DDL ved å håndtere transaksjoner, opprettelse og sletting av tabeller, med mer. Det er ikke noe behov for å ha kjennskap til Python for å komme i gang med dbt.

dbt Labs har en egen fin introduksjonsside: [What is dbt? (dbt Labs)](https://docs.getdbt.com/docs/introduction)  


## Det er mange fordeler med å bruke dbt (Data Build Tool) for datatransformasjon:

1. **Modularisering og gjenbruk**: dbt lar deg skrive SQL-spørringer som moduler, noe som gjør det enklere å vedlikeholde og gjenbruke kode.
2. **Versjonskontroll**: Integrasjon med versjonskontrollsystemer som Git gjør det mulig å spore endringer og samarbeide effektivt.
3. **Automatisert testing**: dbt støtter automatisert testing av datamodeller, noe som sikrer at dataene er nøyaktige og pålitelige.
4. **Dokumentasjon**: dbt genererer dokumentasjon automatisk, noe som gjør det enklere å forstå og dele datamodeller.
5. **Skalerbarhet**: dbt kan håndtere store datamengder og komplekse transformasjoner, noe som gjør det egnet for både små og store organisasjoner.


## Hva skiller dbt fra tradisjonelle ETL-verktøy?

### 1. **Fokus på transformasjon**:

* **dbt**: Fokuserer utelukkende på transformasjonsdelen av dataflyten, og tilrettelegging av data for analyse. Dette forutsetter at data allerede er lastet til databasen.
* **Tradisjonelle ETL-verktøy**: Håndterer hele prosessen fra utvinning (Extract) til lasting (Load). De er ideelle for miljøer hvor data må hentes fra ulike kilder, transformeres etter komplekse forretningsregler, og deretter lastes inn i flere destinasjoner.

### 2. **Brukervennlighet**:

* **dbt**: Bruker en SQL-sentrisk tilnærming, noe som gjør det enkelt for dataanalytikere og utviklere som allerede er kjent med SQL.
* **Tradisjonelle ETL-verktøy**: Mange ETL-verktøy tilbyr et grafisk brukergrensesnitt, noe som gjør det enklere for ikke-tekniske brukere å designe og administrere dataflyter. 

### 3. **Modularitet og gjenbruk**:

* **dbt**: Oppmuntrer til modularitet ved å la brukere bryte ned komplekse transformasjoner i mindre modeller. Dette gjør det enklere å vedlikeholde og gjenbruke kode.
* **Tradisjonelle ETL-verktøy**: Har ofte komplekse grensesnitt og proprietære språk, noe som kan være utfordrende hvis man ikke er kjent med dem.

### 4. **Testing og dokumentasjon**:

* **dbt**: Inkluderer innebygde funksjoner for testing og dokumentasjon, noe som sikrer at datamodellene er godt dokumentert og pålitelige.
* **Tradisjonelle ETL-verktøy**: Kan kreve mer manuell innsats for å oppnå samme nivå av testing og dokumentasjon.

### 5. **Skalerbarhet**:

* **dbt**: Kan håndtere store datamengder og komplekse transformasjoner, noe som gjør det egnet for både små og store organisasjoner.
* **Tradisjonelle ETL-verktøy**: Bygget for å skalere og kan håndtere enterprise-nivå databehandlingsbehov.

**Referanser**:

[https://learn.growdataskills.com/blog/DBT_vs_Traditional_ETL_Tools](https://learn.growdataskills.com/blog/DBT_vs_Traditional_ETL_Tools)


[https://celerdata.com/glossary/dbt-or-traditional-etl-which-fits-your-needs](https://celerdata.com/glossary/dbt-or-traditional-etl-which-fits-your-needs
)



## Hvilke typer materialiseringer brukes i dbt?

I dbt (Data Build Tool) finnes det flere materialiseringsstrategier som kan brukes til å definere hvordan data skal lagres og behandles. Her er noen av de vanligste:

### 1. **View**

**Fordeler**:

* **Rask oppdatering**: Dataene er alltid oppdatert fordi visningen henter data direkte fra kildetabellene hver gang den kjøres.
* **Lite lagringsbehov**: Siden visninger ikke lagrer data fysisk, krever de mindre lagringsplass.

**Ulemper**:

* **Ytelse**: Kan være tregere ved komplekse spørringer, siden dataene må hentes og behandles hver gang visningen kjøres.
* **Avhengighet**: Avhenger av at kildetabellene er tilgjengelige og oppdaterte.

### 2. **Table**

**Fordeler**:

* **Ytelse**: Bedre ytelse for komplekse spørringer, siden dataene er forhåndsberegnet og lagret.
* **Stabilitet**: Dataene er lagret fysisk, noe som gjør dem mindre avhengige av kildetabellenes tilgjengelighet.

**Ulemper**:

* **Lagringsbehov**: Krever mer lagringsplass, siden dataene lagres fysisk.
* **Oppdatering**: Dataene må oppdateres regelmessig for å sikre at de er oppdaterte, og tabellen lages på nytt ved hver kjøring (CTAS).

### 3. **Incremental**

**Fordeler**:

* **Effektivitet**: Bare nye eller endrede data behandles, noe som reduserer belastningen på systemet.
* **Ytelse**: Raskere oppdateringer sammenlignet med fullstendige oppdateringer av hele tabellen.

**Ulemper**:

* **Kompleksitet**: Krever mer kompleks logikk for å håndtere inkrementelle oppdateringer.
* **Feilhåndtering**: Kan være utfordrende å håndtere feil og sikre at alle data er korrekte.

### 4. **Ephemeral**

**Fordeler**:

* **Fleksibilitet**: Brukes til å lage midlertidige tabeller som kun eksisterer under kjøringen av en spørring.
* **Ingen lagringsbehov**: Krever ingen lagringsplass, siden dataene ikke lagres fysisk.

**Ulemper**:

* **Ytelse**: Kan påvirke ytelsen hvis de brukes i komplekse spørringer, siden dataene må behandles hver gang spørringen kjøres.
* **Begrenset bruk**: Egner seg best for midlertidige transformasjoner og ikke for lagring av data.



## dbt-core eller dbt-cloud hos NAV

dbt kommer både i som open source i form av [``dbt-core``](https://docs.getdbt.com/docs/core/installation) og i en egen cloud versjon, [``dbt cloud``](https://www.getdbt.com/product/dbt-cloud/). Cloud versjonen støtter kun skydatabaser som feks. BigQuery og Snowflake. dbt Cloud kan derfor ikke brukes mot Oracle onprem databasen til datavarehus. For datasett som befinner seg på datamarkedsplassen i BigQuery, kan dbt Cloud være en mulighet. 

For Oracle on-prem benytter vi dbt-oracle som er en python-pakke som baserer seg på dbt-core. Oracle er ikke offisielt støttet av dbt, men Oracle har tatt ansvar for community connectoren og og blir aktiv vedlikeholdt og fortløpende oppdatert til siste versjon av dbt-core. 

For å nå on-prem Oracle brukes i dag VDI Utvikler, men Knast skal erstatte denne løsningen. Det vil bli tilrettelagt oppsett for Knast som skal gjøre det enkelt å komme i gang med dbt. 

## Lenker

Før du går gjennom detaljene på hvordan dbt bør settes opp er det lurt å bli kjent med hvordan dbt fungerer. Nedenfor er det et knippe nyttige lenker som hjelper deg med å komme igang og lære de viktigste kommandoene og funksjonene i dbt.

### Kurs - dbt fundamentals

Det finnes et [fundamentals kurs](https://courses.getdbt.com/courses/fundamentals) hos dbt labs. Dette kurset bruker dbt cloud, men mesteparten av innholdet kan overføres til dbt-core.

dbt-i-nav jobber med å tilby et kursmiljø basert på GitHub Codespaces og dbt-core, [dbt-i-nav-intro-kurs](https://github.com/navikt/dbt-i-nav-intro-kurs). Mer info kommer! 

### Designprinsipper

[How to design a dbt model from scratch](https://towardsdatascience.com/how-to-design-a-dbt-model-from-scratch-8c72c7684203). Hvordan bør du tenke nå du designer nye modeller med dbt? Det er fort gjort å bomme på første forsøk, og det koster mye tid.

### Dimensjonsmodellering

Kimball er fortsatt relevant med dbt. 
[Building a Kimball dimensional model with dbt](https://docs.getdbt.com/blog/kimball-dimensional-model)

### Bok

Det er nylig (juni 2023) lansert en bok om 
[Data Engineering with dbt](https://learning.oreilly.com/library/view/-/9781803246284/). Boken inneholder instroduksjon til data engineering generelt og endelt om ulike skydatabaser i tillegg til grunnleggende bruk av dbt. Kanskje den mest interessante delen er kapittel 8 som omhandler testing med dbt.

### Nyttige lenker

dbt's egne guider: [Lessons](https://www.getdbt.com/dbt-learn/lessons/)

Community basert samling av lenker: [awsome-dbt](https://github.com/Hiflylabs/awesome-dbt)

## Hvorfor skal jeg bruke dbt? Jeg kan jo kjøre SQL med Python

Det er riktig. Dersom du bare skal kjøre noen enkle SQL spørringer er det kanskje like greit å sette opp en Pythonjobb som kjører SQLen for deg. Men med en gang antall spørringer eller kompleksiteten på spørringene øker vil dbt hjelpe med med å strukturere koden og holde oversikt over rekkefølgen. Det er ikke uvanlig at en komponent består av 30 eller flere SQL filer som avhenger av hverandre.