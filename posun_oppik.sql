SELECT
	-- sum(rf.CASTKASCHVALENA) "Dosud proplaceno" ,
       p."Registraèní èíslo projektu",
       p.kodwfstav,
       p.zadatel,
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
       p."Datum ukonèení pøedp" ,
       gg.eu,
       gg.czv
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN Isum.v_bi_umzprjgg gg ON gg.id=p.id  
-- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.kodwfstav in ('P10','P11')
-- INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- øádky 10a   
 
WHERE p.kodwfstav like ('PP%')
AND trunc(p."Datum ukonèení pøedp") >= to_date('2023-10-01','yyyy-mm-dd')
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 


-- GROUP BY p."Registraèní èíslo projektu",
--        p.kodwfstav,
--        SUBSTR(p.kompetencniutvar, 6) ,
--        p."Datum ukonèení pøedp" ,
--        gg.eu,
--        gg.czv,
--        p.zadatel 
