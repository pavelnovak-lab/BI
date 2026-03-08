SELECT p."Registraèní èíslo projektu" ,
       p.zadatel ,
       p."IÈ",
       zoz."Datum podání",
       zoz."Datum úèinnosti",
       zoz.NAZEV,
       zoz.obrazovky,
       zoz.wfstav ,
       zoz."Informace od pøíjemce",
       ci."Název" "Záva¾nost zmìny",
       zoz."Poøadové èíslo ®oZ"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzZoZProjekt zoz ON zoz.id_zad = p.id
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = zoz.id_zavaznostzmeny

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 
-- p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_014/0000327'

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC , zoz."Poøadové èíslo ®oZ" ASC
