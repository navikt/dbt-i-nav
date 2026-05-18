# Kontrakter

Eksponerte modeller må ha en tydelig kontrakt.

Kontrakten skal gjøre det mulig å forstå og bruke modellen uten å lese SQL-en eller kjenne implementasjonen.

## Formål

En kontrakt skal gjøre det tydelig:

- hva modellen representerer
- hva én rad i modellen representerer
- hvilke kolonner som identifiserer raden
- hvordan historikk skal forstås
- hvilke felter som er stabile og trygge å bruke videre

## Hovedregel

Alle eksponerte modeller skal ha en kontrakt.

Dette gjelder for:

- dimensjoner
- fakta
- brede konsumflater
- andre modeller som deles på tvers av team eller brukes som konsumflate

## Minimumskrav i kontrakten

Følgende metadata er obligatoriske i kontrakten for alle eksponerte modeller:

- formål: hva modellen brukes til
- granularitet: hva én rad representerer
- nøkkelkolonner: hvilke kolonner som identifiserer granulariteten
- historikk: om modellen er historisert, og hvordan historikken skal forstås
- sentrale forretningskolonner: hvilke felt konsumenter forventes å bruke

## Praktisk minimum

Før en modell eksponeres, skal følgende være på plass:

- modellbeskrivelse
- eksplisitt granularitet
- identifiserte nøkkelkolonner
- historikkbeskrivelse hvis relevant
- grunnleggende verifikasjon av kontrakten

For implementasjon i dbt, se [../dbt-kodestandard/modellkontrakter.md](../dbt-kodestandard/modellkontrakter.md).
