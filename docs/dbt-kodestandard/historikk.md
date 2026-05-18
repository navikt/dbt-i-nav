# Historikk i dbt

Denne siden beskriver hvordan historikkregler skal implementeres i dbt.

Selve historikkprinsippene for dataproduktet er beskrevet i [../dataprodukt/historikk.md](../dataprodukt/historikk.md).

## Formål i dbt

Historikk-implementasjonen i dbt skal gjøre det mulig å:

- uttrykke valgt historikkprinsipp med tydelige kolonnenavn
- dokumentere historikk i `description` og `meta`
- teste at historikkreglene faktisk holder
- skille mellom kildegyldighet og dataprodukttid i modellen

## Hovedregel i dbt

Historikk som er definert på dataproduktnivå skal uttrykkes eksplisitt i dbt-modellen.

Det betyr:

- historikkfelter skal ha tydelige navn
- `description` skal forklare historikkprinsippet
- `meta` skal kunne bære strukturert historikkinformasjon når det er nyttig
- testene skal verifisere valgt historikkmønster

## Anbefalte kolonnenavn

Når historikken føres per døgn, bruk normalt:

- `gyldig_fom_dato`
- `gyldig_tom_dato`
- `lastet_dato`
- `oppdatert_dato`

Når historikken føres med sekundoppløsning, bruk normalt:

- `gyldig_fom_tid`
- `gyldig_til_tid`
- `lastet_tid`
- `oppdatert_tid`

Når kilden krever høyere oppløsning, bruk normalt:

- `gyldig_fom_ts`
- `gyldig_til_ts`
- `lastet_ts`
- `oppdatert_ts`

## Hvordan dokumentere historikk i yml

Eksempel:

```yaml
models:
	- name: dim_person
		description: |
			Persondimensjon med historikk.
			Granularitet: En rad per person per gyldighetsintervall.
			Historikk: Gyldighetsintervallet beskriver perioden raden var gyldig i kilden.
		meta:
			historikk: dato
			historikk_kolonner:
				- gyldig_fom_dato
				- gyldig_tom_dato
				- er_gjeldende
```

## Hva som bør testes

Historikk bør i dbt normalt verifiseres med tester for:

- `not_null` på identitet og startkolonne
- unikhet på kombinasjonen som identifiserer historikken
- maks én gjeldende rad når modellen har et slikt prinsipp
- overlapp eller hull når dette er relevant for modellen
- etterregistreringer når produktet har krav om stabile historiske tall

For konkrete testmønstre, se [testing.md](testing.md).

## Praktisk tommelfingerregel

- Velg navn og felter som passer historikkprinsippet som allerede er definert for dataproduktet.
- Dokumenter historikk eksplisitt i `description`.
- Bruk `meta` når historikken skal være maskinlesbar.
- Test historikkreglene, ikke bare kolonnenes eksistens.
