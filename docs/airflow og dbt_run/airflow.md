
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