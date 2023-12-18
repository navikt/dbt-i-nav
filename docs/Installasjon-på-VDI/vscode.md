# Visual Studio Code

Bruk https://code.visualstudio.com/download, velg Windows versjonen. Last ned, pakk ut og start programmet code. Følg instruksjonene ved innstalleringen.

## Anbefalte extensions

### dbt Power User

https://github.com/AltimateAI/vscode-dbt-power-user

dbt Power User gir oss en rekke nyttige verktøy, som f.eks.:
- Auto-complete dbt code
- SQL validator
- Column lineage
- Preview query results

#### Installasjon og oppsett
Installeres via VS Code Marketplace, følg installasjonsrutinene til Altimate: https://docs.myaltimate.com/

Utover standardinstallasjon må følgende hensyn tas for bruk på VDI Utvikler og mot Oracle DVH:

**NB!** dbt Power User krever at man setter opp miljøvariabler med credentials via PowerShell, **før** VS Code startes opp i samme PowerShell-sesjon.
(Espen jobber med et PowerShell script som skal gjøre denne operasjonen enklere)

Preview query-template må endres til: `select * from ({query})\n where ROWNUM <= {limit}`, ref. https://docs.myaltimate.com/setup/optConfig/#dbtquerytemplate-for-oracle


#### Erfaringer - feil som har oppstått ved bruk av dbt Power User:
- Hele dbt-prosjektet blir validert når prosjekt-mappen åpnes. Eventuelle initielle imports som er lagt inn i dbt_run.py, som f.eks. `from google.cloud import secretmanager`, vil gi feil i VDI Utvikler. Begrens initielle imports til grunnleggende behov.