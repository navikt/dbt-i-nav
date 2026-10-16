# Feilsøking

Hvis noe ikke fungerer, sjekk disse tingene først i denne rekkefølgen:

- er riktig miljø valgt med `dvh`
- er riktig Python-miljø aktivt
- bruker `profiles.yml` miljøvariablene riktig
- finnes `~/KSM/env-config.env` og ser den riktig ut

Nyttige kommandoer:

```bash
which python
echo $DVH_ENVIRONMENT
tail -f ~/KSM/logs/usage.log
```

## Typiske feilbilder:

### `dbt` finner ikke database: 
feil DVH miljø eller feil vertstilkobling

### credentials mangler: 
miljøet er ikke riktig satt opp

### `.pth`-fil ikke aktiv: 
feil Python-miljø er i bruk

### TNS-feil: 
nødvendig miljøinformasjon mangler eller er feil
