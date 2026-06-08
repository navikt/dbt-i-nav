# nls settings

dbt kjøringer skal være deterministiske og konsistente, uavhengig av hvor de kjøres. For å oppnå dette, må vi sørge for at nls innstillingene også gjelder med dbt i Knast.

## Hva er nls settings?

NLS settings er innstillinger i Oracle som påvirker hvordan data håndteres, spesielt når det gjelder datoer, tall og tekst. For eksempel kan nls settings påvirke formateringer, tolking og sortering av data, noe som kan føre til feil hvis de ikke er satt riktig. Når du kjører dbt i Knast, brukes de samme nls innstillingene som er default i Oracle. 

## Anbefalte nls settings for dbt kjøringer i Knast inkluderer:

1. `NLS_LENGTH_SEMANTICS = CHAR`. MÅ være lik overalt (SQL klient + dbt + DB default) siden vi har gått over til CHAR semantics for å unngå problemer med multibyte tegn. 

2. `NLS_SORT` må settes ut fra hva du ønsker å gjøre:
    1. Mindre mengder data: `NLS_SORT = NORWEGIAN` - databasen vil da sortere ÆØÅ i denne rekkefølgen. (Merk at Aa sorteres som to a'er og ikke som Å.)
    2. Større mengder data der sortering av ÆØÅ ikke er så viktig: `NLS_SORT = BINARY` - dette er mer effektivt for databasen da den kan sortere etter binærverdiene og unngår en "nls-casting"-operasjon for hver rad.

3. ???`NLS_COMP = BINARY`. Sammenligninger bør gjøres basert på binærverdiene av dataene. Dette er spesielt viktig når `NLS_SORT` ikke er satt til `BINARY`.

## Hvordan sette nls settings i dbt?
For å sikre at nls settings er satt riktig når du kjører dbt i Knast, må du legge til følgende konfigurasjon i `dbt_project.yml`:

```yaml 
  +pre-hook:
    - "ALTER SESSION SET NLS_LANGUAGE = NORWEGIAN"
    - "ALTER SESSION SET NLS_TERRITORY = NORWAY"
    - "ALTER SESSION SET NLS_SORT = BINARY"
    - "ALTER SESSION SET NLS_COMP = 'BINARY'"
    - "ALTER SESSION SET NLS_DATE_LANGUAGE = NORWEGIAN"
    - "ALTER SESSION SET NLS_DATE_FORMAT = 'DD.MM.YYYY HH24:MI:SS'"
    - "ALTER SESSION SET NLS_TIME_FORMAT = 'HH24:MI:SSXFF'"
    - "ALTER SESSION SET NLS_TIME_TZ_FORMAT = 'HH24:MI:SSXFF TZR'"
    - "ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'DD.MM.YYYY HH24:MI:SSXFF'"
    - "ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT = 'DD.MM.YYYY HH24:MI:SSXFF TZR'"
    - "ALTER SESSION SET NLS_CURRENCY = NOK"
    - "ALTER SESSION SET NLS_DUAL_CURRENCY = 'Kr.'"
    - "ALTER SESSION SET NLS_ISO_CURRENCY = NORWAY"
    - "ALTER SESSION SET NLS_CALENDAR = GREGORIAN"
    - "ALTER SESSION SET NLS_LENGTH_SEMANTICS = CHAR"
```

Bare vær klar over at dette ikke fungerer for tester.


## Anbefalinger for SQL Developer extension i VS Code
For at resultatene i SQL Developer skal være konsistente med det som skjer i dbt, anbefales det å sette følgende nls settings i VS Code:

Dette kan gjøres ved å legge til følgende innstillinger i `settings.json` i VS Code. Du finner `settings.json` ved å åpne Command Palette (Ctrl+Shift+P), skrive "Preferences: Open User Settings (JSON)" og trykke Enter. Legg deretter til følgende konfigurasjon:

```json
  "sqldeveloper.database.nls.language": "NORWEGIAN",
  "sqldeveloper.database.nls.territory": "NORWAY",
  "sqldeveloper.database.nls.dateLanguage": "NORWEGIAN",
  "sqldeveloper.database.nls.dateFormat": "DD.MM.YYYY HH24:MI:SS",
  "sqldeveloper.database.nls.timestampFormat": "DD.MM.YYYY HH24:MI:SSXFF",
  "sqldeveloper.database.nls.timestampTZFormat": "DD.MM.YYYY HH24:MI:SSXFF TZR",
  "sqldeveloper.database.nls.currency": "NOK",
  "sqldeveloper.database.nls.ISOCurrency": "NORWAY",
  "sqldeveloper.database.nls.groupSeparator": "",
  "sqldeveloper.database.nls.decimalSeparator": ",",
  "sqldeveloper.database.nls.length": "CHAR",
  "sqldeveloper.database.nls.sort": "BINARY",
  "sqldeveloper.database.nls.comparison": "BINARY",
```
  
## TL;DR

- åpne repoet ditt i Knast

Hvis dette fungerer, trenger du ikke lese resten av siden før du står fast.