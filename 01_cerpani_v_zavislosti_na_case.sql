SELECT SUBSTR(p.kodprioritniosa, 4) AS "PO"
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       TO_CHAR(platba."Datum proplacení pøíjemci", 'YYYY-MM') AS  "Mìsíc proplacení",
       sum(rf.CASTKASCHVALENA) Proplaceno

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel =  361356  -- øádky cis."Kód" in ('10a') 

WHERE platba.kodwfstav in ('P10','P11')
AND p."Registraèní èíslo projektu" is not null
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
-- AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'
-- AND platba.id = 157622762
AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_002/0000026'

GROUP BY SUBSTR(p.kompetencniutvar, 6),
      TO_CHAR(platba."Datum proplacení pøíjemci", 'YYYY-MM'),
      SUBSTR(p.kodprioritniosa, 4)

ORDER BY SUBSTR(p.kodprioritniosa, 4), SUBSTR(p.kompetencniutvar, 6), TO_CHAR(platba."Datum proplacení pøíjemci", 'YYYY-MM')


---------------------------------
SELECT 
--- ltrim(TO_CHAR(platba."Datum proplacení pøíjemci",'yyyy-mm'),'0')  
-- DATEADD(MONTH, DATEDIFF(MONTH, 0, platba."Datum proplacení pøíjemci"), 0)

FROM isum.v_bi_UmpPlatbaPrj platba

WHERE  platba.id = 157622762


