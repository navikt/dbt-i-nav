# Granularitet

Granularitet er den viktigste egenskapen ved et dataprodukt etter innhold og historikk. Hvis granulariteten er uklar, blir joins, filtrering, aggregering og testing uforutsigbart.

Målet med denne siden er å beskrive hva granularitet er, hvordan den skal velges, og hvordan den skal kommuniseres i et dataprodukt.

## Hva granularitet er

Granularitet beskriver hva én rad i en modell representerer.

Granulariteten skal kunne uttrykkes som en kort setning, for eksempel:

- Én rad per person
- Én rad per person per dag
- Én rad per vedtak
- Én rad per arbeidsforhold per gyldighetsintervall
- Én rad per utbetalingstransaksjon

Hvis en modell ikke kan beskrives på denne måten, er granulariteten sannsynligvis for uklar.

## Hvorfor granularitet er viktig

Tydelig granularitet gjør det mulig å:

- forstå hva modellen kan brukes til
- vite om en join er trygg eller vil multiplisere rader
- vite når en modell må aggregeres før bruk
- teste om modellen faktisk oppfører seg som forventet
- dele dataprodukter på tvers av domener uten at konsumenter må lese implementasjonen

I praksis er mange feil i dataprodukter egentlig feil i granularitet.

## Hovedregel

Granularitet skal være eksplisitt for alle eksponerte modeller.

Det betyr:

- alle dimensjoner skal ha tydelig definert granularitet
- alle fakta skal ha tydelig definert granularitet
- alle brede konsumflater skal ha tydelig definert granularitet
- granulariteten skal være forståelig uten å lese implementasjonen

## Granularitet og modelltype

Historikk og navnestandard gjør det enklere å beskrive granularitet, men de erstatter det ikke.

### Dimensjoner

Dimensjoner skal ha en stabil og forståelig granularitet.

Typiske eksempler:

- én rad per person
- én rad per arbeidsgiver
- én rad per person per gyldighetsintervall

Hvis en dimensjon er historisert, skal granulariteten uttrykke dette eksplisitt.

### Fakta

Fakta skal beskrive en hendelse, tilstand eller måling på et konkret nivå.

Typiske eksempler:

- én rad per vedtak
- én rad per utbetaling
- én rad per person per måned per ytelse

Hvis granulariteten i en faktamodell er sammensatt, skal alle relevante akser med i beskrivelsen.

### Brede konsumflater

Brede konsumflater er ofte de vanskeligste modellene å forstå. Derfor må granulariteten være ekstra tydelig.

Typiske eksempler:

- én rad per person med gjeldende status
- én rad per person per måned
- én rad per vedtak med påberikede attributter

En bred konsumflate skal ikke beskrives bare som en bred tabell for analyse. Det sier ingenting om granulariteten.

## Granularitet og historikk

Hvis modellen er historisert, er historikk en del av granulariteten.

Det betyr at følgende beskrivelser ikke er like:

- én rad per person
- én rad per person per gyldighetsintervall
- én rad per person per dag

## Granularitet og deling

Før en modell deles, bør det være tydelig:

- hvilke kolonner som identifiserer granulariteten
- om granulariteten er unik i modellen
- om modellen kan kobles direkte mot andre modeller
- om konsumenter må aggregere først

Hvis disse spørsmålene ikke har tydelige svar, er modellen ikke godt nok beskrevet.

## Praktisk tommelfingerregel

- Hvis du ikke kan forklare hva én rad representerer i én setning, er granulariteten for uklar.
- Hvis granulariteten ikke er dokumentert, er den ikke godt nok delt.
- Hvis historikk inngår i granulariteten, må det sies eksplisitt.

For implementasjon i dbt, se [../dbt-kodestandard/grain.md](../dbt-kodestandard/grain.md).
