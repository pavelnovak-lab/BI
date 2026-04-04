SELECT p."Registrační číslo projektu",
       p."Název projektu CZ",
       p.kodwfstav,
       p.wfstavdatum,
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
       gg.czv,
       p."Datum ukončení předp",
       p."Datum ukončení skut",       		
       gg.eu "Příspěvek unie",
       v."Název výzvy" ,
       v."Číslo výzvy" ,
       sch.schvaleno,
       listagg(DISTINCT uk."Název",'; ') "Kraj realizace"
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzPrjGG gg ON gg.id=p.id
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmzPrjUmisteniKraj	uk ON uk.id_projekt = p.id AND uk.typ = 'Realizace'
LEFT JOIN
(SELECT	p.id,
	sum(castky.castkaschvalena) AS schvaleno
FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpRozpisFinPrj castky ON castky.id_platba = platba.id AND castky.poradi = '11'
WHERE p."Registrační číslo projektu" is not null
AND p.kodwfstav in ('PP36','PP37','PP40','PP41','PP42','PP43','PN40a','PN40b') 
GROUP BY p.id) sch ON sch.id = p.id

WHERE p."Registrační číslo projektu" is not null 
-- 'CZ.01.1.02/0.0/0.0/16_084/0010284'

GROUP BY p."Registrační číslo projektu",
       p."Název projektu CZ",
       p.kodwfstav,
       p.wfstavdatum,
       p.kompetencniutvar, 
       gg.czv,
       p."Datum ukončení předp",
       p."Datum ukončení skut",       		
       gg.eu,
       v."Název výzvy" ,
       v."Číslo výzvy" ,
       sch.schvaleno
