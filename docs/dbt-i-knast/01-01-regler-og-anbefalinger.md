## Regler og anbefalinger

For dbt-utvikling i DVH gjelder i praksis disse hovedreglene:

- bruk nettleserbasert Knast (dbt-stable) mot DVH
- unngå å lagre data lokalt i Knast over tid
- rydd i filer som inneholder sensitiv informasjon
- åpne eksterne URL-er bare ved tjenstlig behov
- Hvis du trenger ekstra Python-pakker i egne miljøer, bruk den anbefalte Knast-måten for dette. Ikke gjør tilfeldige lokale oppsett til en del av standard dbt-flyt.

Kort sagt: hold utviklingsløpet enkelt og repeterbart.

## Viktig sikkerhetsprinsipp

Ikke bygg en alternativ lokal løsning for hemmeligheter hvis standardflyten i Knast fungerer. Det anbefalte løpet er:

- velg miljø med `dvh`
- bruk KSM og miljøvariabler
- la dbt hente credentials via oppsatt integrasjon

Da får du minst mulig manuelt hemmelighetsarbeid og minst mulig risiko for feil bruk.