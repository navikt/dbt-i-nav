
{% docs __overview__ %}



# CV - komponenten

## Formål
Overordnet beskrivelse av formål med løsningen

### Komponentbeskrivelse
- Formål: 
- Prinsipper:
- Kilde(r):
- Brukere:
- Noe annet:

## Struktur på repo
Lenke til dokumentasjon på confluence

Vi har følgende mapper:
- db (medfølgende readme)
  - install (her ligger ddl filer per tabell/view. Også dcl-filer som gir grants)
  - patch (hvert script har jira-kode som prefiks og kort forklaring/tabellnavn). Når man endrer en tabell her må man også endre den i install-filen)
  - utils (kanskje, hvis man trenger det)
- dbt - dbt prosjektet. dette er stien der man kjører dbt kommandoer.


## Overordnet design
### Dataflyt-diagram

Dataflyten finnes ved å klikke på det blå ikonet nederst til høyre på siden 

| # | DAG | task | kilde | mål | kommentar |
|---|-----|------|-------|-----|-----------|
|   |     |      |       |     |           |
|   |     |      |       |     |           |
|   |     |      |       |     |           |

## Databasebeskrivelse

En oversikt over de viktigste tabellene

| Tabell/Views      | Beskrivelse |
| ----------- | ----------- |
| tabell1      | besk       |
| tabell2    | besk        |

### Databasescript
Referanser til hvor databasescriptene befinner seg

## Drift
### Workflows og kjøretidspunkt
Inneholder informasjon om viktige punkter for kjøretider

## Tilgangsstyring
Er det noen spesielle rettigheter som kreves for denne komponenten?

## Overvåking og datakvalitet

### Datakvalitet
Det kjøres datakvalitetsmålinger for disse tabellene

### Overvåking
Følgende Sitescope-monitorer kjøres for denne komponenten.

## Sikkerhet og personvern
Inneholder detaljer rundt f.eks tilgang

Det er ikke utarbeidet PVK for denne komponenten.

Håndtering av kode 6 og 7: Under arbeid

## Backlog
Lenke til jira-oversikt?

---

# dbt docs - brukerguide 

### Navigasjon
Du kan bruke navigasjonsfanene `Project` og `Database` på venstre side av vinduet for å utforske modellene i komponenten.

#### Prosjektfane
`Prosjekt`-fanen speiler katalogstrukturen til dbt-prosjektet ditt. I denne fanen kan du se alle
modeller definert i dbt-prosjektet ditt, samt modeller importert fra dbt-pakker.

#### Database-fanen
Fanen `Database` viser også modellene dine, men i et format som ser mer ut som en databaseutforsker. Denne utsikten
viser relasjoner (tabeller og visninger) gruppert i databaseskjemaer. Merk at `ephemeral` modeller _ikke_ vises
i dette grensesnittet, da de ikke finnes i databasen.

### Grafutforskning
Du kan klikke på det blå ikonet nederst til høyre på siden for å se lineage til modellene dine.

På modellsidene vil du se de nærmeste foreldrene og barna til modellen du utforsker. Ved å klikke på `Expand`.
knappen øverst til høyre i denne avstamningsruten, vil du kunne se alle modellene som brukes til å bygge,
eller er bygget fra, modellen du utforsker.

Når den er utvidet, vil du kunne bruke `--select` og `--exclude` modellvalgsyntaks for å filtrere
modeller i grafen. For mer informasjon om modellvalg, sjekk ut [dbt docs](https://docs.getdbt.com/docs/model-selection-syntax).

Merk at du også kan høyreklikke på modeller for å filtrere og utforske grafen interaktivt.


### Mer info

- [Hva er dbt](https://docs.getdbt.com/docs/introduction)


---

{% enddocs %}
