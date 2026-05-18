# Navnestandard i dbt

Denne siden beskriver hvordan navnestandarden skal implementeres i dbt-prosjektet.

Selve navneprinsippene for dataproduktet er beskrevet i [../dataprodukt/navnestandard.md](../dataprodukt/navnestandard.md).

## Formål i dbt

Navnestandarden i dbt skal sikre at:

- eksponerte modeller får tydelige og gjenkjennelige prefiks
- interne modeller følger et enkelt og konsistent prosjektmønster
- kolonnenavn blir enkle å koble, dokumentere og teste

## Navngivning av eksponerte modeller

For modeller som andre skal lese og bygge videre på, bruker vi følgende hovedmønstre:

- `dim_<navn>` for dimensjoner
- `fak_<navn>` for fakta
- `obt_<navn>` for OBT-er
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

Komponentnavn skal bare tas med når det gir faktisk avklaring. Vi skal ikke legge på domene-prefiks av gammel vane.

## Hva vi ikke gjør

- Vi bruker ikke `DIM_`, `FAK_` og `AGG_` i store bokstaver.
- Vi bruker ikke tekniske prefiks som sier noe om fysisk databaseobjekt.
- Vi bruker ikke kildesystemnavn i eksponerte modellnavn, med mindre modellen faktisk representerer kilden som kilde.
- Vi bruker ikke både teknisk og funksjonelt navn i samme modellnavn.

## Navngivning av interne dbt-modeller

For interne modeller i dbt anbefaler vi et enklere og velkjent mønster:

- `stg_<kilde>__<objekt>` for stagingmodeller
- `int_<tema>__<formaal>` for interne mellommodeller
- `base_<kilde>__<objekt>` kun der det er behov for et eksplisitt base-lag

Eksempler:

- `stg_aareg__arbeidsforhold`
- `stg_pp01__vedtak`
- `int_oppfolging__person_beriket`

Disse modellene er interne arbeidsflater. Her er det lov å være mer teknisk, men navnene skal fortsatt være forståelige.

## Navngivning av kolonner

Kolonnenavn er viktigere enn tabellnavn. Det er kolonnene som faktisk blir brukt i joins, filtrering, tester og dokumentasjon.

### Grunnregel

Kolonner skal navngis etter hva de betyr, ikke hvor de kommer fra.

Eksempler:

- bruk `person_id`, ikke `aktorid` hvis kolonnen faktisk representerer personens identifikator i modellen
- bruk `vedtak_dato`, ikke `behandlingsdato`, hvis det er vedtakstidspunkt modellen uttrykker
- bruk `arbeidsgiver_navn`, ikke `navn`, når kolonnen ellers blir tvetydig

### Nøkler

Vi skiller tydelig mellom forretningsnøkler og surrogate nøkler.

- Surrogate nøkler i dimensjoner navngis `<entitet>_key`
- Fremmednøkler i fakta bruker samme navn som dimensjonen peker på
- Forretningsnøkler navngis `<entitet>_id` eller `<entitet>_<kode/navn>` når det er mer presist

Eksempler:

- `person_key`
- `arbeidsgiver_key`
- `person_id`
- `organisasjon_id`
- `vedtak_id`

Vi bruker ikke `pk_`, `fk_` eller `ek_` som kolonneprefiks i eksponerte dbt-modeller. Slike navn beskriver databaseimplementasjon, ikke informasjonen brukeren forholder seg til.

### Beskrivende attributter

Beskrivende kolonner skal være eksplisitte og selvforklarende.

- bruk `person_navn`, ikke bare `navn`
- bruk `vedtak_status`, ikke bare `status`
- bruk `utbetaling_belop`, ikke bare `belop`
- bruk `gjelder_fom` og `gjelder_tom` bare der dette faktisk er det etablerte domenespråket

Anbefalte suffiks når de gir mening:

- `_id` for identifikator
- `_key` for surrogate nøkkel
- `_kode` for kodeverdier
- `_navn` for lesbare navn
- `_dato` for dato uten klokkeslett
- `_tidspunkt` for tidspunkt med klokkeslett
- `_belop` for beløp
- `_antall` for tellinger
- `_andel` eller `_prosent` for forholdstall
- `_flagg` eller `er_<egenskap>` for boolske verdier

For boolske verdier foretrekkes navn som leses naturlig:

- `er_aktiv`
- `er_gjeldende`
- `har_vedtak`

## Historikkolonner

Når historikken føres per døgn, bruker vi normalt:

- `gyldig_fom_dato`
- `gyldig_tom_dato`

- `oppdatert_dato`
- `lastet_dato`

Når historikken føres med sekundoppløsning, bruker vi normalt:

- `gyldig_fom_tid`
- `gyldig_til_tid`

- `oppdatert_tid`
- `lastet_tid`

Når historikken føres med timestamp-oppløsning, bruker vi normalt:

- `gyldig_fom_ts`
- `gyldig_til_ts`

- `oppdatert_ts`
- `lastet_ts`

Andre vanlige historikkolonner er:

I tillegg til gyldighetsintervall bruker vi ofte:

- `er_gjeldende`
- `kildesystem`

Hvis modellen uttrykker funksjonell gyldighet i tillegg til teknisk gyldighet, skal dette fremgå tydelig:

- `funksjonell_fra_dato`
- `funksjonell_til_dato`

## Kolonner i OBT-er

I OBT-er skal kolonnenavn være ekstra tydelige, fordi disse modellene ofte brukes direkte av analytikere og rapporter.

- Kolonner skal kunne forstås uten kjennskap til de underliggende dimensjonene.
- Tvetydige navn som `status`, `dato`, `navn` og `id` skal ikke brukes alene.
- Kolonner fra ulike områder skal ha prefiks eller fullt navn som gjør dem unike.

Eksempler:

- `person_id`
- `person_navn`
- `arbeidsgiver_navn`
- `vedtak_status`
- `utbetaling_belop`

## Konkrete regler

- Modellnavn skrives med små bokstaver og underscore.
- Modellnavn skrives i entall når granulariteten er én forekomst per rad.
- Kolonnenavn skrives med små bokstaver og underscore.
- Forkortelser brukes bare når de er allment forstått i domenet.
- Samme kolonne skal hete det samme i dimensjon, fakta og OBT når den betyr det samme.
- Eksponerte modeller skal ikke lekke gamle lagbegreper som forkammer, kjerne og torg inn i navnene.

## Eksempel

Et mulig mønster for en komponent kan se slik ut:

- `stg_aareg__arbeidsforhold`
- `int_arbeid__arbeidsforhold_historisert`
- `dim_arbeidsgiver`
- `dim_person`
- `fak_arbeidsforhold`
- `obt_arbeid_personstatus`

Med tilhørende kolonner:

- `person_key`
- `person_id`
- `arbeidsgiver_key`
- `arbeidsgiver_id`
- `arbeidsforhold_id`
- `arbeidsforhold_status`
- `gyldig_fra_dato`
- `gyldig_til_dato`
- `er_gjeldende`

## Kort oppsummert

- Bruk `dim_`, `fak_`, `kobling_` og `obt_` for eksponerte modeller.
- Bruk `stg_`, `int_` og eventuelt `base_` for interne modeller.
- Bruk `<entitet>_key` for surrogate nøkler og `<entitet>_id` for forretningsnøkler.
- La historikkfeltene følge ett tydelig mønster i prosjektet.

