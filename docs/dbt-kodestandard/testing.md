# Testing

Testing skal bekrefte at modellen faktisk oppfører seg slik kontrakten sier. For granularitet betyr det at vi tester at én rad virkelig representerer det modellen sier at den representerer.

Det holder ikke å skrive granularitet i dokumentasjonen. Granularitet må også bevises i test.

## Hva det betyr å teste granularitet

Når vi tester granularitet, tester vi i praksis tre ting:

- at nøkkelkolonnene som identifiserer granulariteten ikke er `null`
- at kombinasjonen av disse kolonnene er unik på riktig nivå
- at eventuelle historikkregler eller forretningsregler ikke bryter granulariteten

Hvis granulariteten er feil, får vi ofte disse symptomene:

- joins som multipliserer rader
- aggregater som blir for høye
- OBT-er med duplikater
- historikk som overlapper eller lager hull

## Hovedregel

Granularitet for alle eksponerte modeller skal være testet.

Det betyr:

- `dim_`-modeller skal ha tester som bekrefter sin granularitet
- `fak_`-modeller skal ha tester som bekrefter sin granularitet
- `obt_`-modeller skal ha tester som bekrefter sin granularitet

Se også [Granularitet](grain.md) og [modellkontrakter.md](modellkontrakter.md).

## Start alltid med nøkkelkolonnene

Den enkleste og viktigste starten er å teste nøkkelkolonnene som identifiserer granulariteten.

Hvis granulariteten er:

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

Dette er den enkleste formen for test av granularitet, og den bør alltid brukes når én kolonne alene identifiserer modellen.

## Sammensatt granularitet

Mange modeller har granularitet som består av flere kolonner.

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

Hvis denne testen returnerer rader, er granulariteten brutt.

## Historisert granularitet

Historiserte modeller er stedet der testing av granularitet oftest blir for svak.

Hvis granulariteten er:

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

## Test av granularitet er ikke alltid nok alene

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

## Eksempel: etterregistreringer med mer enn 24 timers forskyvning

Når et dataprodukt både har kildegyldighet og observasjonstid eller lastetid, bør vi som standard ha en test som fanger opp store etterregistreringer.

Hensikten er ikke nødvendigvis å stoppe alle slike rader, men å gjøre dem synlige. For mange produkter vil dette være et viktig varsel om at publisert historie kan bli ustabil hvis data brukes ukritisk tilbake i tid.

Typisk regel:

- flagg rader der observasjonstid ligger mer enn 24 timer etter start på kildegyldigheten

Dette forutsetter at modellen har begge typer tid tilgjengelig, for eksempel:

- `gyldig_fom_tid` eller `gyldig_fom_dato`
- `lastet_tid`, `lastet_ts` eller annen observasjonstid

Eksempel som singular test:

```sql
select *
from {{ ref('dim_person') }}
where lastet_tid > gyldig_fom_tid + interval '24' hour
```

Ved døgnoppløsning kan samme idé uttrykkes slik:

```sql
select *
from {{ ref('dim_person') }}
where lastet_dato > gyldig_fom_dato + 1
```

Hvis disse testene returnerer rader, har modellen etterregistreringer som ligger mer enn ett døgn etter kildegyldigheten.

## Hvorfor dette er nyttig

Denne testen hjelper oss å oppdage modeller der:

- kilden registrerer hendelser sent
- dataproduktet mottar data lenge etter at de egentlig gjaldt
- historiske tall kan bli omskrevet bakover i tid

Det gjør testen spesielt nyttig for statistikk, perioderapportering og andre produkter der stabile tall er viktigere enn full retroaktiv korreksjon i standardvisningen.

## Som generisk standardtest

Dette egner seg godt som en generisk test med parameterisering av:

- modell
- kolonne for gyldig start
- kolonne for observasjonstid eller lastetid
- terskel i timer

Konseptuelt:

```yaml
models:
  - name: dim_person
    tests:
      - etterregistrering_lag_maks:
          valid_from_column: gyldig_fom_tid
          observed_at_column: lastet_tid
          max_lag_hours: 24
```

Et mulig utgangspunkt for en slik generic test-makro kan se slik ut:

```sql
{% test etterregistrering_lag_maks(model, valid_from_column, observed_at_column, max_lag_hours) %}

select *
from {{ model }}
where {{ observed_at_column }} is not null
  and {{ valid_from_column }} is not null
  and {{ observed_at_column }} > {{ valid_from_column }} + interval '{{ max_lag_hours }}' hour

{% endtest %}
```

Hvis dere ønsker en variant for døgnoppløsning, kan den lages som en egen test eller som en parameterisert variant som bruker dager i stedet for timer.

For eksempel:

```sql
{% test etterregistrering_lag_maks_dager(model, valid_from_column, observed_at_column, max_lag_days) %}

select *
from {{ model }}
where {{ observed_at_column }} is not null
  and {{ valid_from_column }} is not null
  and {{ observed_at_column }} > {{ valid_from_column }} + {{ max_lag_days }}

{% endtest %}
```

Disse testene bør sees som standardmønstre.

Poenget er ikke at alle modeller skal feile på etterregistreringer, men at dette skal være en bevisst vurdering. For noen modeller bør testen være feilende. For andre kan den brukes som overvåking eller avviksrapportering.

## Når testen bør være standard

Denne testen bør være standard for modeller der:

- historiske tall brukes i rapportering
- data kommer fra kilder med kjent etterslep
- etterregistreringer kan endre aggregater bakover i tid
- modellen eksponeres bredt til konsumenter som forventer stabile tall

Hvis en modell bevisst tillater store etterregistreringer uten at dette er et problem, bør det dokumenteres eksplisitt i kontrakten.

## OBT-er må også testes på granularitet

OBT-er er ofte spesielt sårbare fordi de bygges ved å kombinere flere modeller.

Hvis granulariteten er:

- én rad per person

så skal resultatet fortsatt være én rad per person, selv om modellen joiner flere kilder.

Et godt minimum er derfor:

- `not_null` på identiteten
- `unique` eller kombinasjonsunikhet på kolonnene som definerer granulariteten

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
- Sammensatt granularitet: `not_null` på hver kolonne + kombinasjonsunikhet
- Historisert granularitet: som over, pluss egne tester for gjeldende rad, overlapp eller hull når relevant
- OBT: test alltid at resultatet fortsatt har den granulariteten modellen lover

## Hva som bør stå i yml

For en eksponert modell bør yml og tester peke på samme forståelse av granularitet.

Eksempel:

```yaml
models:
  - name: dim_person
    description: |
      Persondimensjon med historikk.
      Granularitet: En rad per person per gyldighetsintervall.
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

Og i tillegg en unikhetstest på kombinasjonen som faktisk representerer granulariteten.

## Praktisk tommelfingerregel

- Start med å teste nøkkelkolonnene.
- Test så at kombinasjonen som uttrykker granulariteten faktisk er unik.
- Hvis modellen er historisert, test også historikkreglene.
- Hvis modellen er en OBT, test at joins ikke har ødelagt granulariteten.
- Hvis testen ikke kan forklare hvilken kontrakt den beskytter, er den ofte for svak.

## Standard testpakke

Siden dette er standarder som skal følges, må det være tydelig hvilke tester som er obligatoriske.

For hver modelltype under beskriver vi derfor:

- tester som SKAL brukes
- tester som BØR brukes når modellen har bestemte egenskaper eller brukes i bestemte sammenhenger

SKAL betyr at modellen ikke er ferdig standardisert uten disse testene.

BØR betyr at testen normalt skal brukes, men at det kan finnes bevisste unntak som må dokumenteres i kontrakten.

### 1. Enkel `fak_`

Bruk denne pakken når granulariteten er én rad per hendelse eller én rad per nøkkel.

Typisk eksempel:

- `fak_vedtak`
- granularitet: én rad per vedtak

SKAL:

- `not_null` på nøkkelkolonnen
- `unique` på nøkkelkolonnen

BØR:

- `relationships` til sentrale dimensjoner når disse er en del av kontrakten

Eksempel:

```yaml
models:
  - name: fak_vedtak
    columns:
      - name: vedtak_id
        tests:
          - not_null
          - unique
      - name: person_id
        tests:
          - not_null
```

### 2. Historisert `dim_`

Bruk denne pakken når granulariteten er én rad per identitet per gyldighetsintervall.

Typisk eksempel:

- `dim_person`
- granularitet: én rad per person per gyldighetsintervall

SKAL:

- `not_null` på identitet
- `not_null` på start av gyldighetsintervall
- unikhet på kombinasjonen av identitet og start av intervall
- test for maks én gjeldende rad

BØR:

- test for overlapp i historikk når modellen skal være uten overlapp
- test for hull i historikk når modellen skal være sammenhengende

SKAL for rapporteringsprodukter og andre modeller med krav om stabile historiske tall:

- test for etterregistreringer over definert terskel, for eksempel 24 timer

Eksempel:

```yaml
models:
  - name: dim_person
    tests:
      - dbt_utils.unique_combination_of_columns:
          combination_of_columns:
            - person_id
            - gyldig_fom_dato
      - etterregistrering_lag_maks:
          valid_from_column: gyldig_fom_tid
          observed_at_column: lastet_tid
          max_lag_hours: 24
    columns:
      - name: person_id
        tests:
          - not_null
      - name: gyldig_fom_dato
        tests:
          - not_null
```

### 3. `obt_` med joins

Bruk denne pakken når modellen settes sammen av flere kilder eller modeller og det er risiko for radmultiplikasjon.

Typisk eksempel:

- `obt_oppfolging_person`
- granularitet: én rad per person

SKAL:

- `not_null` på identiteten som definerer granulariteten
- `unique` eller kombinasjonsunikhet på granulariteten

Dette betyr i praksis at OBT-en må ha en test som bekrefter at resultatet fortsatt holder lovet granularitet. For en enkel OBT med én identitet kan `unique` på denne kolonnen være tilstrekkelig. For sammensatt granularitet skal kombinasjonen testes eksplisitt.

BØR:

- test for at kun én gjeldende rad per identitet er med i grunnlaget

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

## Praktisk valg av pakke

Bruk denne enkle beslutningen:

- Hvis modellen har én rad per enkel nøkkel: bruk pakken for enkel `fak_`.
- Hvis modellen har historikk i granulariteten: bruk pakken for historisert `dim_`.
- Hvis modellen er bygget ved brede joins: bruk pakken for `obt_` med joins.

Hvis modellen både er historisert og bredt eksponert, bør testpakken kombineres.

## Kort oppsummert

- En enkel `fak_` SKAL ha `not_null` og `unique` på nøkkelen som definerer granulariteten.
- En historisert `dim_` SKAL ha `not_null` på identitet og start på intervall, unikhet på kombinasjonen som definerer granulariteten og test for maks én gjeldende rad.
- En `obt_` SKAL ha tester som beviser at joins ikke har ødelagt granulariteten.
- Test for etterregistreringer SKAL brukes når modellen inngår i rapportering eller statistikk med krav om stabile tall.