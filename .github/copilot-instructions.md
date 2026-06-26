# Copilot Instructions – dbt-i-nav

## What this repo is

`dbt-i-nav` is a **documentation site** (not a dbt project itself) that describes how NAV uses dbt. It is built with **Zensical** (a fork of MkDocs) and published to [navikt.github.io/dbt-i-nav](https://navikt.github.io/dbt-i-nav).

## Build and serve

```shell
make                        # Create .venv and install dependencies (uses uv if available, else pip)
make serve                  # Start local dev server with live-reload (wraps zensical serve)
make build                  # Build static output to site/ (wraps zensical build --clean)
```

On Windows: `pip install -r requirements-doc.txt`, then `zensical serve`.

The only runtime dependency is `zensical` (listed in `requirements-doc.txt`).

**After renaming or moving files, always run `make build` to catch broken internal links before committing.**

## Architecture

- **`mkdocs.yml`** is the single config file — Zensical reads this (there is no `zensical.yml`).
- **`docs/`** is the content root. All Markdown files live here.
- **`site/`** is build output — never edit it manually.
- Navigation is defined explicitly in the `nav:` block of `mkdocs.yml`. A new page will not appear in the menu until it is registered there.

### Nav sections → directories

| Section in nav | Source directory |
|---|---|
| Introduksjon | `docs/` (root-level files) |
| Kom i gang | `docs/DVH/`, `docs/dbt-i-knast/` |
| Dataprodukt | `docs/dataprodukt/` |
| dbt standarder | `docs/dbt-kodestandard/` |
| God praksis | `docs/god-praksis/` |
| Dokumentasjon | `docs/dokumentasjon/` |
| Prosjekter som bruker dbt | `docs/prosjekter/` |
| Arkiv | `docs/arkiv/` |
| Airflow | `docs/airflow-og-dbt-run/` |

## Key conventions

- **All content is written in Norwegian.**
- New "God praksis" pages belong in `docs/god-praksis/` and must be added under `God praksis` in `mkdocs.yml`.
- Mermaid diagrams are supported via `pymdownx.superfences` — use fenced code blocks with ` ```mermaid `.
- The `toc_depth` is set to 2, so only `##` headings appear in the table of contents.
- The site deploys automatically on push to `main` via the `ci` workflow (`.github/workflows/deploy.yml`).
- Audience: data engineers and analysts at NAV working with Oracle-based data warehouse (DVH) in Knast, many migrating from PowerCenter.
