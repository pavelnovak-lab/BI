SELECT platba."Číslo žádosti o platbu" ,
       min(hs.datumod) poprve_v_P4,
       nvl(v.pocet, 0) "Počet vrácení do ISKP",
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" 

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = platba.id 
LEFT JOIN (SELECT count(hs.datumod) pocet,
     	  	  platba."Číslo žádosti o platbu" ,
     	  	  platba.id
	   FROM isum.v_bi_UmpPlatbaPrj platba
	   INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = platba.id 
           WHERE hs.stavdo = 'N0'
	   AND platba."Číslo žádosti o platbu" like 'CZ.01.%'
	   AND platba."Číslo žádosti o platbu" = 'CZ.01.3.43/0.0/0.0/17_097/0009899/2023/004/POST'
	   GROUP BY platba.id, platba."Číslo žádosti o platbu"  ) v ON v.id = platba.id

WHERE hs."Unikátní kód stavu do" = 'F1_P4'
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND platba."Číslo žádosti o platbu" is not null
AND platba."Číslo žádosti o platbu" = 'CZ.01.3.43/0.0/0.0/17_097/0009899/2023/004/POST'

GROUP BY platba."Číslo žádosti o platbu", v.pocet, SUBSTR(p.kompetencniutvar, 6)

ORDER BY v.pocet DESC 
