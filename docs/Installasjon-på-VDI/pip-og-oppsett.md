# PIP og oppsett av python med dbt
Vi har laget et ferdig [oppsett](https://github.com/navikt/dvh_template/tree/dbt_template) av et dbt prosjekt tilpasset NAV dvh. Enten lag et nytt repo basert på [dvh_template](https://github.com/navikt/dvh_template) eller [amd_template](https://github.com/navikt/dvh_template/tree/amd_template) avhengig av preferanse for komponentoppsett på github. Deretter må [dbt_template](https://github.com/navikt/dvh_template/tree/dbt_template) merges inn for å få integrert dbt prosjektet.

Følgende script (også på [github](https://github.com/navikt/dvh_template/blob/dbt_template/dbt/setup_python_env.ps1)) installerer et virtuelt python miljø kun for dette prosjektet. 
```shell
pip --version
```


## Feilsøk: Sjekk om du har PIP

Har du installert python, så har du nesten sikkert også pip.
Men dersom overstående feiler, kjør `pip --version` for å se om pip er tilgjengelig:

```shell
pip --version
```

!!! success

    ```shell
    pip --version

    pip 21.1.1 from c:\users\*****\appdata\local\programs\python\python38\lib\site-packages\pip (python 3.8)
    ```

    Fortsett til "Sett opp config fil for pip"

!!! failure
    ```shell
    pip --version

    'pip' is not recognized as an internal or external command, operable program or batch file.
    ```

    Kjør `py -3 -m ensurepip` for å se om pip allerede eksisterer.

    ```shell
    Looking in links: c:\Users\****\AppData\Local\Temp\tmp4r6s0n91
    Requirement already satisfied: setuptools in c:\users\****\appdata\local\programs\python\python38\lib\site-packages (58.1.0)
    Requirement already satisfied: pip in c:\users\****\appdata\local\programs\python\python38\lib\site-packages (21.2.4)
    ```

    I dette tilfelle må miljøvariabelen `PATH` oppdateres. Bruk gjerne `Fil utforsker` for å finne riktig path men normalt ligger PIP under:

    ```shell
    c:\users\<brukernavn>\appdata\local\programs\python\python38\scripts
    ```

    !!! info
        Se [legg til miljøvariabler](miljovariabler.md) hvis du ikke vet hvordan du oppdatere `PATH`.

    Husk at du må lukke og åpne cmd (ledetekst) etter path variabel er lagt inn. Du kan nå verifisere at pip er tilgjengelig ved å kjøre `pip --version`.

## Oppsett av sertifikater til pip

!!! note
    Dette steget skjer automatisk under kjøring av [setup_python_env.ps1](https://github.com/navikt/dvh_template/blob/dbt_template/dbt/setup_python_env.ps1) og er ikke lenger nødvendig.

Til vanlig bruker pip sitt eget sertifikat for å validere at vi laster ned
pakker fra riktig server. Siden VDI bruker en webproxy for å
kommunisere med omverdenen vill vi få en feilmeling ved `pip install xxx`.

!!! error
    ```shell
    13:42:24  Encountered an error: External connection exception occurred:
    HTTPSConnectionPool(host='hub.getdbt.com', port=443): Max retries exceeded
    with url: /api/v1/index.json (Caused by SSLError(SSLCertVerificationError(1,
    '[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get
    local issuer certificate (_ssl.c:1108)')))
    ```

For å fikse feilen kan vi installere pakkene `setuptools-scm` og `pip-system-certs` som får
pip til å bruke Windows Certificate Store istedenfor.

```shell
pip install setuptools-scm pip-system-certs --trusted-host pypi.org --trusted-host  files.pythonhosted.org
```
