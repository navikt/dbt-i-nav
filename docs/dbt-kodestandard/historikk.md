# Historikk i dbt

Denne siden beskriver hvordan historikk uttrykkes i dbt.

For bakgrunn og produktregler, se [../dataprodukt/historikk.md](../dataprodukt/historikk.md).

## Hovedregel i dbt

Historikk som allerede er valgt for dataproduktet skal uttrykkes eksplisitt i dbt-modellen.

Det betyr:

- tydelige historikkfelter i modellen
- historikk forklart i `description`
- strukturert metadata i `meta` når det er nyttig
- tester som verifiserer valgt historikkmønster

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

## Hva som bør testes i dbt

- `not_null` på identitet og startkolonne
- unikhet på kombinasjonen som identifiserer historikken
- maks én gjeldende rad når modellen har et slikt prinsipp
- overlapp eller hull når dette er relevant for modellen
- etterregistreringer når produktet har krav om stabile historiske tall

For konkrete testmønstre, se [testing.md](testing.md).
