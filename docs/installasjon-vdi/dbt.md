# DBT

Vi har nå to versoner av dbt for oracle. Den "offisielle" som kjører dbt v0.19.x og "uoffisielle" for dbt v1.0.x Har du ikke noe forhold til den uoffisielle anbefaler vi at du bruker den offisielle.

## dbt v0.19.x

```shell
pip install dbt-oracle --trusted-host pypi.org --trusted-host  files.pythonhosted.org
```

Kjent feil:

Du får beskjed om at du mangler [Microsoft Visual C++](#microsoft-visual-c)

Verifiser med

```shell
dbt --version
```

Suksess output:

```shell
dbt --version

installed version: 0.19.2
   latest version: 1.0.0

Your version of dbt is out of date! You can find instructions for upgrading here:
https://docs.getdbt.com/docs/installation

Plugins:
  - oracle: 0.19.1
```

Kjent feil:

```shell
ImportError: cannot import name 'soft_unicode' from 'markupsafe' (c:\users\ra_p157554\appdata\local\programs\python\python38\lib\site-packages\markupsafe\__init__.py)
```

Se [dbt feilsituasjoner: ImportError](#importerror)

Oppsett av dbt for Oracle adapter: https://docs.getdbt.com/reference/warehouse-profiles/oracle-profile.

`profiles.yml` skal opprettes under `C:\Users\<NAV-IDENT>\.dbt\profiles.yml` med følgende innhold:

```yaml
dmx_poc:
   target: u1
   outputs:
      u1:
        type: oracle
        host: dm07-scan.adeo.no
        user: Personlig bruker med proxy til DVH_SYFO eks. A123456[DVH_SYFO]
        password: passord
        dbname: dwhu1
        port: 1521
        service: dwhu1
        schema: dvh_syfo
        threads: 4
      rbase:
        type: oracle
        host: dm07-scan.adeo.no
        user: Personlig bruker med proxy til DVH_SYFO eks. A123456[DVH_SYFO]
        password: passord
        dbname: dwh
        port: 1521
        service: dwhr
        schema: dvh_syfo
        threads: 4
      q0:
        type: oracle
        host: dm07-scan.adeo.no
        user: Personlig bruker med proxy til DVH_SYFO eks. A123456[DVH_SYFO]
        password: passord
        dbname: dwhq0
        port: 1521
        service: dwhq0
        schema: dvh_syfo
        threads: 4
        type: oracle
      prod:
        host: dm08-scan.adeo.no
        user: Personlig bruker med proxy til DVH_SYFO eks. A123456[DVH_SYFO]
        password: passord
        dbname: dwh
        port: 1521
        service: dwh_ha
        schema: dvh_syfo
        threads: 4

```

Etter profilen er på plass kan du verifisere at dbt fungerer ved å kjøre `dbt debug` fra prosjektmappen.

Suksess output:

```shell
Configuration:
  profiles.yml file [OK found and valid]
  dbt_project.yml file [OK found and valid]

Required dependencies:
 - git [OK found]

Connection:
  user: P157554[DVH_SYFO]
  database: dwhu1
  schema: dvh_syfo
  host: dm07-scan.adeo.no
  port: 1521
  service: dwhu1
  connection_string: None
  Connection test: [OK connection ok]

All checks passed!
```

Kjent feil:

```shell
Connection test: [ERROR]

2 checks failed:
Error from git --help: Could not find command, ensure it is in the user's PATH and that the user has permissions to run it: "git"

dbt was unable to connect to the specified database.
The database returned the following error:

  >Database Error
  DPI-1047: Cannot locate a 64-bit Oracle Client library: "failed to get message for Windows Error 126". See https://cx-oracle.readthedocs.io/en/latest/user_guide/installation.html for help

Check your database credentials and try again. For more information, visit:
https://docs.getdbt.com/docs/configure-your-profile
```

[Oracle client library](#oracle-client-library) er mest sannsynlig ikke installert.

## dbt v1.0.x (uoffisiell)

Clone (last ned) prosjektet https://github.com/patped/dbt-oracle på maskinen din og kjør følgende kommando fra prosjektmappen:

```shell
pip install . --trusted-host pypi.org --trusted-host  files.pythonhosted.org
```

Verifiser med dbt --version

## dbt feilsituasjoner

### Microsoft Visual C++

Ved feil under installering kan det hende at C++ 14.0 må være installert. Last ned og installer fra https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools&rel=16

### ImportError

Ved kjøring av  `dbt --version` med feilmelding: "ImportError: cannot import name 'soft_unicode' from 'markupsafe'" må markupsafe nedgraderes.
      - `pip uninstall markusafe`
      - `pip install --trusted-host pypi.org --trusted-host  files.pythonhosted.org markupsafe==2.0.1`