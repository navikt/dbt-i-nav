# Python



Sjekk om Python er installert med `py --version`. dbt-versjon 1.4 og senere støtter Python-versjon 3.11, for en tidligere dbt-versjon må Python-versjon være >= 3.8 og < 3.11.

Last eventuelt ned python [3.11.x](https://www.python.org/downloads/) og installer ved å følge installsjonsveiviseren.

```shell
py --version
```

!!! success
    ```shell
    $ py --version

    Python 3.8.10
    ```

    Fortsett til [PIP](pip-og-oppsett.md)
    
!!! failure
    ```shell
    $ py --version

    Python 3.6.4
    ```
    For gammel version av Python

    Last ned [Python](https://www.python.org/downloads/windows/)

!!! failure
    ```shell
    $ py --version

    python is not recognized as an internal or external command, operable program, or batch file
    ```

    Python er ikke installert

    Last ned [Python](https://www.python.org/downloads/windows/)
