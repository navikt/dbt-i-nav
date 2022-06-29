# DBT

Det finnes en offisiell [oracle adapter](https://docs.getdbt.com/reference/warehouse-profiles/oracle-profile) for dbt v1.x. Gjerne start med å ta en titt på denne installasjonsguiden først.

## Installasjon

dbt kan installeres sammen med oracle adapteren med kommandoen:

```shell
pip install dbt-oracle
```

!!! failure Installasjon feiler
    I noen tilfeller har vi opplevd at [Microsoft Visual C++](https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools&rel=16microsoft-visual-c) mangler.

Verifiser med `dbt --version`

```shell
dbt --version
```

!!! success

    ```shell
    $ dbt --version

    installed version: 0.19.2
    latest version: 1.0.0

    Your version of dbt is out of date! You can find instructions for upgrading here:
    https://docs.getdbt.com/docs/installation

    Plugins:
      - oracle: 0.19.1
    ```

    Fortsett med [opprettelse av profil](#opprettelse-av-profil)

!!! bug

    ```py
    *** stack trace ****

    ImportError: cannot import name 'soft_unicode' from 'markupsafe' (c:\users\****\appdata\local\programs\python\python38\lib\site-packages\markupsafe\__init__.py)
    ```

    markupsafe nedgraderes til versjon 2.0.1

    ```shell
    pip uninstall markusafe`
    pip install markupsafe==2.0.1`
    ```

## Opprettelse av profil

Oppsett av dbt for Oracle adapter: https://docs.getdbt.com/reference/warehouse-profiles/oracle-profile.

`profiles.yml` skal opprettes under `C:\Users\<NAV-IDENT>\.dbt\profiles.yml` med følgende innhold (Dette fungerer for v1.0.7 av dbt-core):

```yaml
dmx_poc:
  target: dwhu1
  outputs:
    dwhu1:
      type: oracle
      user: <nav-ident[skjema]> Eks. A123456[DVH_SCHEMA]
      pass: <passord>
      protocol: tcp
      host: dm07-scan.adeo.no
      port: 1521
      service: dwhu1
      database: dwhu1
      schema: <skjema>
      shardingkey:
        - skey
      supershardingkey:
        - sskey
      cclass: CONNECTIVITY_CLASS
      purity: self
      threads: 4
    dwhr:
      type: oracle
      user: <nav-ident[skjema]> Eks. A123456[DVH_SCHEMA]
      pass: <passord>
      protocol: tcp
      host: dm07-scan.adeo.no
      port: 1521
      service: dwh_ha
      database: dwh
      schema: <skjema>
      shardingkey:
        - skey
      supershardingkey:
        - sskey
      cclass: CONNECTIVITY_CLASS
      purity: self
      threads: 4
    dwhq0:
      type: oracle
      user: <nav-ident[skjema]> Eks. A123456[DVH_SCHEMA]
      pass: <passord>
      protocol: tcp
      host: dm07-scan.adeo.no
      port: 1521
      service: dwhq0
      database: dwhq0
      schema: <skjema>
      shardingkey:
        - skey
      supershardingkey:
        - sskey
      cclass: CONNECTIVITY_CLASS
      purity: self
      threads: 4
    prod:
      type: oracle
      user: <nav-ident[skjema]> Eks. A123456[DVH_SCHEMA]
      pass: <passord>
      protocol: tcp
      host: dm08-scan.adeo.no
      port: 1521
      service: DWH_HA
      database: DWH
      schema: <skjema>
      shardingkey:
        - skey
      supershardingkey:
        - sskey
      cclass: CONNECTIVITY_CLASS
      purity: self
      threads: 4
```

Etter profilen er på plass kan du verifisere at dbt fungerer ved å kjøre `dbt debug` fra prosjektmappen.

!!! success

    ```shell
    $ dbt debug

    Configuration:
      profiles.yml file [OK found and valid]
      dbt_project.yml file [OK found and valid]

    Required dependencies:
    - git [OK found]

    Connection:
      user: ****[DVH_SYFO]
      database: dwhu1
      schema: dvh_syfo
      host: dm07-scan.adeo.no
      port: 1521
      service: dwhu1
      connection_string: None
      Connection test: [OK connection ok]

    All checks passed!
    ```

    DBT er nå installert og klart til bruk.

!!! error

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

    [Oracle client library](oracle-client-library.md) er mest sannsynlig ikke installert.
