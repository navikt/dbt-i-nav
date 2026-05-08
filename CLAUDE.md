# CLAUDE.md

Kontekst for AI-assistenter som jobber i dette repoet.

## Hva er dette repoet?

`dbt-i-nav` er dokumentasjon for hvordan NAV jobber med dbt. Innholdet er rettet mot:

1. Introduksjon til dbt for nye brukere
2. Overgang fra PowerCenter til dbt
3. Komme i gang med dbt-prosjekt fra template i Knast
4. God praksis for dbt-prosjekter (navnestandard, testing, formattering, lagdeling)

## Tech stack

- **Zensical** – dokumentasjonsverktøy (fork av MkDocs, leser `mkdocs.yml`)
- **Material for MkDocs** – tema
- **Config:** `mkdocs.yml` (Zensical leser denne – det finnes ingen `zensical.yml`)
- **Python 3**, avhengigheter i `requirements-doc.txt`

## Kjøre lokalt

```shell
make                    # Opprett venv og installer avhengigheter
source .venv/bin/activate
zensical serve          # Start lokal server med live-reload
zensical build          # Bygg statiske filer til site/
```

## Navigasjonsstruktur

Definert i `nav`-blokken i `mkdocs.yml`. Seksjoner:

| Seksjon | Innhold |
|---|---|
| Introduksjon | Hva er dbt, fra PowerCenter, hvorfor dbt, hva er nytt |
| Kom i gang | Oppsett i Knast, opprett prosjekt fra template, feilsøking |
| God praksis | Materialisering, navnestandard/stilguide, eksempler |
| Dokumentasjon | Tabelldokumentasjon, dbt docs, overview |
| Prosjekter som bruker dbt | Eksisterende NAV-prosjekter |
| Arkiv | Eldre Knast- og VDI-sider |
| Airflow | Airflow-integrasjon med dbt |

## Konvensjoner

- Innhold skrives på **norsk**
- Mermaid-diagrammer støttes via pymdownx.superfences
- Nye sider må legges til i `nav` i `mkdocs.yml` for å vises i menyen
- `docs/` er kildemappen, `site/` er byggoutput (ikke rediger manuelt)
- Legg nye god-praksis-sider i `docs/arkitektur/` og registrer dem under `God praksis` i nav

## Kontekst om målgruppen

Primært dataingeniører og analytikere i NAV som jobber med Oracle-basert datavarehus (DVH) i Knast. Mange kommer fra PowerCenter. Utviklingsmiljøet er Knast (ikke lokal maskin eller VDI).
