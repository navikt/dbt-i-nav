# Visual Studio Code

Bruk https://code.visualstudio.com/download, velg Windows versjonen. Last ned, pakk ut og start programmet code. Følg instruksjonene ved innstalleringen.

## Anbefalte extensions

### dbt Power User

dbt Power User gir oss en rekke nyttige verktøy, som f.eks.:

- Lekker lineage vist i VS Code 
- Auto-complete dbt code
- SQL validator
- Preview query results
- En rekke snarveier, blant annet via egne knapper
- Visning av generert SQL-kode (slipper å lete den frem i target-mappen)

[dbt Power User på GitHub](https://github.com/AltimateAI/vscode-dbt-power-user)

#### Installasjon og oppsett
Installeres via VS Code Marketplace, følg installasjonsrutinene til [Altimate](https://docs.myaltimate.com/)

##### Utover standardinstallasjon må følgende hensyn tas for bruk på VDI Utvikler og mot Oracle DVH:

dbt Power User krever at man setter opp **miljøvariabler** med credentials via PowerShell, **før** VS Code startes opp i samme PowerShell-sesjon. Dette gjøre med skriptet [start_vscode_dbt.ps1](https://github.com/navikt/dbt-i-nav/blob/main/start_vscode_dbt.ps1)

Følg denne guiden for å sette opp Visual Studio Code med riktige miljøvariable:

1. Klon dette repoet: https://github.com/navikt/dbt-i-nav/ til en lokal mappe på utivklerimage/VDI

2. Lag en snarvei på skrivebordet til [start_vscode_dbt.ps1](https://github.com/navikt/dbt-i-nav/blob/main/start_vscode_dbt.ps1) som nå ligger lokalt på VDI (inne i mappen du nettopp klonet) slik:
    ![Lag snarvei](vscode/lag_snarvei.png)

3. Høyreklikk på den nye snarveien og velg `Egenskaper`
    ![Høyreklikk](vscode/egenskaper.png)

4. Skriptet er generelt og krever at stien til et gyldig dbt-prosjekt settes som argument i tillegg til schemanavnet dbt skal bruke som proxy. Fyll derfor inn følgende tekst i `Mål`: `powershell.exe -noexit -ExecutionPolicy Bypass -File "C:\sti til dbt-i-nav\start_vscode_dbt.ps1" c:\sti\til\dbt-prosjekt\  databaseskjemanavn` og juster i forhold til stiene på ditt image.
    ![Mål](vscode/maal.png)

5. Kopier snarveien og endre stiene for hvert dbt prosjekt du vil sette opp

6. Start Visual Stusdio Code ved å dobbeltklikke på snarveien.

7. Det hender skriptet oppdateres, så det er lurt å hente siste kode fra github innimellom.



##### Oracle oppsett for Preview query

**Preview query**-template må endres for Oracle-bruk:  
1. Åpne Settings ved å trykke `CTRL + ,`
2. Søk etter `dbt.queryTemplate`
3. Endre skript til `select * from ({query}) where ROWNUM <= {limit}`

Ref.: [#dbtquerytemplate-for-oracle](https://docs.myaltimate.com/setup/optConfig/#dbtquerytemplate-for-oracle)


#### Erfaringer - feil som har oppstått ved bruk av dbt Power User:
- Hele dbt-prosjektet blir validert når prosjekt-mappen åpnes. Eventuelle initielle imports som er lagt inn i dbt_run.py, som f.eks. `from google.cloud import secretmanager`, vil gi feil i VDI Utvikler. Begrens initielle imports til grunnleggende behov.