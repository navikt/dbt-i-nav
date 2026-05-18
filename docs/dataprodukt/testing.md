# Testing

Testing skal bekrefte at modellen faktisk oppfører seg slik kontrakten sier.

For dataprodukter betyr det at vi tester at modellen holder lovet granularitet, historikk og andre sentrale regler som konsumentene er avhengige av.

## Hovedregel

Alle eksponerte modeller skal testes på de kontraktskravene de lover.

Det betyr normalt:

- test av nøkkelkolonner
- test av unikhet på riktig nivå
- test av historikkregler når modellen er historisert
- test av joins og radmultiplikasjon når modellen er satt sammen av flere kilder

## Hva som skal verifiseres

Når vi tester et dataprodukt, verifiserer vi i praksis tre ting:

- at én rad faktisk representerer det modellen sier at den representerer
- at historikkregler og tidslogikk holder
- at modellen er trygg å bruke videre i konsum og koblinger

## Praktisk minimum

- en enkel modell skal testes for identitet og unikhet
- en sammensatt modell skal testes for kombinasjonsunikhet
- en historisert modell skal testes for historikkregler i tillegg til unikhet
- en bred konsumflate skal testes for at joins ikke har ødelagt granulariteten

For implementasjon i dbt, se [../dbt-kodestandard/testing.md](../dbt-kodestandard/testing.md).
