SELECT -- p."Registraèní èíslo projektu"
       CASE WHEN p.kodkompetence = '0101' THEN '111'
       	    WHEN p.kodkompetence = '0102' THEN '112'
 	    WHEN p.kodkompetence = '0103' THEN '113'
 	    WHEN p.kodkompetence = '0105' THEN '121'
 	    WHEN p.kodkompetence = '0106' THEN '122'
 	    WHEN p.kodkompetence = '0107' THEN '123'
 	    WHEN p.kodkompetence = '0108' THEN '124'
 	    WHEN p.kodkompetence = '0109' THEN '125'
 	    WHEN p.kodkompetence = '0110' THEN '211'
 	    WHEN p.kodkompetence = '0111' THEN '214'
 	    WHEN p.kodkompetence = '0112' THEN '221'
 	    WHEN p.kodkompetence = '0113' THEN '231'
 	    WHEN p.kodkompetence = '0114' THEN '241'
 	    WHEN p.kodkompetence = '0115' THEN '311'
 	    WHEN p.kodkompetence = '0116' THEN '321'
 	    WHEN p.kodkompetence = '0118' THEN '331'
 	    WHEN p.kodkompetence = '0120' THEN '341'
 	    WHEN p.kodkompetence = '0117' THEN '351'
 	    WHEN p.kodkompetence = '0119' THEN '361'
	    WHEN p.kodkompetence = '0121' THEN '411'
	    WHEN p.kodkompetence = '0122' THEN '422'
	    WHEN p.kodkompetence = '0123' THEN '511 nebo 512'
	    ELSE 'chybí'
	    END "Kód programu",
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
       platba."Èíslo ¾ádosti o platbu" ,
       p.zadatel "Pøíjemce dotace" ,
       rf.CASTKASCHVALENA "Èástka (Kè)" 
       -- platba."Datum zmìny stavu" ,
       -- (SELECT dentydne FROM isum.v_bi_UmsKalendar WHERE trunc(datum) = trunc(current_date)) "Den tydne"
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND platba.kodwfstav in ('P6T','P14T','P9T') 

 -- pokud út-pátek, jen pøedchozí den, pokud podnìlí, pak pá-ne, v so-ne negeneruj nic
AND (
      (
      (SELECT dentydne FROM isum.v_bi_UmsKalendar WHERE trunc(datum) = trunc(current_date)) IN (2,3,4,5)  AND platba."Datum zmìny stavu" BETWEEN trunc(current_date-1) AND trunc(current_date)
      )
      OR
      (	
      (SELECT dentydne FROM isum.v_bi_UmsKalendar WHERE trunc(datum) = trunc(current_date)) = 1  AND platba."Datum zmìny stavu" BETWEEN trunc(current_date-3) AND trunc(current_date)
      )
    )
-- AND p."Registraèní èíslo projektu" = 'CZ.01.2.111/0.0/0.0/15_023/0005664'
