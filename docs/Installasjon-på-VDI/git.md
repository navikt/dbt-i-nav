# Git

1. Installering av Git - har du den allerede er det flott.
  * Denne finner du på felles disken under programvare. programvare\git\. Installer f.eks Git-2.30.2-64-bit. Legg installasjon directory inn i miljøvariabel  PATH. F.eks `C:\Users\<brukernavn>\AppData\Local\GitHubDesktop\bin`
2. Dette steget er sannsynligvis ikke nødvendig, og utføres kun om det oppstår problemer i senere steg. Oppdatere miljøvariabler slik at utviklingsimaget kan kommunisere med Github. Dette er beskrevet i https://confluence.adeo.no/pages/viewpage.action?pageId=272519832 punkt 10c
  * Følgende legges inn som miljø variabler
  * https_proxy til http://webproxy-utvikler.nav.no:8088
  * http_proxy: http://155.55.60.117:8088/
  * no_proxy: localhost,127.0.0.1,*.adeo.no,.local,.adeo.no,.nav.no,.aetat.no,.devillo.no,.oera.no,devel
3. Opprett et PAT (personal access token) som du må bruke som passord ved autentisering. Se https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token Alternativt kan du bruke [GitHub Dekstop](https://docs.github.com/en/desktop/installing-and-configuring-github-desktop/installing-and-authenticating-to-github-desktop/installing-github-desktop) som setter dette opp for deg automatisk.
4. Clone repositoriet du skal jobbe med. Husk å bruke PAT opprettet i punkt 3. som passord om du ikke bruker GitHub Desktop.
