# Hva er nytt i dbt?

Oversikt over de viktigste endringene i dbt-core fra versjon 1.7 og frem til i dag. Fokus er på funksjoner relevante for dbt-core-brukere med Oracle on-prem.

Fullstendige endringslogger: [dbt Core upgrade guides](https://docs.getdbt.com/docs/dbt-versions/core-upgrade)

---

## v1.8 (2024)

### Unit tests
Den største nyheten i 1.8. Du kan nå skrive enhetstester som validerer SQL-logikken på et lite sett med statiske inputdata – uten å kjøre mot databasen. Dette støtter test-drevet utvikling og gjør det lettere å oppdage feil tidlig.

```yaml
unit_tests:
  - name: test_is_valid_email_address
    model: dim_customers
    given:
      - input: ref('stg_customers')
        rows:
          - {email: "valid@example.com", expected: true}
          - {email: "invalid", expected: false}
    expect:
      rows:
        - {email: "valid@example.com", is_valid_email: true}
        - {email: "invalid", is_valid_email: false}
```

Kjør kun enhetstester:
```
dbt test --select "test_type:unit"
```

### Ny `data_tests:`-syntaks
`tests:` i YAML-filer er omdøpt til `data_tests:` for å skille datatester fra enhetstester. Begge syntakser støttes foreløpig, men migrer til `data_tests:` for fremtidssikkerhet.

### `--empty`-flagg for dry-runs
`dbt run --empty` og `dbt build --empty` kjører modell-SQL mot databasen, men begrenser refs og sources til null rader. Nyttig for å validere avhengigheter og at modeller kompilerer uten kostbare datalesninger.

### Eksplisitt adapterinstallasjon
Fra v1.8 anbefales det å installere adapter og core separat:
```
pip install dbt-core dbt-oracle
```

---

## v1.9 (2024)

### Microbatch incremental_strategy
Ny strategi for svært store datasett. I stedet for én stor inkrementell spørring, bryter dbt opp lastet i diskrete tidsbatcher med egne SQL-spørringer. Konfigureres med `event_time`, `batch_size` og `lookback`.

```yaml
models:
  - name: stg_events
    config:
      materialized: incremental
      incremental_strategy: microbatch
      event_time: created_at
      batch_size: day
      lookback: 3
```

Særlig nyttig der én stor inkrementell spørring går i timeout. Mislykkede batcher kan kjøres på nytt isolert med `dbt retry`.

> **Merk:** Sjekk om `dbt-oracle`-versjonen du bruker støtter microbatch.

### Forbedringer for snapshots
- Snapshots kan nå konfigureres i YAML-filer (i tillegg til SQL-filer)
- Nytt `hard_deletes`-config: velg mellom `ignore`, `invalidate` eller `new_record` for slettede kilderader
- `snapshot_meta_column_names` lar deg tilpasse navn på metakolonner (`dbt_valid_from` etc.)
- `target_schema` er ikke lenger påkrevd – snapshots arver da skjema fra miljøet

### `state:modified`-forbedringer
Mer presis deteksjon av endringer ved bruk av `--state`, reduserer falske positive ved miljøavhengig logikk (f.eks. ulik materialisering i dev vs prod).

---

## v1.10 (2025)

### `--sample`-flagg for raskere utvikling
`dbt run --sample` eller `dbt build --sample` kjører modeller med et tidsbasert utvalg av data. Gir raskere bygg under utvikling uten å prosessere hele datasett.

### `anchors:`-nøkkel for YAML-gjenbruk
Felles konfigurasjonsbokser kan nå samles under en dedikert `anchors:`-nøkkel i YAML-filer, i stedet for å ligge løst på toppnivå.

### Properties flyttes til configs
Disse er nå tilgjengelige under `config:` (i tillegg til som properties):
`freshness`, `meta`, `tags`, `docs`, `group`, `access`

Dette er en del av en pågående opprydning mot et mer konsistent konfigurasjonsspråk.

### Deprecation-advarsler for egendefinerte nøkler
Fra v1.10 gir dbt advarsler hvis du bruker egendefinerte attributter direkte under et ressursobjekt. Disse må nå ligge under `meta`:

```yaml
# Gammel syntaks - gir nå advarsel
models:
  - name: my_model
    my_custom_field: true  # ⚠️ Advarsel!

# Ny syntaks
models:
  - name: my_model
    config:
      meta:
        my_custom_field: true
```

Bruk [dbt-autofix](https://github.com/dbt-labs/dbt-autofix) for å migrere automatisk.

---

## v1.11 (2025)

### User-defined functions (UDFs)
dbt støtter nå definisjon og registrering av egendefinerte databasefunksjoner som egne ressurser i DAG-en. Defineres i en `functions/`-mappe og refereres med `{{ function('navn') }}` i modeller.

> **Merk:** Støtte avhenger av adapteren – sjekk `dbt-oracle`-dokumentasjonen.

### Deprecation-advarsler er nå påslått som standard
Advarslene fra v1.10 for ugyldig YAML-konfigurasjon er nå aktivert som standard for de fleste adaptere. Kjør `dbt parse` og rett opp eventuelle advarsler.

---

## v1.12 (2026, beta)

### `.env`-fil
dbt laster nå automatisk miljøvariabler fra en `.env`-fil i prosjektmappen. Shell-variabler overstyrer `.env`-verdier. Nye prosjekter får `.env` i `.gitignore` automatisk.

### `vars.yml`
Prosjektvariabler kan nå defineres i en egen `vars.yml`-fil ved prosjektroten, i stedet for i `dbt_project.yml`. Holder `dbt_project.yml` ryddig.

### `selector:`-metode for navngitte selektorer
Navngitte selektorer fra `selectors.yml` kan nå brukes direkte i `--select`:
```
dbt run --select "selector:my_selector+,tag:nightly"
```

### Bedre feilmeldinger
Interne Python-feil erstattes med tydelige dbt-feil (`CompilationError`, `ParsingError`). Bruk `--debug` hvis du trenger full stack trace.
