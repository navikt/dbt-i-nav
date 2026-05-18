# Kontrakter i dbt

Denne siden beskriver hvordan kontrakter skal implementeres i dbt.

Selve kravene til kontrakten er beskrevet i [../dataprodukt/kontrakter.md](../dataprodukt/kontrakter.md).

## Formål i dbt

I dbt skal kontrakten gjøre det tydelig:

- hva modellen representerer gjennom `description`
- hva én rad representerer gjennom `description` og `meta.grain`
- hvilke kolonner som identifiserer raden gjennom `meta.grain_keys`
- hvordan historikk skal forstås gjennom `description` og eventuelt `meta`
- hvordan kontrakten verifiseres med tester

## Hvor kontrakten skal ligge

I dbt skal kontrakten ligge i modellens yml.

Som minimum bør kontrakten uttrykkes i:

- `description`, for mennesker og dbt docs
- `meta`, for maskinlesbare metadata
- tester, for å verifisere at kontrakten faktisk holder

I denne dokumentasjonen bruker vi `granularitet` i løpende tekst, men `grain` og `grain_keys` i `meta`. Det er en bevisst regel for å holde kontraktene koordinerte.

## Anbefalt struktur i yml

Eksempel:

```yaml
models:
  - name: fak_vedtak
    description: |
      Vedtak i komponenten arbeid.
      Granularitet: En rad per vedtak.
      Historikk: Modellen er ikke historisert.
    meta:
      owner: arbeid
      grain: En rad per vedtak
      grain_keys:
        - vedtak_id
      historikk: ingen
    columns:
      - name: vedtak_id
        description: Unik identifikator for vedtaket.
        tests:
          - not_null
          - unique
```

Eksempel med historikk:

```yaml
models:
  - name: dim_person
    description: |
      Persondimensjon med historikk.
      Granularitet: En rad per person per gyldighetsintervall.
      Historikk: Gyldighetsintervallet beskriver perioden raden var gyldig i kilden.
    meta:
      owner: arbeid
      grain: En rad per person per gyldighetsintervall
      grain_keys:
        - person_id
        - gyldig_fom_dato
      historikk: dato
      historikk_kolonner:
        - gyldig_fom_dato
        - gyldig_tom_dato
        - er_gjeldende
    columns:
      - name: person_id
        tests:
          - not_null
      - name: gyldig_fom_dato
        tests:
          - not_null
```

## Kontrakten skal kunne testes

En kontrakt som bare finnes i fritekst er ikke sterk nok.

Derfor skal kontrakten så langt som mulig støttes av tester, for eksempel:

- `not_null` på nøkkelkolonner
- `unique` når granulariteten er én rad per nøkkel
- sammensatte unikhetstester når granulariteten består av flere kolonner
- egne tester for historikk når modellen er historisert

Hvis dette ikke finnes i yml og tester, er kontrakten ikke godt nok implementert i dbt.