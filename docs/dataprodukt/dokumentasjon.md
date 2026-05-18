# Dokumentasjon

Dokumentasjon i et dataprodukt skal gjøre det mulig å forstå, bruke og forvalte produktet uten å lese implementasjonen.

## Formål

Dokumentasjonen skal gjøre det mulig å forstå:

- hva modellen representerer
- hva én rad representerer
- hvilke nøkkelkolonner som identifiserer granulariteten
- hvordan historikk skal tolkes
- hvilke kolonner som er sentrale for konsum
- hvem som eier modellen

## Hovedregel

Alle eksponerte modeller skal dokumenteres.

I praksis betyr dette at dokumentasjonen skal ligge tett på modellen, versjoneres sammen med koden og være lett å finne for konsumenter.

## Minimumskrav

For hver eksponert modell skal følgende være dokumentert:

- modellbeskrivelse
- granularitet
- nøkkelkolonner som identifiserer granulariteten
- historikk, hvis modellen er historisert
- beskrivelse av sentrale kolonner

## Tommelfingerregel

- Dokumentasjon skal være nær modellen.
- Granularitet og historikk skal stå i klartekst.
- Viktige kolonner skal beskrives, ikke bare listes.
- En annen produsent eller konsument skal kunne forstå modellen på høyt nivå.

For implementasjon i dbt, se [../dbt-kodestandard/dokumentasjon.md](../dbt-kodestandard/dokumentasjon.md).
