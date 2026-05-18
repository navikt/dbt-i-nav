# Dataprodukt

Denne seksjonen beskriver reglene for hvordan et dataprodukt skal utformes og eksponeres, uavhengig av implementasjonsverktøy.

Målet er å skille mellom:

- regler for selve dataproduktet
- hvordan disse reglene implementeres i dbt

Dataprodukt-seksjonen beskriver hva som må være sant for at et produkt skal være forståelig, robust og trygt å bruke på tvers av team.

Seksjonen `dbt standarder` beskriver deretter hvordan de samme reglene skal uttrykkes konkret i dbt med modellnavn, yml, `meta`, tester og struktur.

## Hovedregel

Et eksponert dataprodukt skal være forståelig uten at konsumenten må lese SQL eller kjenne intern implementasjon.

Det betyr at produktet må være tydelig på:

- hva modellen representerer
- hva én rad representerer
- hvordan historikk skal forstås
- hvilke navn og begreper som brukes
- hvordan kontrakten dokumenteres og verifiseres

## Sider i denne seksjonen

- [Granularitet](granularitet.md)
- [Historikk](historikk.md)
- [Navnestandard](navnestandard.md)
- [Kontrakter](kontrakter.md)
- [Dokumentasjon](dokumentasjon.md)
- [Testing](testing.md)

## Forholdet til dbt-standarder

Hvis du skal ta stilling til hva et dataprodukt bør love, start her.

Hvis du skal implementere disse løftene i dbt, gå videre til seksjonen `dbt standarder`.
