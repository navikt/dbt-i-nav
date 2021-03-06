# PIP og oppsett av proxy

## Sjekk om du har PIP

Kjør `pip --version` for å se om pip er tilgjengelig:

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

## Sett opp config fil for pip

Ved å sette opp en pip.ini fil slipper du den lange kommandoen for å installere pakker:
!!! failure
    ```shell
    pip install xxx --trusted-host pypi.org --trusted-host  files.pythonhosted.org
    ```
Disse argumentene kan isteden skrives inn i en pip.ini fil på følgende vis:

1. I mappen `%APPDATA%\`, opprett mappen `pip`.
2. I mappen `pip` opprett filen `pip.ini`. Pip leter etter configfiler automatisk på denne globale plasseringen.
3. Innhold i pip.ini:
```ini
[global]
trusted-host=
    pypi.python.org
    pypi.org
    files.pythonhosted.org
```
4. Nå kan pip oppgraderes med kommandoen:
```shell
python -m pip install -U pip
```
