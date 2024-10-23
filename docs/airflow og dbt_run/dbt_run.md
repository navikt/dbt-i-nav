```python
import requests
import os
import time
import json
import logging
from pathlib import Path
import shlex

from dbt.cli.main import dbtRunner, dbtRunnerResult


DBT_BASE_COMMAND = ["--no-use-colors", "--log-format-file", "json"]


def get_dbt_log(log_path) -> str:
    with open(log_path) as log:
        return log.read()


def set_secrets_as_envs(secret_name: str):
    from google.cloud import secretmanager

    secrets = secretmanager.SecretManagerServiceClient()
    secret = secrets.access_secret_version(name=secret_name)
    secret_str = secret.payload.data.decode("UTF-8")
    secrets = json.loads(secret_str)
    os.environ.update(secrets)


def publish_docs(dbt_project: str):
    # Connection informasjon fo å pushe dbt docs
    dbt_docs_url = f'{os.environ["DBT_DOCS_URL"]}{dbt_project}'
    files = [
        "target/manifest.json",
        "target/catalog.json",
        "target/index.html",
    ]
    multipart_form_data = {}
    for file_path in files:
        file_name = os.path.basename(file_path)
        with open(file_path, "rb") as file:
            file_contents = file.read()
            multipart_form_data[file_name] = (file_name, file_contents)

    res = requests.put(dbt_docs_url, files=multipart_form_data)
    res.raise_for_status()


logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")

if __name__ == "__main__":
    if secret_name := os.getenv("TEAM_GCP_SECRET_PATH"):
        set_secrets_as_envs(secret_name=secret_name)
    else:
        raise ValueError("missing environment variable TEAM_GCP_SECRET_PATH")

    log_path = Path(__file__).parent / "logs/dbt.log"

    os.environ["TZ"] = "Europe/Oslo"
    time.tzset()

    schema = os.environ["DB_SCHEMA"]
    os.environ["DBT_ENV_SECRET_USER"] = f"{os.environ['DB_USER']}[{schema}]"
    os.environ["DBT_DB_SCHEMA"] = schema
    os.environ["DBT_DB_DSN"] = os.environ["DB_DSN"]
    os.environ["DBT_ENV_SECRET_PASS"] = os.environ["DB_PASSWORD"]
    logging.info("DBT miljøvariabler er lastet inn")

    # default dbt kommando er build
    command = shlex.split(os.getenv("DBT_COMMAND", "build"))
    if dbt_models := os.getenv("DBT_MODELS", None):
        command = command + ["--select", dbt_models]

    dbt = dbtRunner()
    dbt_deps = dbt.invoke(DBT_BASE_COMMAND + ["deps"])
    output: dbtRunnerResult = dbt.invoke(DBT_BASE_COMMAND + command)

    # Exit code 2, feil utenfor DBT
    if output.exception:
        raise output.exception
    # Exit code 1, feil i dbt (test eller under kjøring)
    if not output.success:
        raise Exception(output.result)

    if "docs" in command:
        dbt_project = os.environ["DBT_DOCS_PROJECT_NAME"]
        logging.info("publiserer dbt docs")
        publish_docs(dbt_project=dbt_project)

    # Legg til logikk for å skrive logg til xcom

```