# Materialiseringsstrategier

[Hva er materialiseringer i dbt?](https://docs.getdbt.com/docs/build/materializations). dbt-oracle støtter alle former for materialisering.

Generelt er det en god ide å følge [Best practices for materializations](https://docs.getdbt.com/best-practices/materializations/5-best-practices) fra dbt labs.

Det er likevel noen avvik:

1. Staging modeller bør hovedsakelig være views.
    - Men pseduonymisering skal skje så tidlig som mulig, og derfor er det nødvendig at kilder som inneholder personnøkler blir lastet inkrementelt. Det er ofte et krav om at rådata blir slettet etter 6 måneder.
2. Intermediate ved kompleks logikk. Kjør views når du kan. Når views går for tregt, har du tre valg:
    1. Kjøre table materialiseringer. tabeller blir droppet, purget og rekjørt med alt innhold fra spørringen i modellfilen. Ikke lurt ved ved større mengder data, både ytelsesmessig og lagring i flere lag.
    2. Incrememental. Tabellen bevares og nye endrede rader blir lagt til med merge.
    3. Delta last med table models ... trenger POC
3. Marts skal være stabil. Det er her alle spørringer fra konsumenter kjøres, og det er viktig for basen å opparbeide statistikk på spørringer som kjører ofte.
    - materialized_view er for MVP og små datamengder, jher er ikke ytelse noe problem.
    - For løsninger med større datamenger, kjør inkrementell last med partisjonering og indeksering.
4. Skal du skrive om en gammel løsning til dbt? Ikke skriv om løpet og sats på at alt skal blir 100% likt. Du kan veære sikekr på at data (oppslag mot avhengigheter) har endret seg siden forrige gang dataene har blitt kjørt opp. Spesielt med tanke på at patching og rekjøring med forskjellig logikk har blitt gjort gjennom tidene.
    - Bruk tidligere target-tabell som kilde til dbt og kjør en union all. Ny last bør da være inkrementelt over en initlast fra gammel targettabell.
