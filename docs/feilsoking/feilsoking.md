# Feilsøking

Samleside for vanlige feilsistuasjoner som kan oppstå med dbt og Oracle i NAV

## Incremental

### ORA-00955: det finnes allerede et objekt med det navnet

???

### ORA-00904: "KOLONNE": invalid identifier

Dersom `persist_docs` er aktivert i dbt_project.yml, ta en titt på siden om [Dokumentasjon](../dokumentasjon/dokumentasjon.md).

## Kobling mot oracle database

### DPY-2029: https_proxy requires use of the tcps protocol

Bytte fra thin mode til cx mode. I outputen du får i terminalen, sjekk hvilken mode du kjører i. Kjører du i thin mode endr det til cx mode. Dette gjøres ved å bruke Oracle Instant Client. Sett path til Oracle Instant Client i miljøveriabler og slett ORA_PYTHON_DRIVER_TYPE=thin fra miljøvariabler.
