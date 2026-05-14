# Testing

Testing skal bekrefte at modellen faktisk oppfører seg slik kontrakten sier. For grain betyr det at vi tester at én rad virkelig representerer det modellen sier at den representerer.

Det holder ikke å skrive grain i dokumentasjonen. Grain må også bevises i test.

## Hva det betyr å teste grain

Når vi tester grain, tester vi i praksis tre ting:

- at nøkkelkolonnene som identifiserer grain ikke er `null`
- at kombinasjonen av disse kolonnene er unik på riktig nivå
- at eventuelle historikkregler eller forretningsregler ikke bryter grain

Hvis grain er feil, får vi ofte disse symptomene:

- joins som multipliserer rader
- aggregater som blir for høye
- OBT-er med duplikater
- historikk som overlapper eller lager hull

## Hovedregel

Grain for alle eksponerte modeller skal være testet.

Det betyr:

- `dim_`-modeller skal ha tester som bekrefter sitt grain
- `fak_`-modeller skal ha tester som bekrefter sitt grain
- `obt_`-modeller skal ha tester som bekrefter sitt grain

Se også [grain.md](grain.md) og [modellkontrakter.md](modellkontrakter.md).

## Start alltid med nøkkelkolonnene

Den enkleste og viktigste starten er å teste nøkkelkolonnene som identifiserer grain.

Hvis grain er:

- én rad per vedtak

må `vedtak_id` være:

- `not_null`
- `unique`

Eksempel:

```yaml
models:
  - name: fak_vedtak
    columns:
      - name: vedtak_id
        tests:
          - not_null
          - unique
```

Dette er den enkleste formen for grain-test, og den bør alltid brukes når én kolonne alene identifiserer modellen.

## Sammensatt grain

Mange modeller har grain som består av flere kolonner.

Eksempel:

- én rad per person per måned

Da holder det ikke å teste kolonnene hver for seg. Vi må teste kombinasjonen.

Eksempel på modellkontrakt:

- `person_id`
- `maaned`

Begge bør være `not_null`, og kombinasjonen bør være unik.

Eksempel i yml:

```yaml
models:
  - name: fak_person_maaned
    columns:
      - name: person_id
        tests:
          - not_null
      - name: maaned
        tests:
          - not_null
```

Selve unikheten på kombinasjonen kan testes på flere måter.

### Med en generisk pakke-test

Hvis prosjektet bruker en pakke som støtter kombinerte unikhetstester, kan dere bruke den.

Typisk eksempel:

```yaml
models:
  - name: fak_person_maaned
    tests:
      - dbt_utils.unique_combination_of_columns:
          combination_of_columns:
            - person_id
            - maaned
```

### Med en egen singular test

Hvis dere ikke vil være avhengige av en pakke, er en singular test ofte like bra og tydeligere.

Eksempel:

```sql
select
    person_id,
    maaned,
    count(*) as antall
from {{ ref('fak_person_maaned') }}
group by 1, 2
having count(*) > 1
```

Hvis denne testen returnerer rader, er grain brutt.

## Historisert grain

Historiserte modeller er stedet der grain-testing oftest blir for svak.

Hvis grain er:

- én rad per person per gyldighetsintervall

er det ikke nok å teste `person_id`. Vi må teste hele historikknivået.

Typisk trenger vi:

- `not_null` på `person_id`
- `not_null` på `gyldig_fom_dato` eller tilsvarende startkolonne
- unikhet på kombinasjonen av identitet og start på intervallet

Eksempel:

```yaml
models:
  - name: dim_person
    columns:
      - name: person_id
        tests:
          - not_null
      - name: gyldig_fom_dato
        tests:
          - not_null
```

Og som kombinasjonstest:

```sql
select
    person_id,
    gyldig_fom_dato,
    count(*) as antall
from {{ ref('dim_person') }}
group by 1, 2
having count(*) > 1
```

## Grain-test er ikke alltid nok alene

For historiserte modeller er unikhet ofte nødvendig, men ikke tilstrekkelig.

En modell kan fortsatt ha riktig unikhet og likevel være feil hvis:

- gyldighetsintervall overlapper
- historikken har hull som ikke skal være der
- det finnes flere gjeldende rader samtidig

Da må vi supplere med egne regler.

## Eksempel: bare én gjeldende rad

Hvis modellen skal ha maks én gjeldende rad per identitet, bør det testes eksplisitt.

Eksempel:

```sql
select
    person_id,
    count(*) as antall
from {{ ref('dim_person') }}
where er_gjeldende = true
group by 1
having count(*) > 1
```

Denne testen fanger et vanlig historikkproblem som ikke fanges av vanlig unikhetstest alene.

## Eksempel: ingen overlapp i historikk

Hvis historikken skal være sammenhengende uten overlapp, bør det testes med en egen test.

Prinsippet er å sammenligne hver rad med neste rad for samme identitet og sjekke at intervallene ikke overlapper.

For eksempel:

```sql
with historikk as (
    select
        person_id,
        gyldig_fom_dato,
        gyldig_tom_dato,
        lead(gyldig_fom_dato) over (
            partition by person_id
            order by gyldig_fom_dato
        ) as neste_fom
    from {{ ref('dim_person') }}
)
select *
from historikk
where neste_fom is not null
  and gyldig_tom_dato >= neste_fom
```

Om testen skal se etter overlapp eller hull avhenger av historikkprinsippet i modellen.

## OBT-er må også testes på grain

OBT-er er ofte spesielt sårbare fordi de bygges ved å kombinere flere modeller.

Hvis grain er:

- én rad per person

så skal resultatet fortsatt være én rad per person, selv om modellen joiner flere kilder.

Et godt minimum er derfor:

- `not_null` på identiteten
- `unique` eller kombinasjonsunikhet på grain-kolonnene

Eksempel:

```yaml
models:
  - name: obt_oppfolging_person
    columns:
      - name: person_id
        tests:
          - not_null
          - unique
```

Dette er viktig fordi OBT-er ofte ser riktige ut i små utvalg, men får skjulte duplikater når de kjøres fullt.

## Hvordan velge riktig testnivå

Bruk denne tommelfingerregelen:

- Én nøkkelkolonne: `not_null` + `unique`
- Sammensatt grain: `not_null` på hver kolonne + kombinasjonsunikhet
- Historisert grain: som over, pluss egne tester for gjeldende rad, overlapp eller hull når relevant
- OBT: test alltid at resultatet fortsatt har det grain modellen lover

## Hva som bør stå i yml

For en eksponert modell bør yml og tester peke på samme forståelse av grain.

Eksempel:

```yaml
models:
  - name: dim_person
    description: |
      Persondimensjon med historikk.
      Grain: En rad per person per gyldighetsintervall.
    meta:
      grain: En rad per person per gyldighetsintervall
      grain_keys:
        - person_id
        - gyldig_fom_dato
    columns:
      - name: person_id
        tests:
          - not_null
      - name: gyldig_fom_dato
        tests:
          - not_null
```

Og i tillegg en unikhetstest på kombinasjonen som faktisk representerer grain.

## Praktisk tommelfingerregel

- Start med å teste nøkkelkolonnene.
- Test så at grain-kombinasjonen faktisk er unik.
- Hvis modellen er historisert, test også historikkreglene.
- Hvis modellen er en OBT, test at joins ikke har ødelagt grain.
- Hvis testen ikke kan forklare hvilken kontrakt den beskytter, er den ofte for svak.