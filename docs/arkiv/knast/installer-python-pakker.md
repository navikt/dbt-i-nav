# Bruk av Poetry

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