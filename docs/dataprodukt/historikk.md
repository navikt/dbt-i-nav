# Historikk

Historikk er en grunnleggende del av dataprodukter. Uten tydelige prinsipper for historikk får vi produkter som ser riktige ut hver for seg, men som oppfører seg ulikt når de brukes sammen.

Målet med denne siden er å beskrive prinsippene for historikk i dataprodukter.

## Formål

Historikk skal gjøre det mulig å:

- forstå hva som var gjeldende på et gitt tidspunkt
- gjenskape tidligere tilstander i et dataprodukt
- koble produkter på tvers uten at tidslogikken bryter sammen
- skille mellom når noe gjaldt i kilden og når det ble observert i dataproduktet

## Hovedprinsipp

Historikk i dataproduktet skal beskrive perioden da raden eksisterte og så slik ut i kilden, ikke bare når løsningen oppdaget endringen.

Det betyr:

- gyldighetsintervall skal fortrinnsvis baseres på informasjon fra kilden
- lastetidspunkt og oppdatertidspunkt i dataproduktet skal ikke forveksles med gyldighet i kilden
- hvis kilden ikke har gode nok tidspunkter, må dataproduktet etablere en konsistent erstatning og være tydelig på det

## Etterregistreringer og stabile tall

En rad kan bli kjent sent, men likevel ha en kildegyldighet langt tilbake i tid.

For eksponerte dataprodukter som brukes til statistikk og rapportering gjelder derfor følgende hovedregel:

- vi skal som utgangspunkt ikke omskrive publisert historie tilbake i tid bare fordi en etterregistrering blir kjent senere

Det betyr at vi må holde to ting fra hverandre:

- hva som var gyldig i kilden
- når dataproduktet faktisk fikk kjennskap til det

## To gyldige behov

I praksis finnes det ofte to ulike behov:

- kildekorrekt historikk: hva som egentlig gjaldt i kilden på et gitt tidspunkt
- stabil rapporthistorikk: hva som var kjent og rapportert på et gitt tidspunkt

Disse behovene bør ikke presses inn i samme felt eller samme tolkning.

## Valg av oppløsning

Historikk skal føres med den laveste oppløsningen som faktisk trengs, men ikke grovere enn forretningsbehovet krever.

- bruk døgnoppløsning når det er tilstrekkelig å vite hvilken dag en rad ble gyldig eller utgikk
- bruk sekundoppløsning når flere hendelser kan skje samme dag og rekkefølgen er viktig
- bruk timestamp når kilden faktisk leverer hendelser innenfor samme sekund, eller sekundnivå ikke er nok

## Lukkede og halvåpne intervaller

Valg av intervallmodell skal være bevisst og konsekvent.

- døgnoppløsning føres normalt som lukkede intervaller
- sekund- og timestampoppløsning føres normalt som halvåpne intervaller

Det viktigste er at modellen er konsistent, tydelig kommunisert og ikke lager hull eller overlapp uten at det er tilsiktet.

## Krav til konsistens

Innenfor ett dataprodukt skal historikk følge ett tydelig mønster.

Det betyr:

- samme type gyldighet skal uttrykkes likt i alle modeller
- samme oppløsning skal brukes for samme type behov
- samme begreper skal brukes konsekvent på tvers av modeller

For implementasjon i dbt, se [../dbt-kodestandard/historikk.md](../dbt-kodestandard/historikk.md).
