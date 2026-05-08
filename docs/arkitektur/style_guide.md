# Navnestandard og stilguide

Basert på [dbt Labs sin stilguide](https://github.com/dbt-labs/corp/blob/main/dbt_style_guide.md).

## Modellnavn

Modeller organiseres i tre hovedgrupper: `staging`, `intermediate` og `marts`. Se [denne diskusjonen](https://discourse.getdbt.com/t/how-we-structure-our-dbt-projects/355). Navngivingen blir som følger:
```
├── dbt_project.yml
└── models
    ├── marts
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
    └── staging
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
- Alle objekter oppgis på flertallsform, slik som: `stg_oebs__hovedbok_posteringslinjer`, `stg_oebs__artskonti`, etc.
- Basetabeller prefikses med `base__`, slik som: `base__<source>_<object>`
- Mellomlagringstabeller skal avsluttes med et fortidsverb som indikerer hvilken handling som er gjort på objektet, slik som: `hovedbok_posteringslinjer__filtrert_budsjett`
- Datatorg, eller marter, er fordelt mellom faktaer (uforandelig, verb) og dimensjoner (foranderlig, subjekt) og prefikses med `fak_` og `dim_`, henholdvis. 
- Staged strukter inneholder alle kolonner fra rå-tabellen og utvides med avledede kolonner, for å angi naturlig nøkler, hashed nøkler, omdøping av kolonnenavn, etc. 

## Modellkonfigurasjon

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

## dbt-konvensjoner
* Kun `stg_`og `base_` spør mot `source`er.
* Alle andre `ref` andre modeller.

## Tester
- Hver underfolder inneholder en `.yml` fil som tester alle modeller i folderen. Navnestandarden skal være `<folder-navn>.yml`. 
- Som et minimum, skal `unique` og `not_null` være testet på primær nøkkeler

## Navngiving og feltkonvensjoner

* Skjema, tabell og kolonnenavn skal være `snake_case`.
* Bruk navn basert på _business_-terminologi, ikke kildeterminologi.
* Hver modell skal ha en primærnøkkel.
* Primærnøkler navngis som `pk_<objekt>`, f.eks. `pk_dim_person`.
* Fremmednøkler angis som `fk_<objekt>`, tidsløse enhetsnøkler som `ek_<objekt>` og naturlige nøkler som `lk_<objekt>`.
* For base og stage-modeller skal felter ordnes fra identifikatorer til tidsstempler sist.
* Tidsstempelkolonner navngis `<hendelse>_ts`, f.eks. `lastet_ts`, og skal være UTC. For avvikende tidssoner angis dette med suffiks, f.eks. `lastet_ts_pt`.
* Booleanske verdier prefikses med `er_` eller `har_` og uttrykkes med 1 for ja og 0 for nei.
* Beløpskolonner har suffiks `_nok` for desimalbeløp i kroner og `_orer` for heltallsbeløp i ører.
* Norske bokstaver Æ, Ø, Å skrives som `ae`, `o` og `a` i kolonnenavn.
* Unngå reserverte ord som kolonnenavn.
* Bruk samme feltnavn på tvers av alle modeller der mulig, f.eks. skal nøkkelen til `dim_person` hete `pk_dim_person`, ikke `pk_bruker`.

## CTEer

For mer om hvorfor vi bruker CTEer, se denne [posten](https://discourse.getdbt.com/t/why-the-fishtown-sql-style-guide-uses-so-many-ctes/1091). Kortversjonen er at det hjelper oss å samle kildene øverst, gjøre enkle transformasjoner og joins i midten, og se resultatet nederst. Oracle støtter passthrough slik at mange WITH-ledd på rad ikke påvirker ytelsen.

- Alle `{{ ref('...') }}` settning skal plasseres i en egen CTE, ved toppen av fila. 
- Hvor det er mulig, skal en CTE gjøre en og kun en logisk mengde arbeid. 
- CTE navn skal være ordrike og beskrive hva denne faktisk gjør. 
- CTE-er med forvirrende eller avansert logikk skal kommenteres rett etter at den er definert.

```sql
with

hendelser_vask as (

    -- Kommentarer
    -- mer kommentarer
    ...

)
```

- CTEer som gjenbrukes i flere modeller skal tas ut og bli egne modeller.
- Modeller bør avsluttes med en `endelig` CTE som selekterer hele det endelige produktet: `SELECT * FROM endelig`.
- CTEene skal formateres som følger:

```sql
WITH

hendelser AS (

    ...

),

-- CTE-kommentarer her
filtrerte_hendelser AS (

    ...

),

endelig AS (

    SELECT * FROM filtrerte_hendelser

)

SELECT * FROM endelig
```

## SQL-stilguide

- Sett komma på slutten av setningen.
- Bruk fire mellomrom for innrykk, unntatt ved predikat som skal ligge på linje med `WHERE`.
- Ingen linjer skal være lenger enn 80 tegn.
- Alle feltnavn skrives med små bokstaver, og alle funksjonsnavn (`SELECT`, `WHERE`, `LEAD` osv.) med STORE bokstaver.
- Bruk alltid `AS` for å aliase tabeller og felt.
- Alle felt skal angis før aggregater og vindusfunksjoner.
- Aggregering bør gjøres så tidlig som mulig, før join med andre tabeller.
- `ORDER BY` og `GROUP BY` kan angis med nummer i stedet for kolonnenavn (se [denne posten](https://blog.getdbt.com/write-better-sql-a-defense-of-group-by-1/)). Gruppering bør gjøres på kun noen få kolonneverdier.
- Bruk `UNION ALL` fremfor `UNION`.
- Unngå tabellalias i `JOIN`-kriterier – det er ofte vanskelig å forstå hvor tabellen `c` kommer fra.
- Hvis du joiner to eller flere tabeller, prefiks alltid kolonner med tabellalias. Selekterer du fra kun én tabell, er prefiks ikke nødvendig.
- Skriv eksplisitte joins, altså `INNER JOIN` i stedet for bare `JOIN`.
- Bruk `LEFT JOIN` fremfor `RIGHT JOIN`.

_Ikke optimaliser for få kodelinjer. Nye linjer er billige, hjerner er dyre._

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

## YAML-stilguide

* Innrykk med to mellomrom.
* Lister skal innrykkes.
* Bruk linjeskift for å separere lister når nødvendig.
* Linjer skal ikke være lenger enn 80 tegn.

### Eksempel YAML
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


## Jinja-stilguide

* Bruk mellomrom på innsiden av klammene: `{{ slik }}` i stedet for `{{slik}}`.
* Bruk ny linje for å dele opp logikk i Jinja-blokker.


## Visuell skille på modeller med tags og farger i lineage

I lineagen får source-blobber en lys grønn farge, mens alt annet blir lys blå.
I `.yml`-filene kan dette endres med `node_color`-attributten under `+docs` til en modell eller en mappe.
For å skille enklere mellom staging, intermediate og marts har vi valgt følgende som en standard, men dette kan du endre som du vil. For å navigere enklere i lineagen bruker team Spenn en kombinasjon av farger og tags, som vist nedenfor:


```yaml
# i dbt_project.yml
models:
  ...
    staging:
      +docs:
        node_color: '#33aa5f'

    intermediate:
      +docs:
        node_color: '#d57448'
      daglig:
        +tags: 'daglig'
      maanedlig:
        +tags: 'maanedlig'

    marts:
      daglig:
        +tags: 'daglig'
        +docs:
          node_color: '#56b4e9'

      maanedlig:
        +tags: 'maanedlig'
        aggregater_aapen:
          +docs:
            node_color: '#368da8'
        aggregater_bred:
          +docs:
            node_color: '#3386e0'
        detaljer:
          +docs:
            node_color: '#8a2be2'

snapshots:
  ...
      +tags: ['daglig', 'snapshot']
    +docs:
      node_color: '#e6b400' 
```

Tags brukes også til å kjøre kun daglige/månedlige modeller, men er også kjekt å filtrere på i lineage.
