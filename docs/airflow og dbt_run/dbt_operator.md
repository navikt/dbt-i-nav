```python
from typing import Optional

from airflow.models import Variable
from airflow import DAG

from dataverk_airflow import python_operator


# Eksempel dbt-operator
# https://github.com/navikt/dv-a-team-dags/blob/main/operators/dbt_operator.py
def dbt_operator(
    dag: DAG,
    name: str,
    repo: str,
    script_path: str,
    dbt_secret_name: str,
    branch: str = "main",
    retries: int = 2,
    startup_timeout_seconds: int = 60 * 10,
    dbt_command: str = "build",
    dbt_image: str = "ghcr.io/navikt/dvh-images/airflow-dbt:2024-10-21-0b5d929", # oppdateres manuelt når det kommer nytt image
    dbt_models: Optional[str] = None,
    do_xcom_push: bool = False,
    allowlist: list = [],
    publish_docs: bool = False,
    dbt_docs_project_name: str = None,
):
    dvh_db_environment = Variable.get("DVH_DB_ENVIRONMENT")

    env_vars = {
        "DBT_COMMAND": dbt_command,
        "TEAM_GCP_PROJECT": Variable.get("TEAM_GCP_PROJECT"),
        "DBT_DB_TARGET": dvh_db_environment,
        "TEAM_GCP_SECRET_PATH": f"projects/{Variable.get('TEAM_GCP_PROJECT')}/secrets/{dbt_secret_name}/versions/latest",
    }
    if dbt_models:
        env_vars["DBT_MODELS"] = dbt_models

    if publish_docs:
        if not dbt_docs_project_name:
            raise ValueError(
                "Provide a not-null value for dbt_docs_project_name when publish docs=True"
            )
        env_vars["DBT_DOCS_PROJECT_NAME"] = dbt_docs_project_name
        env_vars["DBT_DOCS_URL"] = Variable.get("DBT_DOCS_URL")

    return python_operator(
        dag=dag,
        name=name,
        startup_timeout_seconds=startup_timeout_seconds,
        repo=repo,
        branch=branch,
        script_path=script_path,
        allowlist=allowlist,
        slack_channel=Variable.get("SLACK_OPS_CHANNEL"),
        retries=retries,
        extra_envs=env_vars,
        image=dbt_image,
        do_xcom_push=do_xcom_push,
    )

```