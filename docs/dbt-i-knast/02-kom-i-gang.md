# Kom i gang med dbt i Knast
For å bruke dbt i Knast, man først trenger å opprette sin Knast.

## Opprett Knast
Gjør følgende:

1. I nettleseren, gå til (https://data.ansatt.nav.no/). Login med din Nav-ident hvis det er behov.
2. Velg "KNAST" overst til høyre. Se bilde.

![datamarkedsplassen homepage](/docs/images/01-dmp-home.png)

3. Velg `dbt-stable` fra dropdown som utviklingsmiljø. Se punkt 1 i bilde nedenfor.
4. Velg maskintype. Hvis usikker, gjerne start med minste type maskin. Se punkt 2 i bilde nedenfor.

![knast oppsett](/docs/images/02-knast-oppsett-1.png)

5. Trykk `Opprett min Knast` knapp. Se punkt 3 i bilde over.

!!! note
    Les mer om [oppsett av Knast for første gang.](https://datadoc.ansatt.nav.no/produkter/knast/)


## Starte Knast for første gang
Når du har trykket på `Opprett min Knast` og ventet i noen minutter får du muligheten til å starte Knasten din. Det tar et par minutter å starte Knasten. Når den er klar, trykk på `Åpne dbt-stable` for å åpne din knast i nettleseren din.
Se rød pil i følgende bilde:

![knast start](/docs/images/03-min-knast-start.png)

## Daglig Knast bruk
- Gå til (https://data.ansatt.nav.no/)
- Trykk på Knast oppe til høyre
- Trykk på `Start knast` knapp
- Trykk på `Åpne dbt-stable`

## Bli kjent med Min Knast side
#### Under `Oversikt` fane, finnes det info om status og config av din Knast. Se bilde:

![knast oversikt](/docs/images/04-min-knast-oversikt.png)

#### Under `Innstillinger` fane, finnes det mulighet å gjøre endring på din knast til følgende:
- Utviklingsmiljø: `Image` og `Maskintype`. Se følgende bilde:

![knast instillinger](/docs/images/05-min-knast-instillinger.png)

- Nav datakilder: Her kan man velge hvilken Nav datakilder vil aktivere åpning mot. Se bilde under:

![knast Nav datakilder](/docs/images/06-nav-datakilder.png)

- Internettåpninger: Her er det mulighet å legge Internet åpninger ved å trykke på `Legg til `. Legg inn info og trykk på `Lagre`. Se bildene:

![internett åpninger](/docs/images/07-01-internett-aapninger.png)

![internett åpninger URLer](/docs/images/07-02-internett-aapninger-legg-URL.png)

#### Under `Logger` fane, finnes det info om blokerte URL på din knast.

#### Under `Python` fane, finnes det info om hvordan installere Python pakker i Knast.


## Når du er klar til å utvikle i dbt

Du er klar for vanlig dbt-utvikling når dette stemmer:

- GitHub fungerer i Knast
- prosjektet åpner fint i editoren
- `dbt debug` går gjennom
- `dbt build` går gjennom eller feiler på en forståelig prosjektfeil

Da kan du gå videre med modeller, tester og dokumentasjon.

## dbt-avhengigheter (dbt_utils)

Hvis prosjektet bruker pakker via `packages.yml`, må du kunne kjøre:

```shell
dbt deps
```

For dette kan det være nødvendig å åpne relevante GitHub- og dbt Hub-URL-er under Internettåpninger i Knast. Dette gjelder særlig hvis prosjektet bruker pakker som `dbt_utils`.

Hvis `dbt deps` ikke fungerer i Knast, sjekk først om disse URL-ene er åpnet:

- `codeload.github.com/dbt-labs/dbt-utils/tar.gz/*`
- `hub.getdbt.com/api/v1/*`
- `github.com/dbt-labs/dbt-utils.git`

Dette er mest relevant når et prosjekt faktisk bruker pakker. Hvis du ikke har `packages.yml`, trenger du ikke bruke tid på dette.

Eksempel på `packages.yml`:

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.3.3
```