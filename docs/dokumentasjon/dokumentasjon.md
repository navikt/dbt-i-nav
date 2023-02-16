# Dokumentasjon

## Tabelldokumentasjon
Tabellene konfigureres og dokumenteres i `yml` filene i hver mappe i prosjektet. Kommentarer kan settes på både tabellnivå og kolonnenivå.
Les mer [her](https://docs.getdbt.com/docs/collaborate/documentation#adding-descriptions-to-your-project).

## Persist docs
dbt-oracle har støtte for å skrive kommentarer til databasen. Som andre konfig,  kan det settes på prosjektnivå, mappenivå eller modellnivå. For å sette det på prosjektnivå, legg til følgende i `dbt_project.yml`
```yml
models:
  +persist_docs:
    relation: true
    columns: true
```

En ting å være oppmerksom på når ``persist_docs`` er aktivert er at kolonnenavn i modellen må være det samme som definert i yml filen.

!!! failure "ORA-00904"

    ```shell
    ORA-00904: "KOLONNE": invalid identifier
    ```

    ```sql
    SELECT
      kolonne
    FROM ...
    ```

    ```yaml
    - name: kolonne_navn
      description: ...
    ```

    Her har Oracle forsøkt å skrive kommentar til en kolonne som ikke eksisterer. Sammenlign modell og yml fil og sjekk at navnet på kolonnen er lik.



## Overskrive overview
Komponentdokumentasjonen kan integreres i dbt dokumentasjonen. I `dbt/models` folderen må det opprettes
en `overview.md` fil. Bruk gjerne [overview.md](https://github.com/navikt/dbt-i-nav/tree/main/docs/dokumentasjon/overview.md) som mal

## Deployere dokumentasjon
Hver gang kommandoen dbt docs kjøres, genereres det tre filer i `target` mappa under dbt prosjektmappa: `index.hml`, `catalog.json` og `manifest.json`. Disse filene er statiske og inneholder alt som trengs for å publisere en versjon av dokumentasjonen på en webserver.

[Github pages](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages) har slik støtte. Publsiering til github pages kan gjøres på flere måter, men kanskje enklest er det å bruke en github action:

```yaml
# Simple workflow for dbt docs content to GitHub Pages
name: Deploy dbt docs to GitHub Pages

on:
  push:
    branches: ["master"]
    paths:
      - docs/**

  workflow_dispatch:


permissions:
  contents: read
  pages: write
  id-token: write

# Allow one concurrent deployment
concurrency:
  group: "pages"
  cancel-in-progress: true

jobs:
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Setup Pages
        uses: actions/configure-pages@v2
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v1
        with:
          path: 'docs'
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v1

```
1. Impoementer overstående github action i .workflow
2. Kjør kommandoen `dbt docs generate`
3. Lag en docs mappe på roten av repoet, hvis det ikke allerede finnes.
4. Kopier over filene `index.hml`, `catalog.json` og `manifest.json` fra target mappen til docs mappen.
5. Commit og push til main branchen.
6. Docen blir automatisk publisert av github action, til url spesifisert av jobben.