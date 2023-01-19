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
