# Håndtering av DVH hemmeligheter i Knast
Denne siden forklarer hvordan dbt får tilgang til Oracle-credentials i Knast.

Det finnes pre-installert løsning for kortvarig lagring av DVH hemmeligheter i `dbt-stable` imaget. Løsning heter `Knast Secret Manager (KSM)`.

## Hva gjør KSM?
Knast Secret Manager, forkortet KSM, injiserer Oracle-credentials automatisk når dbt prosjekt kjører. Brukeren trenger derfor normalt ikke å lime inn eller lagre passord manuelt i prosjektet.

KSM brukes for å:
- sette opp dbt og pyhton miljø 
- sette opp riktig miljø for valgt DVH-instans
- hente og eksponere nødvendige miljøvariabler
- sørge for at `dbt-oracle` og `oracledb` får credentials på riktig tidspunkt


## Hvordan bruke KSM eller lagre DVH passord
For å lagre DVH passord i Knast, kjør følgende kommando i terminal
```bash
dvh
```

Følg prosessen videre i terminal.

!!! note
    Det finnes 2 pre-definerte dbt-miljøer `.dbtenv` eller `.dbtenv-ny`. 
    `.dbtenv-ny` pleier å ha nyeste versjon av `dbt-oracle`, valgt av dbt brukere i Nav.
    Vi jobber med at kun et dbt miljø er tilgjengelig via KSM. 

## Hvordan bruke DVH passord i dbt

1. Før du kjører `dbt` koden, sørg for at `profiles.yml` i dbt-prosjektet bruker miljøvariablene som KSM setter for å fungere. Innholdet må være følgende:

```yaml
"fyll inn profiles-navn fra dbt_project.yml":
  target: "{{env_var('DBT_DB_TARGET')}}"
  outputs:
    knast:
        host: "{{ env_var('DBT_DB_HOST') }}"
        password: placeholder
        port: "{{ env_var('DBT_DB_PORT') }}"
        protocol: tcp
        schema: <schema_name>
        service: "{{ env_var('DBT_ENV_SERVICE') }}"
        database: "{{ env_var('DBT_DB_NAME') }}"
        threads: 1
        type: oracle
        user: "{{ env_var('DBT_ENV_SECRET_USER') }}"
```

- host, port, service og user hentes fra miljøvariabler
- `schema` må spesifiseres for prosjektet ditt
- `password` står som placeholder fordi credential-injeksjonen skjer utenfor selve filen
- `knast` er targeten som velges automatisk når du kjører i Knast.


2. Test at `dbt` kunne bruke riktig DVH passord. Kjør følgende i Terminal: (Husk å aktivere kobling mot DVH basen.)
```bash
dbt debug
dbt run
```
Hvis `dbt debug` går grønt, er hemmelighetsoppsettet i praksis på plass. 


## Bruke hemmeligheter i Python og Notebooks
For å bruke samme datavarehus hemmeligheter man har lagret med `dvh`, bruk følgende kobling strengen:

```python
import os
import oracledb

conn = oracledb.connect(
    user=os.environ["DBT_ENV_SECRET_USER"],
    dsn=f"{os.environ['DBT_DB_HOST']}:{os.environ['DBT_DB_PORT']}/{os.environ['DBT_ENV_SERVICE']}"
)

conn.close()
```

### Ved bruk av `dvh-tools`, legg følgende sjekk i `_create_connection()`:
Hvis du kjører samme kode i annet verktøy (f.eks. Airflow), så kan du legge til condition i koden så at den finner hemmelighet på riktig måte.

```python
in_knast = os.environ["DBT_DB_TARGET"]  # To execute on Knast machines
    if in_knast == "knast":
        oracle_client = oracledb.connect(
            user=os.environ["DBT_ENV_SECRET_USER"],
            dsn=f"{os.environ['DBT_DB_HOST']}:{os.environ['DBT_DB_PORT']}/{os.environ['DBT_ENV_SERVICE']}")
    elif secret:
         . . . . .
```


## Eget Python-miljø

Hvis du bruker et eget virtuelt miljø, må KSM installeres i dette miljøet én gang:

```bash
cd stien-til-ditt-prosjekt
dvh ksm install
```
Kjør deretter:
```bash
dvh
```

og følg prosessen i Terminal. Husk å velge ditt eget venv denne gangen. 


## Bytte miljø

Hvis du vil bytte DVH-miljø, kjør bare:

```bash
dvh
```

Velg nytt miljø i menyen. Neste dbt-kjøring bruker det oppdaterte oppsettet.