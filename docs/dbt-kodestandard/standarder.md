
# Formål

I Nav har vi **mange team**, **enda flere produkter** og dermed **kryssavhengigheter** som gjør datalandskapet komplekst.

Begreper som «god praksis» og «autonomi» blir ofte tolket som «dette kan du gjøre hvis du vil».

Her må vi være tydeligere. Denne seksjonen beskriver standarder som **må følges** for at data mesh-arkitektur med dataprodukter skal fungere på tvers av domener i dbt. Standardene finnes for å sikre interoperabilitet, tydelig eierskap, kvalitet og endringsevne.

Vi innfører derfor standardene i fase 1 først. Andre temaer er ikke etablert som god praksis ennå, men kan beskrives senere som anbefalinger når vi har mer erfaring og en tydeligere felles retning.

Manglende standarder fører til smerter i det daglige:

- **Team divergerer** ⟶ Vanskelig å kjenne seg igjen når man bytter team.
- **Ulike SCD-strategier** ⟶ Historikk i produktene oppfører seg forskjellig og det blir vanskelig å joine produkter på tvers.
- **Ulike grain-antagelser** ⟶ Koblinger på tvers gir mindre mening enn man tror fordi det ikke er tydelig hva en rad i tabellen skal bety
- **Uforenlige modeller** ⟶ Ulik og kreativ modellering øker kognitiv last og krever kanskje mappingtabeller for å koble rett.

## En tommelfingerregel

- Alt som påvirker kontrakter mellom domener = kodestandarder som alle må følge.
- Alt som primært påvirker intern implementasjon i ett domene = temaer vi eventuelt kan beskrive som god praksis senere.

## Faseplan for datamesh med mange domener

Målet er å starte med et lite sett felles standarder. Når dette sitter, kan vi vurdere å beskrive flere temaer som god praksis.

### Fase 1: Standarder vi innfører nå

Dette er det viktigste minimumet for at datadomener skal kunne publisere stabile dataprodukter med tydelig kontrakt:

- [Grain](grain.md)
- [Historikk](historikk.md)
- [Navnestandard](navnestandard.md)
- [Teststrategi](teststrategi.md)
- [Dokumentasjonsstandard](dokumentasjonsstandard.md)
- [Modellkontrakter](modellkontrakter.md)

### Fase 2: Neste kandidater for standardisering

Dette er temaer som kan bli standarder senere hvis behovet blir tydelig nok:

- [Lagdeling](lagdeling.md)
- [Mappe- og prosjektstruktur](struktur.md)
- [Konvensjoner](konvensjoner.md)
- [JOIN-strategi](JOINstrategi.md)
- [Avhengigheter](avhengigheter.md)
- [Feilhåndtering](feilhåndtering.md)
- [Versjonskontroll](versjonskontroll.md)
- [CI](CI.md)

### Fase 3: Temaer for senere god praksis

Dette er temaer som kan beskrives som god praksis når vi har mer modenhet og flere felles erfaringer:

- [SQLFluff](SQLFluff.md)
- [Incremental og Volum](incrementalOgVolum.md)
- [Ytelse](ytelse.md)

Typiske tegn på at slike anbefalinger blir viktige:

- Flere oppstrøms eller nedstrøms avhengigheter
- Merkbar økning i kjøretid eller kostnad
- Hyppige endringer i produktets skjema eller logikk

### Fase 4: Avanserte temaer

Dette er temaer som bare blir relevante for enkelte domener, og som eventuelt kan beskrives som god praksis senere:

- [One Big Table](OBT.md)
- [Kommentarer](kommentarer.md)
- [Eksempler](eksempler.md)

Typiske utløsere:

- Komplekse analytiske use case med tunge spørringer
- Høy turnover i team eller behov for rask onboarding
- Behov for standardiserte referanseimplementasjoner på tvers av mange team

## Status per side

| Side | Status nå | Neste steg |
|---|---|---|
| Oversikt og formål | Standard | Fase 1 |
| Lagdeling | Ikke standardisert ennå | Vurderes i fase 2 |
| Grain | Standard | Fase 1 |
| Navnestandard | Standard | Fase 1 |
| Mappe- og prosjektstruktur | Ikke standardisert ennå | Vurderes i fase 2 |
| Konvensjoner | Ikke standardisert ennå | Vurderes i fase 2 |
| JOIN-strategi | Ikke standardisert ennå | Vurderes i fase 2 |
| Teststrategi | Standard | Fase 1 |
| Dokumentasjonsstandard | Standard | Fase 1 |
| Avhengigheter | Ikke standardisert ennå | Vurderes i fase 2 |
| Modellkontrakter | Standard | Fase 1 |
| Feilhåndtering | Ikke standardisert ennå | Vurderes i fase 2 |
| Versjonskontroll | Ikke standardisert ennå | Vurderes i fase 2 |
| CI | Ikke standardisert ennå | Vurderes i fase 2 |
| SQLFluff | Ikke standardisert ennå | Kan bli god praksis i fase 3 |
| Historikk | Standard | Fase 1 |
| Incremental og Volum | Ikke standardisert ennå | Kan bli god praksis i fase 3 |
| Ytelse | Ikke standardisert ennå | Kan bli god praksis i fase 3 |
| One Big Table | Ikke standardisert ennå | Kan bli god praksis i fase 4 |
| Kommentarer | Ikke standardisert ennå | Kan bli god praksis i fase 4 |
| Eksempler | Ikke standardisert ennå | Kan bli god praksis i fase 4 |
