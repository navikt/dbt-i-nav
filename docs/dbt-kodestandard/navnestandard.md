# Navnestandard

Dette er noe av det vanskeligste å standardisere på tvers. Det er mye enklere å bli enige om navn innenfor ett team enn på tvers av mange domener. Uten en navnestandard ender vi fort opp med flere varianter av det samme begrepet, og da blir både gjenbruk, forståelse og kobling av data vanskeligere.

Team kan være fleksible internt, men modeller som eksponeres for andre skal følge denne standarden.

## Formål

Navnestandarden skal sikre at:

- samme konsept heter det samme på tvers av komponenter
- grain er mulig å forstå uten å lese SQL-en
- dimensjoner, fakta og OBT-er er lette å kjenne igjen
- kolonner kan gjenbrukes og joines på tvers uten unødvendig oversettelse

I dbt betyr dette at vi går bort fra mye av den gamle Oracle- og PowerCenter-arven i navnene. Vi navngir først og fremst etter forretningsbetydning, ikke etter teknisk implementasjon.

## Prinsipper

- Navn skal være meningsbærende og stabile over tid.
- Navn skal beskrive forretningsinnhold, ikke hvilket verktøy eller hvilken jobb som har laget modellen.
- Samme begrep skal ha samme navn overalt, med mindre det faktisk betyr noe forskjellig.
- Eksponerte modeller skal ha norsk eller domeneforankret begrepsbruk som brukerne kjenner igjen.
- Tekniske forkortelser skal begrenses til etablerte prefiks som gir verdi i dbt-modellen.

## Navngivning av tabeller

Vi tar utgangspunkt i smale stjernemodeller i hver komponent, og OBT-er på toppen der det gir mening.

### Eksponerte modeller

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

### Når komponent eller domene skal inn i navnet

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

### Hva vi ikke gjør

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

### Historikkolonner

Siden historikk er grunnleggende i datavarehuset vårt, skal historikk også være tydelig i navnene.

Prinsippene for hvordan historikk skal forstås og brukes er beskrevet i [historikk.md](historikk.md).

### Definisjoner

- Funksjonell dato eller tid: dato- og tidspunktfelter definert hos kilden, som kan settes eller endres manuelt av brukere, og som ikke er koblet direkte til systemklokken.
- Tekniske tidspunkt hos kilde: tidsstempler i kildesystemet som settes automatisk og ikke kan endres manuelt, for eksempel når raden ble opprettet eller endret.
- Tekniske dataproduktstidspunkt: datoer eller tidspunkt som settes i dataproduktet, for eksempel `lastet_dato`, `lastet_tid`, `oppdatert_dato` eller `oppdatert_tid`.

### Grunnregel for gyldighetsintervall

Gyldighetsintervallet skal gjenspeile perioden da raden eksisterte og så slik ut i kilden, uavhengig av når løsningen observerte eller lastet raden.

Hvis kilden ikke tilbyr en god tidsangivelse, kan tidspunktet oppstå i transformasjonsløpet. For kodeverk og dimensjoner er det tillatt å sette start på historikk til `01.01.1900` når opprinnelig startdato ikke er kjent, slik at eldre datasett fortsatt kan få treff.

### Historikk med døgnoppløsning

Når historikken føres per døgn, bruker vi suffikset `_dato`.

For lukkede intervaller bruker vi:

- `gyldig_fom_dato`
- `gyldig_tom_dato`

Regler:

- `gyldig_fom_dato` trunkeres til dagen raden oppstod eller ble oppdatert i kilden.
- `gyldig_tom_dato` settes til dagen før neste rad blir gyldig.
- Siste rad settes til `31.12.9999`.

Tekniske dataproduktdatoer ved døgnoppløsning navngis:

- `oppdatert_dato`
- `lastet_dato`

### Historikk med sekundoppløsning

Når flere hendelser kan skje samme dag, bruker vi suffikset `_tid`.

For halvåpne intervaller bruker vi:

- `gyldig_fom_tid`
- `gyldig_til_tid`

Regler:

- `gyldig_fom_tid` trunkeres til sekundet raden oppstod eller ble endret i kilden.
- `gyldig_til_tid` får samme verdi som neste rads `gyldig_fom_tid`.
- Siste rad settes til `31.12.9999`.

Tekniske dataprodukttider ved sekundoppløsning navngis:

- `oppdatert_tid`
- `lastet_tid`

### Historikk med millisekund eller høyere oppløsning

Når kilden leverer hendelser innenfor samme sekund, bruker vi suffikset `_ts`.

For slike intervaller bruker vi:

- `gyldig_fom_ts`
- `gyldig_til_ts`

Regler:

- `gyldig_fom_ts` settes til timestamp for når raden oppstod eller ble endret i kilden.
- `gyldig_til_ts` får samme verdi som neste rads `gyldig_fom_ts`.
- Siste rad settes til `31.12.9999`.

Tekniske dataprodukttidspunkter ved slik oppløsning navngis:

- `oppdatert_ts`
- `lastet_ts`

### Tilpassede felt

I spesielle tilfeller kan det være nødvendig å kombinere åpne og lukkede intervaller eller blande dato og timestamp. Da skal navnet fortsatt være eksplisitt og følge mønsteret:

- `gyldig_fra_dato`
- `gyldig_fom_dato`
- `gyldig_til_tid`
- `gyldig_tom_dato`
- `gyldig_fom_ts`

Valget mellom `fra` og `fom`, og mellom `til` og `tom`, skal speile om intervallet forstås som åpent eller lukket.

### Andre historikkolonner

I tillegg til gyldighetsintervall bruker vi ofte:

- `er_gjeldende`
- `kildesystem`

Hvis modellen uttrykker funksjonell gyldighet i tillegg til teknisk gyldighet, skal dette fremgå tydelig:

- `funksjonell_fra_dato`
- `funksjonell_til_dato`

### Kolonner i OBT-er

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

## Anbefalt struktur for smale stjernemodeller

Per komponent bør vi som hovedregel sikte mot:

- noen få tydelige `dim_`-modeller med stabile nøkler og beskrivende attributter
- en eller flere `fak_`-modeller med tydelig definert grain
- eventuelle `kobling_`-modeller der relasjonene faktisk er mange-til-mange
- én eller flere `obt_`-modeller kun når det gir en klar gevinst for konsum

Det betyr i praksis at navngivningen skal støtte følgende lesemåte:

- `dim_person` beskriver hvem noe gjelder
- `fak_vedtak` beskriver hva som har skjedd
- `obt_oppfolging_person` beskriver en ferdig konsumflate

## Konkrete regler

- Modellnavn skrives med små bokstaver og underscore.
- Modellnavn skrives i entall når grain er én forekomst per rad.
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
- Bruk forretningsnavn, ikke tekniske Oracle-navn.
- Bruk `<entitet>_key` for surrogate nøkler og `<entitet>_id` for forretningsnøkler.
- Sørg for at samme begrep heter det samme på tvers av komponenter.
- Gjør OBT-er ekstra eksplisitte, fordi de blir konsumert direkte.

