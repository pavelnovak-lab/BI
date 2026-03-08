SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       platba."Èíslo ¾ádosti o platbu" ,
       platba.kodwfstav,
       apfm.pocet "Poèet vrácení z AP -> API" ,
       fmiskp.pocet "Poèet vrácení do ISKP",
       rafap.pocet "Poèet vrácení z EIS",
       pcoap.pocet "Poèet vrácení z PCO"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
LEFT JOIN (SELECT NositelId,
     	  	  count(id) pocet
     	   FROM isum.v_bi_UmsWFHistorieStavu
	   WHERE stavz IN ('P6','P5T')
	   AND stavdo = 'P4'
	   GROUP BY Nositelid ) apfm ON  apfm.NositelId = platba.id 
LEFT JOIN (SELECT NositelId,
     	  	  count(id) pocet
     	   FROM isum.v_bi_UmsWFHistorieStavu
	   WHERE stavz IN ('P4')
	   AND stavdo = 'N0'
	   GROUP BY Nositelid ) fmiskp ON  fmiskp.NositelId = platba.id 
LEFT JOIN (SELECT NositelId,
     	  	  count(id) pocet
     	   FROM isum.v_bi_UmsWFHistorieStavu
	   WHERE stavz IN ('P6T','P9T')
	   AND stavdo = 'P7'
	   GROUP BY Nositelid ) rafap ON  rafap.NositelId = platba.id 
LEFT JOIN (SELECT NositelId,
     	  	  count(id) pocet
     	   FROM isum.v_bi_UmsWFHistorieStavu
	   WHERE stavz IN ('P10','P11')
	   AND stavdo = 'P12'
	   GROUP BY Nositelid ) pcoap ON  pcoap.NositelId = platba.id 

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND platba.kodwfstav IN ('P10','P11')
-- AND fmiskp.pocet > 0 AND apfm.pocet >0
AND (rafap.pocet  > 0 OR pcoap.pocet > 0)
