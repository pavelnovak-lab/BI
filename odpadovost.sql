SELECT SUBSTR(p.kodprioritniosa,4) "PO", 
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       sum(eu.eu) "Celkem v RoPD",
       sum(eu.proplaceno) "Celkem proplaceno" ,
       sum(eu.eu) - sum(eu.proplaceno) "Rozdíl"

FROM isum.v_bi_UmzProjekt p
INNER JOIN (
 SELECT p.eu, 
 	sum(rf.CASTKASCHVALENA) proplaceno,
	p.id
 FROM isum.v_bi_UmzPrjGG p 
 INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
 INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356 -- řádky 10a   

 WHERE p."Registrační číslo projektu" is not null
 AND platba.kodwfstav in ('P11','P10')
 AND p.kodwfstav in ('PP41','PP42','PP43')

 GROUP BY p.id, p.eu
 ) eu ON eu.id = p.id

WHERE p."Registrační číslo projektu" is not null
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND p.kodwfstav in ('PP41','PP42','PP43') 
AND p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/15_014/0000327','CZ.01.1.02/0.0/0.0/16_049/0008770')

GROUP BY SUBSTR(p.kodprioritniosa,4), 
       SUBSTR(p.kompetencniutvar, 6)

ORDER BY SUBSTR(p.kodprioritniosa,4), 
       SUBSTR(p.kompetencniutvar, 6)


