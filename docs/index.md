# Introduksjon til dbt

dbt (data build tool) er et SQL basert transformasjonsvektøy som lar deg modularisere og skrive testbar SQL kode. dbt sørger for at SQLene blir kjørt i riktig rekkefølge slik at sluttproduktet blir oppdatert korrekt.

En SQL fil i dbt blir kalt en ``modell`` i dbt. Modeller kan materialiseres på ulike måter. Som view, tabell eller rett og slett en SQL snutt som kan gjenbrukes i flere modeller etter DRY-prinsippet. 

dbt er IKKE et extract-load verktøy. Det betyr at dataene som skal transformeres allerede må ligge i databasen dbt er koblet til. dbt krever altså at data er lastet på forhånd, med feks en pythonjobb eller kafkakonsument. Dataene trenger ikke nødvendigvis ligge i samme komponentskjema eller samme BigQuery prosjekt. Så lenge dataene er tilgjengelig på samme database og dbt service brukeren har tilgang til å lese dataene er du good to go.

dbt kommer både i som open source i form av [``dbt-core``](https://docs.getdbt.com/docs/core/installation) og i en egen cloud versjon, [``dbt cloud``](https://www.getdbt.com/product/dbt-cloud/). Cloud versjonen støtter kun skydatabaser som feks. BigQuery og Snowflake. dbt Cloud kan derfor ikke brukes mot Oracle onprem databasen til datavarehus. For datasett som befinner seg på datamarkedsplassen i BigQuery, kan dbt Cloud være en mulighet. 

For Oracle on-prem benytter vi dbt-oracle som er en python pakke som baserer seg på dbt-core. Oracle er ikke offisielt støttet av dbt, men Oracle har tatt ansvar for community connectoren og og blir aktiv vedlikeholdt og fortløpende oppdatert til siste versjon av dbt-core. 
For å nå on-prem Oracle må vi som kjent benytte utviklerimage. Denne guiden tar for seg installasjon og oppsett av dbt-oracle på vdi utvikler gjennom Visual Studio Code.

## Lenker

Før du går gjennom detaljene på hvordan dbt bør settes opp er det lurt å bli kjent med hvordan dbt fungerer. Nedenfor er det et knippe nyttige lenker som hjelper deg med å komme igang og lære de viktigste kommandoene og funksjonene i dbt.

### Kurs - dbt fundamentals

Det er sterkt anbefalt å starte med å gå gjennom [fundamentals kurset](https://courses.getdbt.com/courses/fundamentals) til dbt labs. Dette kurset bruker dbt cloud, men mesteparten av innholdet kan overføres til dbt-core. Bruk gjerne GCP dev miljøet til teamet for å sette opp testprosjektet i BigQuery, men husk på å slette ressursene i etterkant

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