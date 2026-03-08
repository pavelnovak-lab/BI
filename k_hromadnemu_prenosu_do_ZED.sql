SELECT p."Registraèní èíslo projektu",
       p."Název projektu CZ" ,
       p."Bude se poøizovat EDSSMVS",
       p.akcezed,
       p.kodwfstav,
       p.wfstavdatum,
       v."Název výzvy" ,
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" 

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 

WHERE p."Registraèní èíslo projektu" is not null
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PU30','PN40a','PN40b') 

MINUS

SELECT DISTINCT p."Registraèní èíslo projektu",
       p."Název projektu CZ",
       p."Bude se poøizovat EDSSMVS",
       p.akcezed,
       p.kodwfstav,
       p.wfstavdatum,
       v."Název výzvy" ,
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" 


FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 

WHERE p."Registraèní èíslo projektu" is not null
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND (
 p."Bude se poøizovat EDSSMVS" = 'A'
 OR p.akcezed is not null 
 OR (p.wfstavdatum < to_date('2022-01-01','yyyy-mm-dd') AND p.kodwfstav like 'PN%' )
 OR (hs.stavdo = 'PP41' AND hs.datumod < to_date('2022-01-01','yyyy-mm-dd'))
 OR p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/16_049/0009993'  -- Vanèník, check EDS ano, je to omyl
 )
