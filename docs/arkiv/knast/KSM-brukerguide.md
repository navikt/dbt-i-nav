# KSM – Brukerguide

Knast Secret Manager (KSM) injiserer Oracle-credentials automatisk når `dbt` kjører, uten at brukeren trenger å håndtere passord manuelt.

---

## Komponenter

| Komponent | Rolle |
|---|---|
| `knast-secret-manager` (ksm) | Miljøoppsett, logging. Lastes automatisk via `.pth`-fil. |
| `dbt-oracle-secure` | Patcher `dbt-oracle` med credentials. Lastes automatisk via `.pth`-fil. Krever ksm. |
| `dvh` | Interaktiv kommando for å velge DVH-miljø og venv. |
| `shell-integration.sh` | Sources i `.bashrc`/`.profile` – aktiverer riktig venv ved terminaloppstart. |
| `~/KSM/env-config.env` | Persistert konfig (miljø, schema, DSN etc.). Leses av KSM ved oppstart. |

---

## Oppsett


### Velg DVH-miljø med `dvh`

```bash
dvh
```

Velg python miljø fra lista og deretter DVH miljø. Valget lagres i `~/KSM/env-config.env`.

> `dvh` krever at filen `/opt/KSM/tns.json` er tilgjengelig. Den lastes inn autmatisk ved oppstart.

---
## Bruke KSM i eget Python-miljø

Dersom du bruker et eget virtuelt miljø (f.eks. med `dvh_tools` eller andre prosjektavhengigheter), må KSM installeres manuelt i dette miljøet.

Kjør følgende kommando én gang per venv (installasjonen overlever oppdateringer i miljøet):

```bash
dvh ksm install
```
### Restart etter installasjon

Etter at KSM er installert i et nytt miljø, må du restarte Knast for at VSCode-utvidelser som PowerUser skal plukke opp det nye miljøet.

---


## Hvordan auto-aktivering fungerer

Når Python starter (i valgt venv), kjøres `.pth`-filene i site-packages automatisk:

```
dbt-oracle-secure-activate.pth  →  import dbt_oracle_secure.auto
                                          ↳  import ksm.auto
                                                ↳  leser ~/KSM/env-config.env
                                                ↳  setter miljøvariabler
                                          ↳  installerer Oracle credential-hook
                                                ↳  trigger: når dbt laster dbt.adapters.oracle.connections
```

---

## Kjøre dbt

Legg til følgende i `profiles.yml` under hver dbt prosjekt:

```yaml
knast:
      host: "{{env_var('DBT_DB_HOST')}}"
      password: placeholder
      port: "{{env_var('DBT_DB_PORT')}}"
      protocol: tcp
      schema: <schema_name>
      service: "{{env_var('DBT_ENV_SERVICE')}}"
      database: "{{env_var('DBT_DB_NAME')}}"
      threads: 1
      type: oracle
      user: "{{env_var('DBT_ENV_SECRET_USER')}}"
```

> **⚠️ Important:** `schema:` må spesifiseres av bruker i `profiles.yml` under hver dbt prosjekt.

---

Med `dvh` kjørt og riktig venv aktivert:

```bash
dbt debug      # Verifiser tilkobling
dbt run        # Kjør modeller
dbt test       # Kjør tester
```

Credentials hentes fra keyring/sockets-backend og injiseres transparent.

---

### Logg

```bash
tail -f ~/KSM/logs/usage.log
```


---

## Bytte miljø

```bash
dvh
```

Velg nytt miljø i menyen. `~/KSM/env-config.env` oppdateres umiddelbart – neste `dbt`-kjøring bruker det nye miljøet.

---

\## `~/KSM/env-config.env` – nøkkelvariabler

Dette er miljøvariabler som skrives automatisk av dvh kommandoen

```dotenv
DVH_ENVIRONMENT=DVH_P     # Hvilken DVH-instans som er aktiv
SCHEMA= # dbt-schema, tom = harkode i din profiles.yml
DBT_DB_HOST=dmv01-scan.adeo.no
DBT_DB_PORT=1531
DBT_ENV_SECRET_USER=a123456
DBT_ENV_SERVICE=cccdwh01
VENV_PATH=/opt/KSM/.dbtenv   # Python-venv som shell-integration aktiverer
```

---

## Feilsøking

| Problem | Sjekk |
|---|---|
| `dbt` finner ikke database | `dvh` – er riktig miljø valgt? Se `~/KSM/logs/usage.log` |
| Credentials mangler | `echo $DVH_ENVIRONMENT` – er den satt? |
| `.pth`-fil ikke aktiv | Er riktig venv aktivert? `which python` |
| TNS-feil | `/opt/KSM/tns.json` – finnes og er ikke tom? |
