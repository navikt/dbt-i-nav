# nls settings når du jobber med dbt

dbt kjøringer skal være deterministiske og konsistente, uavhengig av hvor de kjøres. For å oppnå dette, må vi sørge for at nls innstillingene også gjelder med dbt i Knast.

## Hva er nls settings?

NLS settings er innstillinger i Oracle som påvirker hvordan data håndteres, spesielt når det gjelder datoer, tall og tekst. For eksempel kan nls settings påvirke hvordan datoer formateres og tolkes, noe som kan føre til feil hvis de ikke er satt riktig.

## Hvordan sette nls settings i dbt?
For å sikre at nls settings er satt riktig når du kjører dbt i Knast, må du legge til følgende konfigurasjon i `dbt_project.yml`:

```yaml 
models:
  +pre_hook: "ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS'"
```

## TL;DR

- åpne repoet ditt i Knast

Hvis dette fungerer, trenger du ikke lese resten av siden før du står fast.