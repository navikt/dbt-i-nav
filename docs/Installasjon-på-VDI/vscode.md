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

dbt Power User krever at man setter opp **miljøvariabler** med credentials via PowerShell, **før** VS Code startes opp i samme PowerShell-sesjon.

Det finnes et skript [start_vscode_dbt.ps1](https://github.com/navikt/dbt-i-nav/blob/main/start_vscode_dbt.ps1) i dette repoet som setter opp miljøvariable, oppretter python miljø hvis det ikke finnes fra før, og starter Visual Studtio Code som forenkler denne prosessen.

Skriptet er generelt og krever at stien til et gyldig dbt-prosjekt settes som argument i tillegg til schemanavnet dbt skal bruke som proxy. F.eks.:

```shell
start_vscode_dbt.ps1 c:\\sti\\til\\dbt-prosjekt\\ skjemanavn
```

(Her må `c:\sti\til\dbt-prosjekt\` peke på mappen som inneholder `dbt_project.yml`)

Ideen er at man kan legge skriptet et faststed på utviklerimage: `c:\dbt\start_vscode_dbt.ps1`, og lage snarveier på skrivebordet til hvert av prosjektene, slik at miljøet for hvert prosjekt kan startes opp med et dobbeltklikk.

For slikt oppsett, gjør følgende per komponent/dbt prosjekt du har:

1. Høyreklikk - hold - dra over skrivebordet - slipp. Velg `Lag snarveier her`.

    ![Lag snarvei](vscode/lag_snarvei.png)

2. Høyreklikk på den nye snarveien og velg `Egenskaper`

    ![Høyreklikk](vscode/egenskaper.png)

3. Fyll inn følgende tekst i `Mål`: `powershell.exe -noexit -ExecutionPolicy Bypass -File "C:\dbt\start_vscode_dbt.ps1" c:\sti\til\dbt-prosjekt\  databaseskjemanavn`

    ![Mål](vscode/maal.png)

4. Endre navn på snarvei til noe mer passende:
    
    ![Endre navn](vscode/endre_navn.png)



##### Oracle oppsett for Preview query

**Preview query**-template må endres for Oracle-bruk:  
1. Åpne Settings ved å trykke `CTRL + ,`
2. Søk etter `dbt.queryTemplate`
3. Endre skript til `select * from ({query}) where ROWNUM <= {limit}`

Ref.: [#dbtquerytemplate-for-oracle](https://docs.myaltimate.com/setup/optConfig/#dbtquerytemplate-for-oracle)


#### Erfaringer - feil som har oppstått ved bruk av dbt Power User:
- Hele dbt-prosjektet blir validert når prosjekt-mappen åpnes. Eventuelle initielle imports som er lagt inn i dbt_run.py, som f.eks. `from google.cloud import secretmanager`, vil gi feil i VDI Utvikler. Begrens initielle imports til grunnleggende behov.