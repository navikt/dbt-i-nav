# Navnestandard

Navnestandard i dataprodukter skal sikre at modeller og kolonner er forståelige, stabile og konsistente på tvers av team.

Målet er ikke bare pene navn, men navn som gjør produktene lettere å koble sammen og bruke riktig.

## Formål

Navnestandarden skal sikre at:

- samme konsept heter det samme på tvers av komponenter
- granulariteten er mulig å forstå uten å lese implementasjonen
- modeller er lette å kjenne igjen etter rolle
- kolonner kan gjenbrukes og kobles på tvers uten unødvendig oversettelse

## Prinsipper

- navn skal være meningsbærende og stabile over tid
- navn skal beskrive forretningsinnhold, ikke teknisk implementasjon
- samme begrep skal ha samme navn overalt, med mindre det faktisk betyr noe forskjellig
- eksponerte modeller skal ha norsk eller domeneforankret begrepsbruk som brukerne kjenner igjen

## Nøkler og attributter

Kolonnenavn er viktigere enn tabellnavn. Det er kolonnene som faktisk brukes i koblinger, filtrering, tester og dokumentasjon.

- identifikatorer skal navngis etter hva de representerer
- attributter skal være eksplisitte og selvforklarende
- historikkfelter skal gjøre det tydelig hvilken type tid eller gyldighet de uttrykker

## Brede konsumflater

I brede konsumflater skal navn være ekstra tydelige, fordi disse modellene ofte brukes direkte av analytikere og rapporter.

- tvetydige navn som `status`, `dato`, `navn` og `id` skal ikke brukes alene
- kolonner fra ulike områder skal ha navn som gjør dem unike og forståelige

For implementasjon i dbt, se [../dbt-kodestandard/navnestandard.md](../dbt-kodestandard/navnestandard.md).
