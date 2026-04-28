# Bruk av Poetry

!!! warning "Arkiv"
    Denne siden er arkivert og er ikke del av anbefalt oppsett lenger. Innholdet beholdes kun for historikk og overgangsbehov. For nytt arbeid, bruk de aktive sidene for Knast og DVH.

- Installer Poetry pakke.

- For å bruke Poetry med pypi-proxy må du oppdatere pyproject.toml filen din med følgende innhold:
```toml
[[tool.poetry.source]]
name = "private"
url = "https://europe-north1-python.pkg.dev/knada-gcp/pypiproxy/simple/"
priority = "supplemental"
```

- Kjør deretter: 
```sh
$ poetry add <pakke-navn>
```

!!!question "Spørsmål?"
    Skriv gjerne på [Slack](https://nav-it.slack.com/archives/C0859E82VA6)