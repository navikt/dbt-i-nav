# Regler ved bruk av Knast for jobbe på DWH
- Kun nettleser basert Knast image (dvs Data Build Tool (dbt) imager, VSCode og Notebook image) er godkjent å bruke mot DVH baser. Andre imager blir sperret av basen.
- Alle har mulighet å åpne mot externe URLer i Knast. Disse er tidsbegreset og må aktiveres ved start av Knast.
- Det anbefales sterkt at bruker unngår å lagre data på sin Knast-image. Også anbefales det å rydde i gamle filer som inneholder sensitiv data. 
- For bruk av python, les veiledning fra nada [her](https://docs.knada.io/analyse/knast/kom-i-gang/#python ) og python-pakker [her]( https://docs.knada.io/analyse/knast/miljo/)


| Tillat  ✅  | Ikke tillat ❌|
| -------- | ------- |
| Bruk Knast kun i nettleseren  | Bruke lokale IDE for Knast    |
| Bruk "uv" for å installere python pakker; [se hvordan](https://docs.knada.io/analyse/knast/kom-i-gang/#python) | Åpne URL for å installere python pakker.     |
| Rydd i gamle filer, spesielt hvis de inneholder data, hemligheter e.l.    | Lagre data i filer på disk for lengre tid.    |
| Åpne URLer ved tjenstlig behov, f.eks. NAV sin github repo, hente data fra andre eksterne godkjente kilder.    | Åpne URLer ved IKKE tjenstlig behov.   |


!!!question "Spørsmål?"
    Skriv gjerne på [Slack](https://nav-it.slack.com/archives/C0859E82VA6)