---
title: Style guide
slug: /style_guide
sidebar_position: 2
---


# DBT Stil Guide
forket fra https://github.com/dbt-labs/corp/blob/main/dbt_style_guide.md

## Modell Naming
Vår modellere organiserers inn i tre hovedgrupper: staging, marts, base/intermediate. See følgnede [diskusjon](https://discourse.getdbt.com/t/how-we-structure-our-dbt-projects/355). The navngiving blir som følger:
```
├── dbt_project.yml
└── models
    ├── marter
    |   └── core
    |       ├── mellomlager
    |       |   ├── mellomlager.yml
    |       |   ├── posteringer__unionisert.sql
    |       |   └── posteringer__gruppert.sql
    |       ├── core.docs
    |       ├── dim_artskonti
    |           ├── dim_artskonti.yml
    |           └── dim_artskonti.sql
    |       ├── dim_konstnadssteder
    |           ├── dim_konstnadssteder.yml
    |           └── dim_konstnadssteder.sql
    |       └── fak_hovedbok_posteringer
    |           ├── fak_hovedbok_posteringer.yml
    |           └── fak_hovedbok_posteringer.sql
    └── stager
        └── oebs
            ├── base
            |   ├── base.yml
            |   └── base__oebs_kontoplan.sql
            ├── src_oebs.yml
            ├── src_oebs.docs
            ├── stg_oebs__posteringerslinjer
            |   ├── stg_oebs__posteringerslinjer.yml
            |   └── stg_oebs__posteringerslinjer.sql
            ├── stg_oebs__budjsett_balanser
            |   ├── stg_oebs__budjsett_balanser.yml
            |   └── stg_oebs__budjsett_balanser.sql
```
- All objekter oppgis på flertalls form, slik som: `stg_oebs__hovedbok_posteringslinjer`, `stg_oebs__artskonti`, etc.
- Base tabeller prefikses med `base__`, slik som: `base__<source>_<object>`
- Mellomlagringstabeller skal avsluttes med et fortidsverb som indikerer hvilken handling som er gjort på objektet, slik som: `hovedbok_posteringslinjer__filtrert_budsjett`
- Datatorg, eller marter, er fordelt mellom fakter (uforandrelig, verb) og dimensjoner (foranderlig, subjekt) og prefikses med `fak_` og `dim_`, henholdvis. 
- Staged strukter inneholder alle kolonner fra rå-tabellen og utvides med avledede kolonner, for å angi naturlig nøkler, hashed nøkler, omdøping av kolonnenavn, etc. 

## Model konfigurasjon

- Model-spesifike attributer (som sort/dist keys) skal spesifiseres i modellen.
- Hvis en spesifikk konfigurasjon som gjelder alle modeller i en folder, burde dette spesifiseres i `dbt_project.yml`.
- Modell konfigurationer skal spesifiseres slik:

```python
{{
  config(
    materialized = 'table',
    sort = 'id',
    dist = 'id'
  )
}}
```
- Marter bør alltid configureres som tabeller - med mindre det er svært gode grunner til å ikke gjøre det. 

## DBT konvensjoner
* Kun `stg_`og `base_` spør mot `source`er.
* Alle andre `ref` andre modeller.

## Tester
- Hver underfolder inneholder en `.yml` fil som tester alle modeller i folderen. Navnestandarden skal være `<folder-navn>.yml`. 
- Som et minimum, skal `unique` og `not_null` være testet på primær nøkkeler

## Navngivining og felt konvensjoner

* Skjema, tabell og kolonne nanv skal være `snake_case`.
* Bruk navn basert på _business_ terminologien, i stedet for kilde terminology.
* Hver model skal ha en primær nøkkel.
* Primær nøkkeler i modellen navngis som `pk_<objekt>`, altså `pk_dim_eperson`. 
* Fremmed nøkkeler angis som `fk_<objekt>`, tidsløse enhets nøkkeler angis som `ek_<objekt>` og naturlige nøkkeler angis som `lk_<objekt>`. 
* For base og stage modeller skal felter være ordnet inne kategorier, fra identifikatorer til tidsstempler tilslutt. 
* Tidsstempel kolonner skal væver navngitt som `<hendelse>_ts`, e.g. `lastet_ts`, og skal være på UTC. for avvikende tidszoner skal tidzonen indikeres ved suffiks, e.g `lastet_ts_pt`.
* Boolean verdier og skal oppgis mot `er_` eller `har_` og uttrykkes med 1 for `Ja` og 0 for `Nei`.
* Beløps kolonner skal ha suffiks `_nok`for, flyttalls, beløp i kroner, og `_orer` for heltall beløp i ører.
* Sær norske bokstaver som Æ, Ø, Å skal angis som `ae`, `a` og `o`.
* Unngår reservert word som kolonne navn. 
* Bruk samme feltnavn gjennom alle modellene hvor mulig, e.g. nøkkelen til `dim_person` skal være `pk_dim_person`og ikke `pk_bruker`.

## CTEer

For mer informasjon om hvorfor vi bruker CTEer, see følgende [post](https://discourse.getdbt.com/t/why-the-fishtown-sql-style-guide-uses-so-many-ctes/1091).

- Alle `{{ ref('...') }}` settning skal plasseres i en egen CTE, ved toppen av fila. 
- Hvor det er mulig, skal en CTE gjøre en og kun en logisk mengde arbeid. 
- CTE navn skal være ordrike og beskrive hva denne faktisk gjør. 
- CTE er med forvirrende eller avansert logik skal kommenteres like etter at den er definert. 
``` sql
with

hendelser_vask as (

    -- Kommentarer
    -- mer kommentarer
    ...
)
```
),
- CTEer som gjenbrukes i feller modeller skal tas ut og bli egne modeller. 
- Modeller bør avsluttest med en  `endelig` CTE som selekterer hele det endelig produktet før modelen avslutted `SELECT * FROM endelig`. 
- CTEene skal formatere som følger:

``` sql
WITH

hendelser AS (

    ...

),

-- CTE comments go here
filtrerte_hendelser AS (

    ...

),

endelig AS (

    SELECT * FROM filtrerte_hendelser

),


SELECT * FROM endelig
```

## SQL stil guide

- Sett komma på slutten setningen
- Bruke fire mellom rom for å indentere koden, uten om ved predikatet, som skal være på linje med `WHERE`
- Ingen linjer skal være lenger enn 80 tegn
- All felt navn skal være skrevet med små bokstaver, og alle funksjonsnavn (`SELECT`, `WHERE`, `LEAD`, etc.) med STORE. 
- Bruk alltid `AS`for å aliase tabeller og felt. 
- Alle felt skal angis før alle aggregater og vindu funskjoner. 
- Aggregering skal skal løses så tidlig som mulig, før en joiner med andre tabeller. 
- `ORDER BY`og `GROUP BY` skal vær angitt med nummer i stedet for kolonne navn (se [følgende](https://blog.getdbt.com/write-better-sql-a-defense-of-group-by-1/) for why). Gruppering bør gjøres på kun noen få kolonne verdier. 
- Bruk helst `UNION ALL` fremfor `UNIO` [*](http://docs.aws.amazon.com/redshift/latest/dg/c_example_unionall_query.html)
- Unngå bruk tabell alias i `JOIN` criterer. Det er ofte vanskelig å forstå hvor tabellen "c" kommer fra.
- Hvis en joiner to eller flere tabeller, _alltid_ prefiks kolonenne med et table alias. Hvis en selekterer fra kun en tabell trengs ingen prefiks. 
- Skriv eksplisite joins, altså skriv `INNER JOIN` instead of `JOIN`). 
- Bruk `LEFT JOIN` fremfor `RIGHT JOIN` 

- *Ikke optimaliserer for få linjer kode. Nye linjer er billig, hjerner er dyre*

### Eksempel SQL
```sql
WITH

min_data AS (

    SELECT * FROM {{ ref('min_data') }}

),

en_cte AS (

    SELECT * FROM {{ ref('en_cte') }}

),

en_cte_agg AS (

    SELECT
        id,
        SUM(felt_4) AS total_felt_4,
        MAX(felt_5) AS max_felt_5

    FROM en_cte
    GROUP BY 1

),

endelig AS (

    SELECT [DISITNCT]
        min_data.felt_1,
        min_data.felt_2,
        min_data.felt_3,

        -- Bruk linjeshift for visuelt separere kalkulasjoner inn i blokker.
        CASE
            WHEN min_data.kansellerings_dato IS NULL
                AND min_data.utgangs_dato is not null
                THEN utgangsdato_date
            WHEN my_data.kansellerings_dato IS NULL
                THEN my_data.start_dato + 7
            ELSE my_data.kansellerings_date
        END AS kansellerings_dato,

        en_cte_agg.total_felt_4,
        en_cte_agg.max_felt_5

    FROM min_data
    LEFT JOIN en_cte_agg  
        ON min_data.id = en_cte_agg.id
    WHERE min_data.felt_1 = 'abc'
        AND (
            min_data.felt_2 = 'def' OR
            min_data.felt_2 = 'ghi'
        )
    HAVING COUNT(*) > 1

)

SELECT * FROM final

```

- Bruk `LEFT JOIN` fremfor `RIGHT JOIN`:
```sql
SELECT
    reiser.*,
    sjaforer.rating AS driver_rating,
    passasjerer.rating AS rider_rating

FROM resier
LEFT JOIN personer AS sjaforer
    ON reiser.fk_personer_sjaforer = sjaforer.pk_personer
LEFT JOIN personer AS passasjerer
    ON reiser.fk_personer_passasjerer = sjaforer.pk_personer

```

## YAML stil guide

* Setning indenteres med to mellomrom 
* Lister skal være indentert 
* Bruk linjeskift for å separere lister når nødvendig. 
* Linjer skal ikke være lenger en 80 karakterer 

### Eksample YAML
```yaml
version: 2

models:
  - name: hendelser
    columns:
      - name: pk_hendelser
        description: Dette er n primærnøkkel
        tests:
          - unique
          - not_null

      - name: hendelse_ts 
        description: "Når hendelse skjedde i UTC (eg. 2018-01-01 12:00:00)"
        tests:
          - not_null

      - name: fk_brukere
        description: Brukeren som stå for hendelsen 
        tests:
          - not_null
          - relationships:
              to: ref('brukere')
              field: pk_brukere
```


## Jinja stil guide

* Ved inklusjon av Jinja kode bruk mellomrom på iden av klammene `{{ slik }}` istedefor `{{slik}}`
* Bruk ny linje for å dele opp logik i Jinja blokker