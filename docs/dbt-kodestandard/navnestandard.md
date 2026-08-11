# Navnestandard i dbt

Denne siden beskriver hvordan navnestandarden implementeres i dbt-prosjektet.

For bakgrunn og produktregler, se [../dataprodukt/navnestandard.md](../dataprodukt/navnestandard.md).

- Benytt norsk språk.
- Benytt små bokstaver.
- Benytt snake_case.
- Oversett æ med ae, ø med o, å med aa.
- Modellnavn skrives i entall når granulariteten er én forekomst per rad.
- Forkortelser brukes bare når de er allment forstått i domenet.
- Samme kolonne skal hete det samme i dimensjon, fakta og OBT når den betyr det samme.
- Eksponerte modeller skal ikke lekke gamle lagbegreper som forkammer, kjerne og torg inn i navnene.

Unngå:
- Vi bruker ikke `DIM_`, `FAK_` og `AGG_` i store bokstaver.
- Vi bruker ikke tekniske prefiks som sier noe om fysisk databaseobjekt.
- Vi bruker ikke kildesystemnavn i eksponerte modellnavn, med mindre modellen faktisk representerer kilden som kilde.
- Vi bruker ikke både teknisk og funksjonelt navn i samme modellnavn.



### Eksempel på komponenter og kolonnenavn

| Komponenter      | Kolonnenavn |
| ----------- | ----------- |
| `stg_aareg_arbeidsforhold`      | `key_aareg_arbeidsforhold`       |
| `int_arbeid_arbeidsforhold_historisert`   | `person_id`        |
|`dim_arbeidsgiver`   | `gyldig_flagg`        |
|`dim_person`   | `dato_gyldig_fom`        |
|`fak_arbeidsforhold`   | `dato_gyldig_tom`        |
|`obt_arbeid_personstatus`   | `arbeidsforhold_status`        |


## Modellprefiks for eksponerte modeller i marts

For modeller som andre skal lese og bygge videre på, bruker vi følgende hovedmønstre:

- `dim_<navn>` for dimensjoner
- `fak_<navn>` for fakta
- `obt_<navn>` for OBT-er (One Big Table)
- `kobling_<navn>` for koblingstabeller når mange-til-mange må modelleres eksplisitt

Eksempler:

- `dim_person`
- `dim_arbeidsgiver`
- `fak_vedtak`
- `fak_utbetaling`
- `kobling_person_organisasjon`
- `obt_oppfolging_person`

## Når komponent eller domene skal inn i navnet

Hvis et navn ellers blir for generelt eller kolliderer med andre komponenter, skal komponent eller domene inn i navnet.

Mønster:

- `dim_<komponent>_<navn>`
- `fak_<komponent>_<navn>`
- `obt_<komponent>_<navn>`

Eksempler:

- `dim_arbeid_person`
- `fak_arbeid_vedtak`
- `obt_arbeid_personstatus`

Komponentnavn skal bare tas med når det bidrar til avklaring. Vi skal ikke legge på domene-prefiks av gammel vane.



## Navngivning av interne dbt-modeller

For interne modeller i dbt anbefaler vi følgende mønster, hvor stg og base har dobbel underscore for å enklere skille mellom kildesystem og objekt i kildesystem, når man ser på objekter i databasen:

- `stg_<kilde>__<objekt>` for stagingmodeller
- `base_<kilde>__<objekt>` kun der det er behov for et eksplisitt base-lag
- `int_<tema>_<formaal>` for interne mellommodeller

Eksempler:

- `stg_aareg__arbeidsforhold`
- `stg_pp01__vedtak`
- `int_oppfolging_person_beriket`

Disse modellene er interne arbeidsflater. Her er det lov å være mer teknisk, men navnene skal fortsatt være forståelige.

## Navngivning av kolonner

Kolonnenavn er viktigere enn tabellnavn. Det er kolonnene som faktisk blir brukt i joins, filtrering, tester og dokumentasjon.

### Grunnregel

Kolonner skal navngis etter hva de betyr, ikke hvor de kommer fra. Grunnleggende kolonnenavn/prefiks for velbrukte kolonner:

- _id som suffiks for naturlige id-felter.
- key_ som prefiks for surrogate/syntetiske nøkler.
- dato_ som prefiks for datoer.
- tid_ som prefiks for dato med tidspunkt med millisekunder presisjon.
- ts_ som prefiks for dato med timestamps med opptil nanosekunder presisjon.
- _flagg som suffiks for flagg-kolonner, enten med true/false eller med enten/eller kategoriseringsinnhold.
- lastet_ som prefiks for systemfelt, for når dataene sist ble lastet i modellen.
- _navn som suffiks for å spesifisere tekstkolonner hvis beskrivelsen ikke er god nok alene. For eks "land" kan være en god nok beskrivelse istedenfor land_navn?
- kildesystem som kolonnenavn hvis det er viktig å spesifisere kilde

Vær presis med navngivning, slik at kolonnenavnet representerer faktisk innhold.
Eksempler:

- bruk `person_id`, ikke `aktorid` hvis kolonnen faktisk representerer personens identifikator i modellen
- bruk `dato_vedtak`, ikke `behandlingsdato`, hvis det er vedtakstidspunkt modellen uttrykker
- bruk `arbeidsgiver_navn`, ikke `navn`, når kolonnen ellers blir tvetydig

### Nøkler

Vi skiller tydelig mellom forretningsnøkler og surrogate nøkler.

- Surrogate nøkler i dimensjoner navngis `key_<entitet>`
- Fremmednøkler i fakta bruker samme navn som dimensjonen peker på
- Forretningsnøkler navngis `<entitet>_id` eller `<entitet>_<kode/navn>` når det er mer presist
- Vi bruker ikke `pk_`, `fk_` eller `ek_` som kolonneprefiks i eksponerte dbt-modeller. Slike navn beskriver databaseimplementasjon, ikke informasjonen brukeren forholder seg til. 

Eksempler:

- `key_person`
- `key_arbeidsgiver`
- `person_id`
- `organisasjon_id`
- `vedtak_id`



### Beskrivende attributter

Beskrivende kolonner skal være eksplisitte og selvforklarende. Dette er spesielt viktig i OBT-tabeller, hvor det er viktig å unngå tvetydige navn, og at kolonner skal kunne forstås uten kjennskap til de underliggende dimensjonene.

- bruk `person_navn`, ikke bare `navn`
- bruk `vedtak_status`, ikke bare `status`
- bruk `utbetaling_belop`, ikke bare `belop`
- bruk `gjelder_fom` og `gjelder_tom` bare der dette faktisk er det etablerte domenespråket

Anbefalte suffiks når de gir mening:

- `_kode` for kodeverdier
- `_navn` for lesbare navn
- `_tidspunkt` for tidspunkt med klokkeslett
- `_belop` for beløp
- `_antall` for tellinger
- `_andel` eller `_prosent` for forholdstall

For boolske verdier foretrekkes navn som er enkle å forstå:

- `flagg_aktiv`
- `flagg_gyldig`
- `flagg_vedtak`

### Historikkolonner
Tidsstempel: 

| Kolonneinnhold      | dato | tid     | timestamp     |
| ----------- | ----------- | ----------- | ----------- |
| Gyldig fra og med   | `dato_gyldig_fom` | `tid_gyldig_fom`       | `ts_gyldig_fom`       |
| Gyldig til og med  | `dato_gyldig_tom` | `tid_gyldig_til`        |`ts_gyldig_til`        |
| Oppdatert dato  | `dato_oppdatert` | `tid_oppdatert`        | `ts_oppdatert`        |
| Funksjonell/teknisk gyldighet fra  | `dato_funksjonell_fra` | `tid_funksjonell_fra`        | `ts_funksjonell_fra`        |
| Funksjonell/teknisk gyldighet til  | `dato_funksjonell_til` | `tid_funksjonell_til`        | `ts_funksjonell_til`        |
