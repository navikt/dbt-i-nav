# Fargestandard for dbt Docs

Denne siden beskriver en felles fargepalett for noder i dbt Docs. Fargene viser hvilken type modell en node representerer i [lineage-grafen](https://www.getdbt.com/blog/getting-started-with-data-lineage), slik at det blir lettere å lese både egne og andres prosjekter.

!!! warning "Standard med kjente tilgjengelighetsbegrensninger"

    Paletten gir tilstrekkelig kontrast for hvit tekst på modellnodene, men en kjent teknisk begrensning gir liten kontrast mellom nodene og den mørkeblå bakgrunnen. Farger skal supplere modellnavn og dokumentasjon, ikke være eneste måte å identifisere modelltypen på.

## Formål

En felles fargestandard skal gjøre det enklere å:

- finne fram i komplekse dataflyter
- kjenne igjen modelltyper på tvers av team
- vedlikeholde prosjekter med en felles visuell referanse
- lese grafen uten å være avhengig av å skille fargene fra hverandre

## Konfigurer fargene i dbt

Sett fargene per mappe i `dbt_project.yml`, slik at nye modeller arver riktig farge. Tilpass mappenavnene til prosjektstrukturen. dbt velger ikke farge automatisk ut fra prefikset i modellnavnet.

```yaml
models:
  mitt_dbt_prosjekt:
    +docs:
      node_color: "#5d6573"
    staging:
      +docs:
        node_color: "#007629"
    intermediate:
      +docs:
        node_color: "#995139"
    marts:
      fakta:
        +docs:
          node_color: "#7c4abf"
      brede_aggregater:
        +docs:
          node_color: "#0063c1"
      smale_aggregater:
        +docs:
          node_color: "#457c9d"

snapshots:
  mitt_dbt_prosjekt:
    +docs:
      node_color: "#ca5000"
```

Bruk anførselstegn rundt hex-kodene. Uten anførselstegn tolker YAML `#` som starten på en kommentar.

En enkeltmodell kan overstyre mappefargen i modellens SQL-fil:

```sql
{{ config(docs={"node_color": "#7c4abf"}) }}
```

Innstillinger i SQL-filen overstyrer modellens YAML-konfigurasjon, som igjen overstyrer `dbt_project.yml`. Unngå lokale overstyringer når mappekonfigurasjonen er tilstrekkelig.

Generer dokumentasjonen på nytt for å ta i bruk fargene:

```shell
dbt docs generate
dbt docs serve
```

## Fargestandard

Fargeprøvene viser hvit tekst på nodefargen. Kontrasttallene er beregnet fra de oppgitte hex-kodene etter WCAGs metode for relativ luminans og er avrundet til to desimaler. Vurdering av krav skal gjøres med uavrundede verdier.

| Modelltype | Visning | Fargekode (hex) | Fargereferanse i Aksel | Hvit tekst | Mot canvas | Vurdering
| --- | --- | --- | --- | --- | --- | --- |
| Kildetabeller (fast) | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#60b825;color:#ffffff">src_</span> | `#60b825` | Fast i dbt Docs-visningen | 2,51:1 | 2,87:1 | Tilfredsstiller ikke krav, men er fastlåst i dbt Docs-visningen |
| Staging-modeller | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#007629;color:#ffffff">stg_</span> | `#007629` | Success700 | 5,80:1 | 1,24:1 | En mørk grønntone. Sikrer lovlig kontrast for den hvite teksten.
| Intermediate-modeller | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#995139;color:#ffffff">int_</span> | `#995139` | BrandBeige700 | 5,85:1 | 1,23:1 | En dempet, rødbrun tone. Skiller seg klart fra grønn, selv ved rød-grønn fargeblindhet.
| Faktamodeller | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#7c4abf;color:#ffffff">fak_</span> | `#7c4abf` | MetaPurple700 | 5,85:1 | 1,23:1 | Lilla bevarer kontrast og er lett gjenkjennelig på tvers av alle typer fargeblindhet.
| Brede aggregater | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#0063c1;color:#ffffff">obt_</span> | `#0063c1` | Accent700 | 5,91:1 | 1,22:1 | En dyp, klar blå. Skiller seg kraftig fra både lilla og rødbrun.
| Smale aggregater | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#457c9d;color:#ffffff">agg_</span> | `#457c9d` | BrandBlue600 | 4,54:1 | 1,58:1 | Middels lys, klar blåtone. Viser at den tilhører aggregat-familien, men skiller seg fra de brede.
| Øvrige modeller | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#5d6573;color:#ffffff">mdl_</span> | `#5d6573` | Neutral700 | 5,88:1 | 1,22:1 | Nøytral grå for modeller som ikke passer i hovedkategoriene.
| Snapshots | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#ca5000;color:#ffffff">snap_</span> | `#ca5000` | Warning600 | 4,51:1 | 1,60:1 | En frisk, klar oransje som tåler hvit tekst.
| Tester (kun referanse) | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#e22948;color:#ffffff">test_</span> | `#e22948` | Danger600 | 4,52:1 | 1,59:1 | Ren rød er den universelle og gjenkjennelige fargen for feil og tester.
| Exposures (kun referanse) | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#a93d70;color:#ffffff">exp_</span> | `#a93d70` | BrandMagenta700 | 5,85:1 | 1,23:1 | Rosa, dekker behovet for eksponeringer ut av dbt.

Grønn markerer staging, rødbrun markerer intermediate, og lilla markerer fakta. Blåtonene samler aggregater i en fargefamilie. Grå brukes for modeller utenfor disse kategoriene.

## Tekniske rammer

Standarden tar utgangspunkt i dbt Docs-visningen med disse faste egenskapene:

| Egenskap | Verdi |
| --- | --- |
| Bakgrunn i grafen (canvas) | `#275d77` |
| Tekst på nodene | Hvit, `#ffffff` |
| Tekststørrelse og nodeform | Kan ikke endres gjennom `docs.node_color` |
| Kildetabeller | Grønn, `#60b825`, i visningen som utkastet bygger på |

Ifølge [dbts dokumentasjon om nodefarger](https://docs.getdbt.com/reference/resource-configs/docs#custom-node-colors) støttes `docs.node_color` for modeller, seeds, snapshots og analyser. Kilder, tester og exposures støttes ikke. Fargene for tester og exposures nedenfor er derfor bare referansefarger i utkastet, ikke innstillinger som kan tas i bruk med denne konfigurasjonen.

Dette gjelder dbt Docs, ikke Catalog/Explorer. Kontroller den faktiske visningen når dbt eller publiseringsløsningen oppgraderes.

## Fargevalg og kontrast

Utkastet bygger på farger fra [Aksel](https://aksel.nav.no/) og referanser til globale fargenivåer 600 og 700. Se også [Aksels dokumentasjon om designtokens](https://aksel.nav.no/grunnleggende/styling/design-tokens).

Hex-kodene i denne standarden er verdiene som skal brukes i dbt. Fargereferansene i tabellen er navnene fra utkastet, ikke dbt-konfigurasjon eller en garanti for at verdiene er identiske i alle Aksel-versjoner. Eksempelvis avviker utkastets `BrandBeige700` (`#995139`) fra dagens `--ax-bg-brand-beige-strong-hover` (`#915541`).

### Krav til tekst og grafikk

[WCAG 2.2, kriterium 1.4.3](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html) krever minst 4,5:1 i kontrast for vanlig tekst. Alle de foreslåtte fargene for modeller og snapshots oppfyller dette mot hvitt. Kildetabellenes faste grønnfarge gjør det ikke.

[Kriterium 1.4.11](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html) krever minst 3:1 for grafiske deler som er nødvendige for å forstå innholdet. Det betyr ikke at enhver nodeflate automatisk må ha 3:1 mot bakgrunnen dersom informasjonen også formidles med lesbar tekst. Nodegrenser, forbindelser og tilstander som er nødvendige for å forstå grafen, må likevel vurderes i den faktiske visningen.

### Begrensningen ved den mørkeblå bakgrunnen

Hvit tekst har omtrent 7,20:1 i kontrast mot bakgrunnen `#275d77`. En node som er lysere enn denne bakgrunnen og samtidig har minst 4,5:1 mot hvitt, kan høyst få omtrent 1,60:1 mot bakgrunnen. Fargevalg alene kan derfor ikke gi både lesbar hvit tekst og 3:1 mellom en lysere nodeflate og denne bakgrunnen.

Nivå 600 og 700 løser dermed tekstkontrasten for de oppgitte fargene, men ikke kontrasten mellom nodeflaten og bakgrunnen. Påstanden om at disse nivåene alene sikrer universell utforming, kan ikke brukes.



## Tidligere fargestruktur

Den tidligere paletten fases ut etter hvert som prosjektene tar i bruk den nye. Kategoriene er ikke identiske i de to palettene; velg ny farge ut fra modellens rolle, ikke bare den gamle fargen.

| Modelltype | Visning | Tidligere hex-kode |
| --- | --- | --- |
| Kildetabeller | <span aria-hidden="true" style="display:inline-block;width:5rem;height:1.5rem;background-color:#60b825"></span> | `#60b825` |
| Staging-modeller | <span aria-hidden="true" style="display:inline-block;width:5rem;height:1.5rem;background-color:#33aa5f"></span> | `#33aa5f` |
| Intermediate-modeller | <span aria-hidden="true" style="display:inline-block;width:5rem;height:1.5rem;background-color:#d57448"></span> | `#d57448` |
| Daglige faktamodeller | <span aria-hidden="true" style="display:inline-block;width:5rem;height:1.5rem;background-color:#56b4e9"></span> | `#56b4e9` |
| Detaljerte faktamodeller | <span aria-hidden="true" style="display:inline-block;width:5rem;height:1.5rem;background-color:#8a2be2"></span> | `#8a2be2` |
| Brede aggregater | <span aria-hidden="true" style="display:inline-block;width:5rem;height:1.5rem;background-color:#3386e0"></span> | `#3386e0` |
| Åpne aggregater | <span aria-hidden="true" style="display:inline-block;width:5rem;height:1.5rem;background-color:#368da8"></span> | `#368da8` |
| Grensesnittmodeller | <span aria-hidden="true" style="display:inline-block;width:5rem;height:1.5rem;background-color:#4c8dc1"></span> | `#4c8dc1` |
| Tableau-aggregater | <span aria-hidden="true" style="display:inline-block;width:5rem;height:1.5rem;background-color:#1c427e"></span> | `#1c427e` |
| Snapshots | <span aria-hidden="true" style="display:inline-block;width:5rem;height:1.5rem;background-color:#e6b400"></span> | `#e6b400` |
| Tester | <span aria-hidden="true" style="display:inline-block;width:5rem;height:1.5rem;background-color:#cc79a7"></span> | `#cc79a7` |