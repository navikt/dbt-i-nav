# Feilsøking

Denne siden samler vanlige feilsituasjoner som kan oppstå når du jobber med dbt mot Oracle i DVH.

Dette er en aktiv side, ikke arkiv. Målet er å samle de feilene som fortsatt er relevante i Knast og dagens dbt-oppsett.

## Når bør du bruke denne siden?

Se her hvis:

- `dbt build` eller `dbt run` feiler med Oracle-feil
- du får problemer med inkrementelle modeller
- du får feil relatert til databinding, driver eller Oracle-tilkobling

## Incremental

### ORA-00955: det finnes allerede et objekt med det navnet

Denne feilen oppstår typisk når dbt forsøker å opprette et objekt som allerede finnes, ofte i forbindelse med materialisering eller inkrementell kjøring.

Start med å sjekke:

- hvilken materialisering modellen bruker
- om det ligger igjen gamle objekter i skjemaet
- om modellen nylig er endret fra én materialisering til en annen

## ORA-00904: "KOLONNE": invalid identifier

Dersom `persist_docs` er aktivert i `dbt_project.yml`, ta en titt på siden om [Dokumentasjon](../dokumentasjon/dokumentasjon.md).

Sjekk også:

- om kolonnen faktisk finnes i upstream-modellen
- om det er mismatch mellom dokumentasjon, modell og databaseobjekt
- om du ser på et gammelt objekt som ikke er bygget på nytt

## Kobling mot Oracle-database

### DPY-2029: https_proxy requires use of the tcps protocol

Dette skyldes normalt feil kombinasjon av driver-/tilkoblingsmodus og miljøoppsett.

Et sted å starte er å sjekke hvilken mode du kjører i. Hvis du kjører i thin mode og miljøet krever noe annet, kan det være nødvendig å bytte mode.

Historisk ble dette løst ved å bruke Oracle Instant Client og fjerne `ORA_PYTHON_DRIVER_TYPE=thin` fra miljøvariablene. I dagens Knast-oppsett bør du først verifisere at miljøet og hemmelighetsoppsettet er riktig før du gjør manuelle tilpasninger.

## Praktisk sjekkliste

Når noe feiler, gå gjennom dette i rekkefølge:

1. Kjør `dbt debug`
2. Bekreft at riktig miljø er valgt med `dvh`
3. Sjekk at `profiles.yml` bruker miljøvariablene riktig
4. Kjør modellen eller seleksjonen på nytt med smalere scope
5. Les Oracle-feilen bokstavelig før du begynner å endre oppsettet

## Relatert

- [Komme i gang med dbt i DVH](komme-i-gang.md)
- [Opprett nytt dbt-prosjekt](opprett-prosjekt.md)
- [Håndtering av hemmeligheter i Knast](../dbt%20i%20Knast/handtering-av-hemmeligheter.md)
- [Utvikling av dbt-prosjekter i Knast](../dbt%20i%20Knast/utvikling-av-dbt-prosjekter.md)