SELECT p."Registraèní èíslo projektu" ,
       p.kodwfstav ,
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
       re."Míst realizace"


FROM isum.v_bi_UmzProjekt p 
LEFT JOIN (SELECT count(uk."Název") as "Míst realizace",
	p.id
FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmzPrjUmisteniKraj uk ON uk.id_projekt = p.id
WHERE uk.typ = 'Realizace'
GROUP BY p.id) re ON re.id = p.id

-- LEFT JOIN (SELECT listagg(uk."Název", '; ') as dopad,
-- 	p.id
-- FROM isum.v_bi_UmzPrjGGII p
-- INNER JOIN isum.v_bi_UmzPrjUmisteniKraj uk ON uk.id_projekt = p.id
-- WHERE uk.typ = 'Dopad'
-- GROUP BY p.id) do ON do.id = p.id

WHERE  p."Registraèní èíslo projektu" is not null 
-- AND (do.dopad is null or re.realizace is null)

AND re."Míst realizace" > 5
AND re."Míst realizace" < 13

AND SUBSTR(p.kompetencniutvar, 6 ) not like 'Technická pomoc'



SELECT count(p."Registraèní èíslo projektu"),
       -- p.kodwfstav,
       -- p."Liniová stavba",
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" 
       
FROM isum.v_bi_UmzProjekt p

WHERE p."Registraèní èíslo projektu" is not null
AND p.kodwfstav like 'PP%'
AND p."Liniová stavba" = 'A'

GROUP BY p."Registraèní èíslo projektu",
       p.kodwfstav,
       p."Liniová stavba"
