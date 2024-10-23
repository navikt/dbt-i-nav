
### DBT operator template

[Her (dbt operator eksemepl)](dbt_operator.md) er et eksempel på en dbt-operator som kan brukes i airflow.
Operatoren er avhengig av 2 airflow-variabler:
- TEAM_GCP_PROJECT
- DVH_DB_ENVIRONMENT

### DBT run

[Her (dbt run eksempel)](dbt_run.md) er et eksempel på et main-script for å kjøre dbt som du kan peke på fra airflow. Denne filen plaseres sammen med dbt-kode og er generisk laget, slik at samme fil kan benyttes i alle dbt-prosjekter.

```python
from dbt.cli.main import dbtRunner
```
Om du bytter ut `subprocess` med `dbtRunner` så vil du få logget dbt-kjøringen din live i airflow.


### JSON-struktur for hemmeligheter i GSM - Google Secret Manager

```json
{
    "DB_USER": "<DB_USER>", 
    "DB_SCHEMA": "<DB_SCHEMA>", 
    "DB_PASSWORD": "<DB_PASSWORD>", 
    "DB_DSN": "<DB_DSN>"
}
```

Det viktige her er at DB_USER, DB_SCHEMA, DB_PASSWORD, DB_DSN er de samme som du bruker i [dbt_run](dbt_run.md).
