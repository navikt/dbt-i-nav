# Fargestandard i dbt Docs

Denne siden beskriver en felles fargepalett for noder i dbt Docs. Fargene viser hvilken type modell en node representerer i [lineage-grafen](https://www.getdbt.com/blog/getting-started-with-data-lineage), slik at det blir lettere å lese både egne og andres prosjekter.

!!! warning "Standard med kjente tilgjengelighetsbegrensninger"

    Paletten gir tilstrekkelig kontrast for hvit tekst på modellnodene, men en kjent teknisk begrensning gir liten kontrast mellom nodene og den mørkeblå bakgrunnen. Farger skal supplere modellnavn og dokumentasjon, ikke være eneste måte å identifisere modelltypen på.

## Formål

En felles fargestandard skal gjøre det enklere å:

- finne fram i komplekse dataflyter
- kjenne igjen modelltyper på tvers av team
- vedlikeholde prosjekter med en felles visuell referanse
- lese grafen uten å være avhengig av å skille fargene fra hverandre

## Fargestandard

Fargeprøvene viser hvit tekst på nodefargen. Kontrasttallene står under [fargevalg og kontrast](#fargevalg-og-kontrast).

| Modelltype | Visning | Fargekode og Aksel-referanse |
| --- | --- | --- |
| Kildetabeller (fast) | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#60b825;color:#ffffff">src_</span> | `#60b825`|
| Staging-modeller | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#007629;color:#ffffff">stg_</span> | `#007629`<br>Success700 |
| Intermediate-modeller | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#995139;color:#ffffff">int_</span> | `#995139`<br>BrandBeige700 |
| Faktamodeller | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#7c4abf;color:#ffffff">fak_</span> | `#7c4abf`<br>MetaPurple700 |
| Dimensjonsmodeller | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#905bd3;color:#ffffff">dim_</span> | `#905bd3`<br>MetaPurple600 |
| Brede aggregater | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#0063c1;color:#ffffff">obt_</span> | `#0063c1`<br>Accent700 |
| Smale aggregater | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#457c9d;color:#ffffff">agg_</span> | `#457c9d`<br>BrandBlue600 |
| Øvrige modeller | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#5d6573;color:#ffffff">mdl_</span> | `#5d6573`<br>Neutral700 |
| Snapshots | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#ca5000;color:#ffffff">snap_</span> | `#ca5000`<br>Warning600 |
| Tester (kun referanse) | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#e22948;color:#ffffff">test_</span> | `#e22948`<br>Danger600 |
| Exposures (kun referanse) | <span style="display:inline-block;min-width:5rem;padding:0.1rem 0.4rem;background-color:#a93d70;color:#ffffff">exp_</span> | `#a93d70`<br>BrandMagenta700 |

Grønn markerer staging, rødbrun markerer intermediate, og ulike lillatoner markerer fakta og dimensjoner. Blåtonene samler aggregater i en fargefamilie. Grå brukes for modeller utenfor disse kategoriene.

Fargene for kilder, tester og exposures kan ikke konfigureres med `docs.node_color`. Kildetabellene har en fast farge, mens fargene for tester og exposures bare er referanser.

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
      dimensjoner:
        +docs:
          node_color: "#905bd3"
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


## Tekniske rammer

<details markdown="1">
<summary>Vis tekniske rammer</summary>

Standarden tar utgangspunkt i dbt Docs-visningen med disse faste egenskapene:

| Egenskap | Verdi |
| --- | --- |
| Bakgrunn i grafen (canvas) | `#275d77` |
| Tekst på nodene | Hvit, `#ffffff` |
| Tekststørrelse og nodeform | Kan ikke endres gjennom `docs.node_color` |
| Kildetabeller | Grønn, `#60b825`, i visningen som utkastet bygger på |

Ifølge [dbts dokumentasjon om nodefarger](https://docs.getdbt.com/reference/resource-configs/docs#custom-node-colors) støttes `docs.node_color` for modeller, seeds, snapshots og analyser. Kilder, tester og exposures støttes ikke. Fargene for tester og exposures i tabellen er derfor bare referansefarger i utkastet, ikke innstillinger som kan tas i bruk med denne konfigurasjonen.

Dette gjelder dbt Docs, ikke Catalog/Explorer. Kontroller den faktiske visningen når dbt eller publiseringsløsningen oppgraderes.

</details>

## Fargevalg og kontrast

<details markdown="1">
<summary>Vis fargepalett og kontrastvurderinger</summary>

Utkastet bygger på farger fra [Aksel](https://aksel.nav.no/), fra globale fargenivåer 600 og 700. Se også [Aksels dokumentasjon om designtokens](https://aksel.nav.no/grunnleggende/styling/design-tokens).

Hex-kodene i denne standarden er verdiene som skal brukes i dbt. Fargereferansene i tabellen er navnene fra utkastet, ikke dbt-konfigurasjon eller en garanti for at verdiene er identiske i alle Aksel-versjoner. Eksempelvis avviker utkastets `BrandBeige700` (`#995139`) fra dagens `--ax-bg-brand-beige-strong-hover` (`#915541`).

### Aksels fargepalett på nivå 600 og 700

Tabellen viser globale farger for lyst tema fra [Aksels fargetokener](https://github.com/navikt/aksel/blob/main/%40navikt/core/tokens/src/tokens/colors/global.tokens.ts). Info og Brand Blue har de samme verdiene.

| Fargefamilie | Nivå 600 | Nivå 700 |
| --- | --- | --- |
| Neutral | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#6f7785;color:#ffffff">600</span> `#6f7785` | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#5d6573;color:#ffffff">700</span> `#5d6573` |
| Accent | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#2176d4;color:#ffffff">600</span> `#2176d4` | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#0063c1;color:#ffffff">700</span> `#0063c1` |
| Success | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#00893c;color:#ffffff">600</span> `#00893c` | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#007629;color:#ffffff">700</span> `#007629` |
| Warning | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#ca5000;color:#ffffff">600</span> `#ca5000` | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#ac4400;color:#ffffff">700</span> `#ac4400` |
| Danger | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#e22948;color:#ffffff">600</span> `#e22948` | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#cb0035;color:#ffffff">700</span> `#cb0035` |
| Info | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#457c9d;color:#ffffff">600</span> `#457c9d` | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#246b91;color:#ffffff">700</span> `#246b91` |
| Brand Magenta | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#b65681;color:#ffffff">600</span> `#b65681` | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#a93d70;color:#ffffff">700</span> `#a93d70` |
| Brand Beige | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#ad634a;color:#ffffff">600</span> `#ad634a` | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#915541;color:#ffffff">700</span> `#915541` |
| Brand Blue | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#457c9d;color:#ffffff">600</span> `#457c9d` | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#246b91;color:#ffffff">700</span> `#246b91` |
| Meta Purple | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#905bd3;color:#ffffff">600</span> `#905bd3` | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#7c4abf;color:#ffffff">700</span> `#7c4abf` |
| Meta Lime | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#757c00;color:#ffffff">600</span> `#757c00` | <span style="display:inline-block;min-width:3rem;padding:0.1rem 0.4rem;background-color:#646900;color:#ffffff">700</span> `#646900` |

### Krav til tekst og grafikk

[WCAG 2.2, kriterium 1.4.3](https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html) krever minst 4,5:1 i kontrast for vanlig tekst. Alle de foreslåtte fargene for modeller og snapshots oppfyller dette mot hvitt. Kildetabellenes faste grønnfarge gjør det ikke.

[Kriterium 1.4.11](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html) krever minst 3:1 for grafiske deler som er nødvendige for å forstå innholdet. Det betyr ikke at enhver nodeflate automatisk må ha 3:1 mot bakgrunnen dersom informasjonen også formidles med lesbar tekst. Nodegrenser, forbindelser og tilstander som er nødvendige for å forstå grafen, må likevel vurderes i den faktiske visningen.

Kontrasttallene er beregnet fra hex-kodene etter WCAGs metode for relativ luminans og avrundet til to desimaler. Vurdering av krav skal gjøres med uavrundede verdier.

| Modelltype | Mot hvit tekst | Mot canvas |
| --- | --- | --- |
| Kildetabeller (fast) | 2,51:1 | 2,87:1 |
| Staging-modeller | 5,80:1 | 1,24:1 |
| Intermediate-modeller | 5,85:1 | 1,23:1 |
| Faktamodeller | 5,85:1 | 1,23:1 |
| Dimensjonsmodeller | 4,54:1 | 1,58:1 |
| Brede aggregater | 5,91:1 | 1,22:1 |
| Smale aggregater | 4,54:1 | 1,58:1 |
| Øvrige modeller | 5,88:1 | 1,22:1 |
| Snapshots | 4,51:1 | 1,60:1 |
| Tester (kun referanse) | 4,52:1 | 1,59:1 |
| Exposures (kun referanse) | 5,85:1 | 1,23:1 |

### Begrensningen ved den mørkeblå bakgrunnen

Hvit tekst har omtrent 7,20:1 i kontrast mot bakgrunnen `#275d77`. En node som er lysere enn denne bakgrunnen og samtidig har minst 4,5:1 mot hvitt, kan høyst få omtrent 1,60:1 mot bakgrunnen. Fargevalg alene kan derfor ikke gi både lesbar hvit tekst og 3:1 mellom en lysere nodeflate og denne bakgrunnen.

Fargene gir tilstrekkelig tekstkontrast, men lav kontrast mellom nodeflaten og bakgrunnen. Fargene alene sikrer ikke universell utforming.

</details>

## Tidligere fargestruktur

<details markdown="1">
<summary>Vis tidligere fargestruktur</summary>

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

</details>