SELECT SUBSTR(p.kodprioritniosa,4) "PO", 
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
       max(rf.CASTKAPRAVNIAKT) - sum(rf.CASTKASCHVALENA) "Rozdíl RoPD a proplaceno"
       
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356 -- øádky 10a   

WHERE p."Registraèní èíslo projektu" is not null
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 
AND platba.kodwfstav in ('P11','P10')
-- AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43') 
AND p.kodwfstav in ('PP41','PP42','PP43') 
-- AND rf.CASTKASCHVALENA > 0
AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_002/0000026'

GROUP BY SUBSTR(p.kodprioritniosa,4), 
       SUBSTR(p.kompetencniutvar, 6)

ORDER BY SUBSTR(p.kodprioritniosa,4), 
       SUBSTR(p.kompetencniutvar, 6)


--------------------------------------------
SELECT SUBSTR(p.kodprioritniosa,4) "PO", 
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
       sum(castky.FMDOTACECELK) "Kráceno o"
       
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UMPCastky castky ON castky.id = platba.id_rozdilkorekce

WHERE p."Registraèní èíslo projektu" is not null
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 
AND platba.kodwfstav in ('P11')
AND p.kodwfstav in ('PP30','PP36','PP37','PP40') 
-- AND p.kodwfstav in ('PP41','PP42','PP43') 
-- AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_002/0000026'

GROUP BY SUBSTR(p.kodprioritniosa,4), 
       SUBSTR(p.kompetencniutvar, 6)

ORDER BY SUBSTR(p.kodprioritniosa,4), 
       SUBSTR(p.kompetencniutvar, 6)


-- WHERE castky.id = 169445401
-- platba.id = 157622762

