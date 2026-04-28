# dbt-i-nav

Her finner du dokomentasjon og retningslinjer ofr hvordan vi jobber med dbt i Nav.



# Dokumentasjon med Zensical

Dokumentasjonen er hostet på [navikt.github.io/dbt-i-nav](https://navikt.github.io/dbt-i-nav)

For full dokumentasjon om Zensical, se [zensical.org](https://zensical.org/).

## Installation

### Requirements

* python v3

### macOS / Linux

```shell
make
```

### Windows

```shell
pip install -r requirements-doc.txt
```


## Kommandoer

* `source .venv/bin/activate` - Aktiverer venv på macOS / Linux
* `zensical new .` - Opprett et nytt prosjekt.
* `zensical serve` - Start lokal server med live-reload.
* `zensical build` - Bygg dokumentasjonssiden.
* `zensical -h` - Print hjelpetekst.

## Project layout

    zensical.toml    # Konfigurasjonsfilen.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

Når du oppretter nye sider, må du legge dem til i `nav` i `zensical.toml`. Se [zensical.org/docs/setup/basics/](https://zensical.org/docs/setup/basics/) for mer info.
