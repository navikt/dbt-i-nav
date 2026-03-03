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

## Oppsett (én gang)

### 1. Legg til shell-integrasjon i `.bashrc`

```bash
source ~/KSM/shell-integration.sh
```

### 2. Velg DVH-miljø med `dvh`

```bash
dvh
```

Velg miljø (f.eks. `DVH_PROD`, `DVH_TEST`) og Python-venv. Valget lagres i `~/KSM/env-config.env`.

> `dvh` krever `gum` og `jq` installert, og at `/opt/KSM/tns.json` er tilgjengelig.

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

Ingen manuell konfigurasjon i `profiles.yml` for credentials – KSM håndterer det.

---

## Kjøre dbt

Med `dvh` kjørt og riktig venv aktivert:

```bash
dbt debug      # Verifiser tilkobling
dbt run        # Kjør modeller
dbt test       # Kjør tester
```

Credentials hentes fra keyring/sockets-backend og injiseres transparent.

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

## `~/KSM/env-config.env` – nøkkelvariabler

```dotenv
DVH_ENVIRONMENT=DVH_PROD     # Hvilken DVH-instans som er aktiv
SCHEMA=mitt_schema            # dbt-schema (tom = auto-detect fra repo-navn)
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
