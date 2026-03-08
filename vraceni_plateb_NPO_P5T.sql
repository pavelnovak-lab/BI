SELECT SUBSTR(p.kompetencniutvar, 9) AS "Komponenta NPO" ,
       -- sum( CASE WHEN platba.kodwfstav IN ('P6T','P10','P11') then 1
       -- 	    ELSE 0 END 
       -- 	   ) AS "Proplaceno",
       -- sum( CASE WHEN platba.kodwfstav not IN ('P6T','P10','P11') then 1
       -- 	    ELSE 0 END 
       -- 	   ) AS "Neproplaceno",
       
       -- count(apfm.pocet) "Poèet vrácení z AP -> API" 
       platba."Èíslo ¾ádosti o platbu" ,
       platba.kodwfstav,
       apfm.pocet "Poèet pøepnutí P5T -> P4",
       apfm.posldatum "Datum posledního pøepnutí"



FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
-- INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- øádky cis.
LEFT JOIN (SELECT NositelId,
     	  	  count(id) pocet,
		  max(datumod) posldatum ,
 		  min(datumod) prvnidatum
     	   FROM isum.v_bi_UmsWFHistorieStavu
	   WHERE stavz IN ('P5T')
	   AND stavdo = 'P4'
	   GROUP BY Nositelid ) apfm ON  apfm.NositelId = platba.id 
-- LEFT JOIN (SELECT count(id) pocet,
     	  	  
--      	   FROM isum.v_bi_UmzProjekt p 
-- 	   WHERE kodwfstav 



WHERE p.KodPrioritniOsa in ( '31.2', '31.3', '31.5') 
OR (p.KodPrioritniOsa = '31.1' AND v."Èíslo výzvy" IN ('31_22_011','31_22_013','31_23_070','31_23_076'))

ORDER BY platba."Èíslo ¾ádosti o platbu"
AND platba."Èíslo ¾ádosti o platbu" is not null 
