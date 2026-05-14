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

For dataprodukter som brukes til rapportering og statistikk, må dette balanseres mot behovet for stabile tall over tid.

## Hva gyldighetsintervallet betyr

Gyldighetsintervallet skal gjenspeile den perioden raden var riktig og gyldig i kilden.

Dette gjelder uavhengig av:

- når data ble lastet inn i dataproduktet
- om løsningen kjører én gang per dag eller oftere
- om endringen ble oppdaget sent

Hvis vi blander sammen kildegyldighet og dataprodukttid, blir historikken vanskelig å bruke på tvers av produkter.

## Etterregistreringer og stabile tall

En viktig nyanse er etterregistreringer: en rad kan dukke opp i morgen, men ha en kildegyldighet som starter langt tilbake i tid.

Hvis dataproduktet da ukritisk oppdaterer gyldighetsintervall tilbake i tid, kan tall i rapporter og statistikk endre seg for perioder som allerede er publisert eller brukt. Det gir ustabile tall og svekker tilliten til produktet.

For eksponerte dataprodukter som brukes til statistikk og rapportering gjelder derfor følgende hovedregel:

- Vi skal som utgangspunkt ikke omskrive publisert historie tilbake i tid bare fordi en etterregistrering blir kjent senere.

Det betyr i praksis at vi må holde to ting fra hverandre:

- Hva som var gyldig i kilden.
- Når dataproduktet faktisk fikk kjennskap til det.

Begge kan være sanne samtidig, men de dekker ulike behov.

## Anbefalt håndtering

Når etterregistreringer forekommer, bør dataproduktet som minimum bevare informasjon om observasjonstid i tillegg til kildegyldighet.

Da kan vi:

- bevare kildens historikk for analyseformål
- forklare når opplysningen faktisk ble kjent i dataproduktet
- unngå at standard rapportering omskrives bakover i tid uten at det er et bevisst valg

Som hovedregel bør eksponerte rapporteringsprodukter styres etter tidspunktet informasjonen ble kjent eller publisert hos oss, ikke bare etter retroaktiv kildegyldighet.

## To gyldige behov

I praksis finnes det ofte to ulike behov:

- Kildekorrekt historikk: hva som egentlig gjaldt i kilden på et gitt tidspunkt.
- Stabil rapporthistorikk: hva som var kjent og rapportert på et gitt tidspunkt.

Disse behovene bør ikke presses inn i samme felt eller samme tolkning.

Hvis begge behov finnes, bør de modelleres eksplisitt i stedet for å blandes sammen.

## Praktisk modellvalg

For de fleste dataprodukter er følgende en god pragmatisk løsning:

- behold kildegyldighet som egen historikk
- behold lastetid eller observasjonstid som egen teknisk tidslinje
- bruk den tekniske tidslinjen når målet er stabile rapporter og reproduserbar statistikk

Hvis et produkt skal støtte full rekonstruksjon av hva som var kjent på et gitt tidspunkt, beveger man seg i praksis mot en bi-temporal modell. Det er mulig, men mer komplekst, og skal være et bevisst valg.

## Når vi må være ekstra forsiktige

Etterregistreringer er spesielt kritiske når:

- tall publiseres periodisk og ikke skal endres i ettertid
- rapporter brukes som offisiell statistikk
- ulike dataprodukter sammenlignes over tid
- konsumenter forventer at samme spørring gir samme historiske svar senere

I slike tilfeller skal ikke tilbakevirkende oppdatering av gyldighetsintervall være default.

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
