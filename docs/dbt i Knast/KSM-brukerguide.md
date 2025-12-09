# Håndtering av passord i KNAST (Knast Secret Manager)
- KSM er et verktøy for å håndtere databasepassord (kun Datavarehus oracle-databaser P, U og R) på en sikker måte. Dette verktøyet er tilgjengelig i "DBT (Data Build tool)" Knast-image.
- KSM lagrer krypterte passord på Google Secret Manager (ikke på din egen disk) i ditt teamprosjekt. Disse kan kun dekrypteres med en nøkkel (hovedpassord) som du selv oppretter under krypteringsprosessen. Andre teammedlemmer kan kun se en kryptert JSON-streng i GCP-teamprosjektet.
- KSM gjør at databasepassord automatisk blir tilgjengelig for DBT-prosjektet ditt, uten at du må skrive inn passordene manuelt hver gang.
- Hvis du glemmer hovedpassordet, kan du kjøre "ksm-encrypt-secrets" for å lage nye passord som overskriver de tidligere på Google Secret Manager.


# 🚀 Installasjon
### KSM er klar til bruk med en gang. Du trenger ikke installere eller laste ned noe. Bare følg instruksjonene nedenfor:

# ⚙️ Engangsoppsett av systemet
> **⚠️ VIKTIG:** Kjør disse kommandoene inne i din **KNAST-terminal**

### Steg 1: 🔐 Logg inn i Google Cloud
```bash
gcloud auth login --update-adc
```
**Sjekk om prosjekt er satt**
```bash
gcloud config get-value project
```
**Hvis prosjekt ikke er satt: (skriv inn Google Cloud prosjekt-ID hvor du ønsker å lagre krypterte passord)**
```bash
gcloud config set project <your-project-id>
```

### Steg 2: 🔒 Skriv inn og krypter databasepassord (DVH)

#### Krypter passord
```bash
ksm-encrypt-secrets
```

**Følg så instruksjonene i terminalen**

1. 🔑 Terminalen vil be deg om å **velge DVH-miljø og skrive inn databasepassord**, samt **opprette et hovedpassord** (et sikkert og lett å huske passord som du vil bruke daglig for å dekryptere databasepassordene dine.)
2. Terminalen vil be deg om å **velge eller skrive inn ditt foretrukne Google Cloud-prosjekt** hvor passordene skal lagres i Google Secret Manager. ⚠️ **Husk:** Bruk alltid **prosjekt-ID** i stedet for prosjektnavn.

> ⚠️ **INFO:** Hvis du glemmer hovedpassordet, kan du alltid lage nye passord med et nytt hovedpassord.


#### Sjekk om skriptet har opprettet passordet i ønsket GCP-prosjekt:
1. Gå til din Google Cloud Console
2. Gå til **Security >> Secret Manager**
3. Under **Secrets**-fanen vil du se en liste over passord som eies av deg eller ditt team
4. Velg ditt passord (med ditt **hostname** f.eks. a123456)
5. Under **Actions**, klikk på **3 vertikale prikker** og velg **View secret value** for å bekrefte passordet. Den samme JSON-strengen skal skrives ut i Knast-terminalen din.


# 🎯 Oppsett per prosjekt

### Steg 1: Klon ditt dbt-prosjekt / eller opprett nytt dbt-prosjekt

Du må muligens endre profilen din for å støtte standard Knast-oppsett. Sjekk ut [profiles.yml](https://github.com/navikt/dbt-i-nav/blob/main/profiles.yml) for å sette opp riktig format slik at miljøvariablene settes korrekt.

Følgende miljøvariabler settes opp automatisk:

* DBT_DB_TARGET: Dette er ditt nåværende miljø, kjør ``dvh-env`` for å sjekke ditt aktive miljø (U, R, P ...)
* DBT_ENV_SECRET_USER: Din NAV-ident. Knyttet til din Knast
* DBT_ENV_SECRET_PASS: Databasepassord, kryptert og hentet fra Google Secret Manager av KSM når det trengs
* DBT_DB_SCHEMA: Schema er knyttet til mappenavnet til git-rotmappen din.

### Steg 2: 🐍 Opprett / aktiver virtuelt miljø
```bash
uv venv && source .venv/bin/activate
```

### Steg 3: 📋 Installer avhengigheter (hvis det finnes noen)

**For requirements.txt:**
```bash
uv pip install -r requirements.txt
```

**For pyproject.toml:**
```bash
uv pip install -r pyproject.toml
```

### Steg 4:  ✅ Bekreft oppsett og dbt-versjon
```bash
repo-status  # Tester om alt er i orden
```
**Denne kommandoen tester:**
- ✅ Shell-integrasjon
- ✅ Hovedpassord-mellomlagring
- ✅ Nåværende GCP-bruker og prosjekt-ID
- ✅ Autentiseringsdetaljer (token + ADC)
- ✅ Anbefalt dbt-versjon

### Steg 5: ⚙️ Initialiser prosjektet
```bash
repo-init
```
**Hva repo-init gjør:**
- ✅ Plasserer .pth-fil i venv for automatisk lasting av Python
- ✅ Verifiserer at kryptering er tilgjengelig
- ✅ Rydder opp i gamle filer på en trygg måte

***
# ☀️ Daglig rutine (ved oppstart av arbeidsstasjon eller ved behov)
> **🔄 Hurtigstart:** Kjør disse kommandoene i begynnelsen av hver arbeidsøkt i prosjektet ditt

### Steg 1: 🔐 Aktiver virtuelt miljø (gå til ditt dbt-prosjekt i terminalen)
```bash
source .venv/bin/activate
```

### Steg 2: 🔐 Logg inn i GCP
```bash
gauth  # GCP-autentisering
```

### Steg 3: 🔑 Sett hovedpassord
```bash
mpass-set
```

### Steg 4: ✅ Bekreft oppsett (inne i prosjektet)
```bash
repo-status  # Tester om alt er i orden
```
**Denne kommandoen tester:**
- ✅ Shell-integrasjon
- ✅ Masterpassord cache
- ✅ Nåværende GCP-bruker og prosjekt-ID
- ✅ Autentiseringsdetaljer (token + ADC)
- ✅ Anbefalt dbt-versjon

## For å få hjelp til KSM i terminalen, kjør:
```bash
ksm-help
```

# 🎉 Du er nå klar til å jobbe med dbt-prosjektet ditt med DVH som kilde!
