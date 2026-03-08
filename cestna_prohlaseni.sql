SELECT	p."Registraèní èíslo projektu",
       	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
       	p.kodwfstav,
       	ci."Název" ,
       ci."Kód",
       ct.HOP
       
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UMZZIProjekt zi ON zi.id_zad = p.id
INNER JOIN isum.v_bi_UMZCisTypZI ct ON ct.id = zi.id_CisTypZI

INNER JOIN ISUM.v_bi_UMSCestProhlas cp ON cp.id_NosCestProhl = zi.id
INNER JOIN isum.v_bi_UmsCisZakladni ci ON cp.id_Cestprohlaseni = ci.id

WHERE p."Registraèní èíslo projektu" is not null
-- AND ci."Kód" = 101
-- AND cp = 1207928918
AND p."Registraèní èíslo projektu" = 'CZ.01.3.10/0.0/0.0/15_010/0003175'
AND ct.hop = 'ZoU'


ORDER BY p."Registraèní èíslo projektu" 
