---
sidebar_position: 3
---

# PIP

Kjør `pip --version` for å se om pip er tilgjengelig:

```shell
$ pip --version

pip 21.1.1 from c:\users\*****\appdata\local\programs\python\python38\lib\site-packages\pip (python 3.8)
```

:::tip Suksess!

Fortsett til [GIT](./git)

:::

Ved feil se [Pip not found](#pip-not-found)

## Python feilsituasjoner

### Pip not found

Får du "not found" kan det hende du må legge pip til i miljøvariabelen `PATH`. Kjør `py -3 -m ensurepip` for å se om pip allerede eksisterer.
Eksempel på output som viser at pip finnes:

```shell
Looking in links: c:\Users\P157554\AppData\Local\Temp\tmp4r6s0n91
Requirement already satisfied: setuptools in c:\users\p157554\appdata\local\programs\python\python38\lib\site-packages (58.1.0)
Requirement already satisfied: pip in c:\users\p157554\appdata\local\programs\python\python38\lib\site-packages (21.2.4)
```

I dette tilfelle må miljøvariabelen `PATH` oppdateres. Bruk gjerne `Fil utforsker` for å finne riktig path til pip men mest sannsynlig er: `c:\users\<brukernavn>\appdata\local\programs\python\python38\scripts` riktig path.

Husk at du må lukke og åpne cmd (ledetekst) etter path variabel er lagt inn. Du kan nå verifisere at pip er tilgjengelig ved å kjøre `pip --version`.

Eksempel på output:

```shell
PS C:\Users\*****\git\dvh-sykefravar-dmx> pip --version
pip 21.1.1 from c:\users\*****\appdata\local\programs\python\python38\lib\site-packages\pip (python 3.8)
```
