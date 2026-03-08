SELECT p."Registraèní èíslo projektu" ,
       p.zed,
       p.akcezed,
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
       ci."Kód" ,
       p.kodwfstav ,
       p.KodPrioritniOsa "Prioritní osa",
       hs.datumod "Datum PP29"
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  p.ID_AGRAKCEZED
LEFT JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND hs.stavdo = 'PP29'

WHERE p."Registraèní èíslo projektu" is not null 
AND p.zed in ('A')
AND p.akcezed is not null
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND SUBSTR(p.kompetencniutvar, 6) not IN ('Potenciál', 'Aplikace', 'Partnerství znalostního transferu', 'Spolupráce', 'Proof of Concept')
