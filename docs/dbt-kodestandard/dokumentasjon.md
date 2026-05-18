# Dokumentasjon i dbt

Denne siden beskriver hvordan dokumentasjon uttrykkes i dbt.

For bakgrunn og produktregler, se [../dataprodukt/dokumentasjon.md](../dataprodukt/dokumentasjon.md).

## Hva som skal stå i modellbeskrivelsen

Beskrivelsen av modellen bør minst svare på:

- hva modellen inneholder
- hvem eller hva modellen beskriver
- om modellen er historisert
- hva granulariteten er

Eksempel:

```yaml
models:
  - name: fak_vedtak
    description: |
      Vedtak i komponenten arbeid.
      Modellen brukes som grunnlag for analyse av vedtak og vedtaksstatus.
      Granularitet: En rad per vedtak.
      Historikk: Modellen er ikke historisert.
```

## Meta for strukturert dokumentasjon

Der det er nyttig, skal dokumentasjonen også legges i `meta`, slik at den blir maskinlesbar.

I løpende tekst bruker vi `granularitet`, men i `meta` bruker vi `grain` og `grain_keys`.

Anbefalte metadata for eksponerte modeller:

- `owner`
- `grain`
- `grain_keys`
- `historikk`
- `historikk_kolonner`

Eksempel:

```yaml
models:
  - name: dim_person
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
```

## Dokumentasjon i dbt docs

Det som ligger i yml skal være nok til at dbt docs blir nyttig for andre team.

En konsument skal kunne åpne modellen i dbt docs og forstå:

- hva modellen er
- hva granulariteten er
- om modellen er historisert
- hvilke kolonner som er sentrale
