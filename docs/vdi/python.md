# Python

Sjekk om Python er installert med `py --version`. Python versionen må være >= 3.8 og < 3.11. 3.11 er ikke støttet av dbt på nåværende tidspunkt

```shell
py --version
```

!!! success
    ```shell
    $ py --version

    Python 3.8.10
    ```

    Fortsett til [PIP](pip.md)
    
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
