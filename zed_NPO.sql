SELECT p."Registraèní èíslo projektu" ,
       p.zed,
       p.akcezed,
       SUBSTR(p.kompetencniutvar, 10) AS "Program podpory",
       ci."Kód" ,
       p.kodwfstav ,
       p.KodPrioritniOsa "Prioritní osa",
       hs.datumod "Datum PP29",
       p.exportzed
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  p.ID_AGRAKCEZED
LEFT JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND hs.stavdo = 'PP29'

WHERE p."Registraèní èíslo projektu" like 'CZ.31.4%'
-- AND p.zed in ('A')
-- AND p.akcezed is null
-- AND p.kodwfstav IN 'PP29'


----------------------------------------

SELECT p."Registraèní èíslo projektu" ,
       p.kodwfstav "Stav projektu" ,
       platba."Èíslo ¾ádosti o platbu" ,
       platba."Úprava/zamítnutí ¾ádosti o pla",
       platba."Závìreèná platba" ,
       platba.kodwfstav
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby

WHERE UPPER(platba."Úprava/zamítnutí ¾ádosti o pla") like '%Z®OP'
AND p.KodPrioritniOsa in ('01.1','01.2') 
-- AND platba."Èíslo ¾ádosti o platbu" = 'CZ.01.2.06/0.0/0.0/16_005/0000003/2017/009/POST'
