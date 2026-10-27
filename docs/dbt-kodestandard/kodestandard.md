# Kodestandard

## Fellesdimensjoner

Nav har kodeverk for å ivareta felles dimensjonstabeller, som kalender og geografi.

https://confluence.adeo.no/spaces/DVH/pages/385080641/dvh_kodeverk

### Skjermede personer

Knytte fk_person1 kan gjøres på flere måter. Ønsker man å unngå å ta med skjermede, kan man benytte følgende tabell:
dt_person.ident_off_id_til_fk_person1_ikke_skjermet

Kodeeksempel:
    left outer join {{ source('person', 'ident_off_id_til_fk_person1_ikke_skjermet') }} t2 
    on t1.skyldner = t2.off_id
    and t2.gyldig_fra_dato <= t1.vedtaks_ts
    and t2.gyldig_til_dato >= t1.vedtaks_ts


### Ukjente verdier
Benytt kodeverk for ukjente verdier:
select * from DT_KODEVERK.DIM_UKJENT_VERDI
For eks blir "skjermet" kode -5
