# DBT

Det finnes en offisiell [oracle adapter](https://docs.getdbt.com/reference/warehouse-profiles/oracle-profile) for dbt v1.x. Gjerne start med å ta en titt på denne installasjonsguiden først.

## Installasjon

dbt kan installeres sammen med oracle adapteren med kommandoen:

```shell
pip install dbt-oracle
```

!!! failure "Nedlasting feiler"

    ```shell
    $ pip install dbt-oracle
    WARNING: Retrying (Retry(total=4, connect=None, read=None, redirect=None, status=None)) after connection broken by 'SSLError(SSLCertVerificationError(1, '[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1131)'))': /simple/dbt-oracle/

    ...

    Could not fetch URL https://pypi.org/simple/dbt-oracle/: There was a problem confirming the ssl certificate: HTTPSConnectionPool(host='pypi.org', port=443): Max retries exceeded with url: /simple/dbt-oracle/ (Caused by SSLError(SSLCertVerificationError(1, '[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1131)')))
    ```

    Sjekk om du har gjort [oppsett av sertifikater til pip](pip.md#oppsett-av-sertifikater-til-pip).

!!! failure "Installasjon feiler"
    I noen tilfeller har vi opplevd at [Microsoft Visual C++]( https://visualstudio.microsoft.com/visual-cpp-build-tools/) mangler.
    Feilmeldingen kan se slik ut:
    
    ```shell
    ...
    Building wheels for collected packages: cx-Oracle
    Building wheel for cx-Oracle (pyproject.toml) ... error
    error: subprocess-exited-with-error
    
    × Building wheel for cx-Oracle (pyproject.toml) did not run successfully.
    │ exit code: 1
    ╰─> [8 lines of output]
          C:\Users\RA_S167159\AppData\Local\Temp\pip-build-env-lh09agh5\overlay\Lib\site-packages\setuptools\config\expand.py:144: UserWarning: File 'C:\\Users\\RA_S167159\\AppData\\Local\\Temp\\pip-install-ki6mcccg\\cx-oracle_5a1e160a6cb5498187fe05d5b5637d8c\\README.md' cannot be found
            warnings.warn(f"File {path!r} cannot be found")
        pip_system_certs: ERROR: could not register module: No module named 'wrapt'
        running bdist_wheel
        running build
        running build_ext
        building 'cx_Oracle' extension
        error: Microsoft Visual C++ 14.0 or greater is required. Get it with "Microsoft C++ Build Tools": https://visualstudio.microsoft.com/visual-cpp-build-tools/
        [end of output]

    note: This error originates from a subprocess, and is likely not a problem with pip.
    ERROR: Failed building wheel for cx-Oracle
    Failed to build cx-Oracle
    ERROR: Could not build wheels for cx-Oracle, which is required to install pyproject.toml-based projects
    ...
    ```
    Last ned og installer Build Tools. Følg gjerne guiden her: [Fixed: Microsoft Visual C++ 14.0 Is Required Error](  https://www.partitionwizard.com/partitionmanager/microsoft-visual-c-14-is-required.html )    
    Husk å restarte VDI etter installasjon.

## Opprette nytt dbt prosjekt for Oracle

Oppsettet av nytt prosjekt er forenklet og tilpasset datavarehus. Det er laget eksempelprosjekt i repo [dvh_template](https://github.com/navikt/dvh_template) for bruk av dbt til komponentskjemaer. dbt prosjektet ligger i en egen branch [dbt_template](https://github.com/navikt/dvh_template/tree/dbt_template).


- For nye komponenter er det bare å opprette nytt github repo med utgangspunkt i [dbt_template](https://github.com/navikt/dvh_template/tree/dbt_template).
- For eksisterende komponentrepoer, ta en kopi av [dbt](https://github.com/navikt/dvh_template/tree/dbt_template/dbt)  og lim inn i roten til komponentrepoet.

Se [dokumentasjon](https://github.com/navikt/dvh_template/blob/dbt_template/README.md) for å ta i bruk prosjektet for detaljer.

Hvis du ikke ønsker å ta i bruk standardprosjektet, men heller kjøre `dbt init` er det noen ting som kan skape uforståelige feilmeldinger:

### Quoting
Quoting av databasenavn må aktiveres i `dbt_project.yml` siden databasenenavnene til dvh-databasene er med små bokstaver (eks. dwhu1). Hvis ikke dette gjøres kommer det feilmeling som sier noe slikt som `approximate match`

For å skru på quoting må
følgende settes i `dbt_project.yml`:

```shell
quoting:
  database: true
```

### Hemmeligheter ved kjøring fra utviklerimage
Av sikkerhetshensyn anbefaler vi og oracle å bruke miljøvariabler for å holde på 
hemmeligheter. Vi har derfor laget et script og profiles.yml som kan ligge i
dbt-prosjektet.

Scriptet kan lastes ned fra [navikt/dvh_template/dbt/setup_db_user.ps1](https://github.com/navikt/dbt-template/blob/main/dbt/setup_dbt_env.ps1).

`profiles.yml` skal opprettes i på toppnivå i dbt-prosjektmappen, eksempel [navikt/dvh_template/dbt/profiles.yml](https://github.com/navikt/dvh_template/blob/dbt_template/dbt/profiles.yml)
Merk at navn på profil er profilnavnet det henvises til i  `dbt_project.yml`

```yaml
<navn på profil>:
  target: "{{env_var('DBT_DB_TARGET')}}"
 ...

```

Når profilen er på plass i prosjektmappen kan du [teste at dbt fungerer](#teste-dbt-installasjonen).

## Teste dbt installasjonen

Etter at dbt er på plass kan du verifisere at dbt fungerer ved å kjøre `.\setup_db_user.ps1`
etterfulgt av `dbt debug` fra prosjektmappen. Er det et nytt prosjekt må du
[opprette profiles.yml](#opprettelse-av-profilesyml-i-et-nytt-dbt-prosjekt) først.

`.\setup_db_user.ps1` må kjøres hver gang en starter en ny terminal eller
ønsker å bytte target (db). Scriptet vill midlertidlig opprette miljøvariablene
i terminal-sesjonen for target, brukernavn, passord, schema og peke dbt mot
profiles.yml i prosjektmappen.

!!! success

    ```shell
    $ .\setup_db_user.ps1
    Target db: U <eventuelt Q,R eller P>
    Schema: 

    cmdlet Get-Credential at command pipeline position 1
    Supply values for the following parameters:
    Credential

    $ dbt debug
    09:15:08  Running with dbt=1.1.1
    dbt version: 1.1.1
    python version: 3.8.10
    python path: c:\users\****\appdata\local\programs\python\python38\python.exe      
    os info: Windows-10-10.0.19044-SP0
    Using profiles.yml file at C:\Users\****\git\dvh-sykefravar-dmx\profiles.yml
    Using dbt_project.yml file at C:\Users\****\git\dvh-sykefravar-dmx\dbt_project.yml

    09:15:08  oracle adapter: Running in cx mode
    Configuration:
      profiles.yml file [OK found and valid]   
      dbt_project.yml file [OK found and valid]

    Required dependencies:
    - git [OK found]

    Connection:
      user: ****
      database: dwhu1
      schema: ****
      protocol: tcp
      host: dm07-scan.adeo.no
      port: 1521
      tns_name: None
      service: dwhu1
      connection_string: None
      shardingkey: []
      supershardingkey: []
      cclass: None
      purity: None
      Connection test: [OK connection ok]

    All checks passed!
    ```

    DBT er nå klart til bruk.

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
