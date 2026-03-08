SELECT	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	p."Registraèní èíslo projektu" ,
	p.zadatel ,
	p.kodwfstav ,
	platba."PORADI#Poøadí finanèního plánu" "Poøadí ®oP",
	platba."Èíslo ¾ádosti o platbu" ,
	platba.kodwfstav "Stav ®oP" ,
	rf.castkaaktual "Po¾adovaná dotace",
	rf.CASTKASCHVALENA "Schválená dotace" ,
	platba."Datum zmìny stavu" "Datum stavu WF ®oP" ,
	p5.pocet "Poèet prùchodù P5T nebo P8T",
	p5.datum "Datumy prùchodù P5T, P8T"
	
	
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- XX, YY, 10a, ZZ
LEFT JOIN (SELECT count(hs.id) pocet,
     	  	  LISTAGG(TO_CHAR( hs.datumod,'dd. MM. yyyy'), '; ') datum ,
     	  	  hs.NositelId
     	   from isum.v_bi_UmsWFHistorieStavu hs
	   WHERE hs.stavdo IN ('P5T','P8T') 
	   GROUP BY hs.NositelId ) p5 ON p5.NositelId = platba.id 

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND platba.kodwfstav IN ('N1','N2')
