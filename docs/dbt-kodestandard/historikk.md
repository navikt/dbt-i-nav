# Historikk

Historikk er en grunnleggende del av dataprodukter. Uten tydelige prinsipper for historikk får vi produkter som ser riktige ut hver for seg, men som oppfører seg ulikt når de brukes sammen.

Målet med denne siden er å beskrive prinsippene for historikk. Selve navngivningen av historikkfelter er beskrevet i [navnestandard.md](navnestandard.md).

## Formål

Historikk skal gjøre det mulig å:

- forstå hva som var gjeldende på et gitt tidspunkt
- gjenskape tidligere tilstander i et dataprodukt
- koble produkter på tvers uten at tidslogikken bryter sammen
- skille mellom når noe gjaldt i kilden og når det ble observert i dataproduktet

## Definisjoner

- Funksjonell dato eller tid: dato- og tidspunktfelter definert hos kilden, som kan settes eller endres manuelt av brukere.
- Tekniske tidspunkt hos kilde: tidsstempler i kildesystemet som settes automatisk og ikke kan endres manuelt.
- Tekniske dataproduktstidspunkt: datoer eller tidspunkt som settes i dataproduktet, for eksempel når en rad ble lastet eller oppdatert.

## Hovedprinsipp

Historikk i dataproduktet skal beskrive perioden da raden eksisterte og så slik ut i kilden, ikke bare når løsningen oppdaget endringen.

Det betyr:

- Gyldighetsintervall skal fortrinnsvis baseres på informasjon fra kilden.
- Lastetidspunkt og oppdatertidspunkt i dataproduktet skal ikke forveksles med funksjonell eller teknisk gyldighet i kilden.
- Hvis kilden ikke har gode nok tidspunkter, må dataproduktet etablere en konsistent erstatning og være tydelig på det.

## Hva gyldighetsintervallet betyr

Gyldighetsintervallet skal gjenspeile den perioden raden var riktig og gyldig i kilden.

Dette gjelder uavhengig av:

- når data ble lastet inn i dataproduktet
- om løsningen kjører én gang per dag eller oftere
- om endringen ble oppdaget sent

Hvis vi blander sammen kildegyldighet og dataprodukttid, blir historikken vanskelig å bruke på tvers av produkter.

## Valg av oppløsning

Historikk skal føres med den laveste oppløsningen som faktisk trengs, men ikke grovere enn det forretningsbehovet krever.

### Døgn

Bruk døgnoppløsning når det er tilstrekkelig å vite hvilken dag en rad ble gyldig eller utgikk.

Dette passer typisk for:

- kodeverk
- mange dimensjoner
- produkter der flere hendelser samme dag ikke trenger å skilles

### Sekund

Bruk sekundoppløsning når flere hendelser kan skje samme dag og rekkefølgen mellom dem er viktig.

Dette passer typisk for:

- hendelsesnære data
- statusendringer som kan skje flere ganger samme dag
- produkter der samme nøkkel kan få flere gyldige versjoner i løpet av et døgn

### Timestamp

Bruk timestamp når kilden faktisk leverer hendelser innenfor samme sekund, eller når sekundnivå ikke er nok til å bevare rekkefølge.

Dette skal ikke brukes som standard, men når behovet er reelt.

## Lukkede og halvåpne intervaller

Valg av intervallmodell skal være bevisst og konsekvent.

- Døgnoppløsning føres normalt som lukkede intervaller.
- Sekund- og timestampoppløsning føres normalt som halvåpne intervaller.

Det viktigste er ikke hvilken modell som velges, men at:

- den er konsistent innenfor produktet
- den er tydelig kommunisert
- den ikke lager hull eller overlapp uten at det er tilsiktet

## Siste rad

Den siste gjeldende raden skal ha en tydelig åpen slutt.

Som hovedregel bruker vi en maksimumsdato eller et maksimumstidspunkt for siste rad, slik at gjeldende versjon kan leses på samme måte som historiske versjoner.

## Kilde først, dataprodukt etterpå

Når både kildetid og dataprodukttid finnes, skal de holdes konseptuelt fra hverandre.

Kildetid svarer på:

- Når gjaldt dette i virkeligheten eller i kildesystemet?

Dataprodukttid svarer på:

- Når ble dette lastet eller oppdatert hos oss?

Begge kan være nyttige, men de dekker ulike behov og må ikke blandes.

## Ukjent start på historikk

For kodeverk og dimensjoner kan det være riktig å bruke en kunstig tidlig startdato når den reelle starten ikke er kjent.

Hensikten er å unngå at eldre data mister kobling til en dimensjon eller kodeverksrad bare fordi historikken ble etablert sent.

Dette skal brukes bevisst, ikke som en generell snarvei for mangelfulle data.

## Endringer gjort direkte i dataproduktet

Hvis rader patches eller oppdateres direkte i dataproduktet, vil tekniske dataproduktfelter som oppdatertid normalt endres til nåværende tidspunkt.

Det skal ikke endre forståelsen av hva raden betydde i kilden, bare når dataproduktet sist ble endret.

## Krav til konsistens

Innenfor ett dataprodukt skal historikk følge ett tydelig mønster.

Det betyr:

- samme type gyldighet skal uttrykkes likt i alle modeller
- samme oppløsning skal brukes for samme type behov
- samme begreper skal brukes konsekvent på tvers av dimensjoner, fakta og OBT-er

Hvis et produkt må avvike, skal det være et bevisst unntak og dokumenteres.

## Praktisk tommelfingerregel

- Bruk kildens gyldighet når den finnes og er pålitelig.
- Bruk døgnoppløsning som standard når det er godt nok.
- Gå til sekund eller timestamp bare når behovet krever det.
- Hold kildetid og dataprodukttid adskilt.
- La navngivningen gjøre det tydelig hvilken type historikk modellen bruker.
