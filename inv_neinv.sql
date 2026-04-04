SELECT p."Registrační číslo projektu",
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
       substr(p."Registrační číslo projektu",-5,5) "Projekt" ,
       p.zadatel,
       p."Název projektu CZ",
       v."Číslo výzvy",
       -- v."Název výzvy" ,
       platba."Datum proplacení příjemci",
       platba."Číslo žádosti o platbu" ,
       -- ci."Název" ,
       -- sr."Kód" "Kód SR",
       -- eds."Identifikační číslo akce" ,
       p."Bude se pořizovat EDSSMVS" ,
       platba.id "id_platba",
       p.id "id_projektu" ,
       v.id "id_vyzva"
       
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id = p.id_vyzva 

INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id = platba.id_NositelPlatby 
-- INNER JOIN (
--       SELECT max("Identifikační číslo akce") "Identifikační číslo akce",
--       	     id_nositelispeproj
--       FROM isum.v_bi_UMZISPeProjekt
--       -- WHERE id_nositelispeproj = 1210316800
--       GROUP BY id_nositelispeproj ) eds ON eds.id_nositelispeproj = p.id
      


WHERE  p.kodwfstav in ('PP37','PP40','PP41','PP42','PP43','PU30')
   AND v."Číslo výzvy" = '01_20_370'
-- AND EXISTS
-- (SELECT 1
--  FROM isum.v_bi_UMFROZSkupinaPol polozka
--  WHERE polozka."Investice" = 0
--  AND polozka.id_predpis = sr.id)
AND to_date('2021-12-31','yyyy-mm-dd') < platba."Datum proplacení příjemci"
AND platba."Datum proplacení příjemci" < to_date('2023-01-01','yyyy-mm-dd')  
AND platba.kodwfstav in ('P10','P11')
AND p."Bude se pořizovat EDSSMVS" 

--------------------------------------------

SELECT DISTINCT 1 "Neinv", 
	-- sr.id
	md.id_vyzva
 FROM isum.v_bi_UMZVyzvaMD md -- ON md.id_vyzva= v.id  AND md."Platnost" = 'A' -- AND md.id_cisseznam = 198427 -- skupina rozpočtu
 INNER JOIN isum.v_bi_UMFROZSkupina sr ON sr.id = md.id_ciszakladni
 INNER JOIN isum.v_bi_UMFROZSkupinaPol polozka ON polozka.id_predpis = sr.id

WHERE polozka."Investice" = 0
AND md."Platnost" = 'A'

--------------------------------------------

SELECT max("Identifikační číslo akce") "Identifikační číslo akce",
       id_nositelispeproj
FROM isum.v_bi_UMZISPeProjekt
-- WHERE id_nositelispeproj = 1210316800
GROUP BY id_nositelispeproj

) eds ON eds.id_nositelispeproj = p.id
