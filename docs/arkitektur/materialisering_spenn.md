# Materialiseringsstrategi i Team Spenn

Formålet med denne strategien er å unngå droppe og deretter opprette datavarehusobjekter hver gang et dbt-løp kjøres da dette er ugunstig mhp. DMO. Derfor har `table`-materialisering blitt faset ut i våre prosjekter. Følgende materialiseringer blir derfor tatt i bruk på tvers av våre dbt-løp:

|                  | Materialisering         | Kommentar                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
|------------------|-------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Staging**      | `ephemeral`             | Staging-modellene blir materialisert som `ephemeral` fordi de kun fungerer som simple transformasjoner som ikke skal eksponeres for sluttbrukeren. Det er heller ikke behov for å lagre dataene fysisk.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| **Intermediate** | `view`                  | Intermediate-modellene blir materialisert som `view` fordi de har kompleks logikk og kjører ikke for tregt.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| **Marts**        | `incremental` og `view` | Faktatabeller og aggregater (både brede og åpne aggregater som skal deles og konsumeres) blir materialisert som hhv. `incremental` og `view`. Faktatabeller, som ofte inneholder store datamengder, blir materialisert som `incremental` for å redusere kjøre- og lagringstiden. Aggregater blir materialisert som `view`, og ikke som `incremental`, da de ikke inneholder mye data og mangler unike nøkler. Hvis aggregatene begynner å ta for lang tid å kjøre som `view`, kan de alternativt materialiseres som `incremental` (gitt at duplikater ikke er et problem for modellen og/eller at `unique_key` eksisterer) eller som `materialized view` (se utfordringer nevnt nedenfor). |  

## Mer om vår incremental-materialisering i Marts

Vi bruker `unique_key`-konfigurasjonen for å finne rader fra en tidligere kjøring med samme unike ID. Dette gjør det mulig å oppdatere eksisterende rader i stedet for å legge dem til som nye:

```sql
{{
  config(
    materialized = 'incremental',
    unique_key = ['kolonne_1', 'kolonne_2'],
    merge_exclude_columns = ['kolonne_1', 'kolonne_2', ...],
    ...
  )
}}

select ...
```
For å legge til nye rader benytter vi `is_incremental()`-makroen:
```sql
select ...
where 
{% if is_incremental() %}
kolonne_dato_kilde > (select max(kolonne_dato_target) from {{ this }})
{% endif %}
```

## Utfordringer med materialized view

Vi forsøkte å materialisere aggregatene våre som `materialized view`, men støtte på flere begrensninger:
- Modeller som bruker denne materialiseringen krever `materialized view log` på parent-/master-modeller.
- Modeller som bruker denne materialiseringen blir automatisk satt til "forced refresh" i Oracle - se tabell 5-3 under [seksjon 5.3.7 "About refresh Options for Materialized Views"](https://docs.oracle.com/en/database/oracle/oracle-database/12.2/dwhsg/basic-materialized-views.html#GUID-11109A1B-1E8A-4F10-9BB3-DEB4D1AAEC36) for refresh-definisjoner.
- Det er flere restriksjoner for "fast refresh" på `materialized view`:
  - 5.3.7.4 "General Restrictions on Fast Refresh"
  - 5.3.7.5 "Restrictions on Fast Refresh on Materialized Views with Joins Only"
  - 5.3.7.6 "Restrictions on Fast Refresh on Materialized Views with Aggregates"