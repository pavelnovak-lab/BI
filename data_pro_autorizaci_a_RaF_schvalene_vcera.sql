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
       rf.CASTKASCHVALENA "Èástka (Kè)",
       CASE WHEN pril."Název pøíloh" is not null then 'Ano'
       	    ELSE 'Ne' END AS "Rozhodnutí ministra" ,
       hs.datumod "Datum zmìny stavu" ,
       platba.kodwfstav 
       -- (SELECT dentydne FROM isum.v_bi_UmsKalendar WHERE trunc(datum) = trunc(current_date)) "Den tydne"
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = platba.id
LEFT JOIN (
     SELECT LISTAGG( priloha.nazevpril, '; ') "Název pøíloh" ,
	    priloha.id_nositelpril
     FROM isum.v_bi_UMSPrilohyPlatba priloha
     WHERE UPPER(priloha.nazevpril) like '%MINISTR%'
     GROUP BY priloha.id_nositelpril) pril ON pril.id_nositelpril = platba.id

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND hs.stavdo in ('P6T','P14T','P9T') 

AND platba."Èíslo ¾ádosti o platbu" = 'CZ.01.2.06/0.0/0.0/20_322/0024151/2024/002/POST'

-- pokud út-pátek, jen pøedchozí den, pokud podnìlí, pak pá-ne, v so-ne negeneruj nic
AND (
      (
      (SELECT dentydne FROM isum.v_bi_UmsKalendar WHERE trunc(datum) = trunc(current_date)) IN (2,3,4,5)  AND hs.datumod BETWEEN trunc(current_date-1) AND trunc(current_date)
      )
      OR
      (	
      (SELECT dentydne FROM isum.v_bi_UmsKalendar WHERE trunc(datum) = trunc(current_date)) in ( 1, 6, 7)  AND hs.datumod BETWEEN trunc(current_date-3) AND trunc(current_date)
      )
    )


----------------------------------------
SELECT p."Registraèní èíslo projektu" ,
       p.zed,
       p.akcezed,
       SUBSTR(p.kompetencniutvar, 10) AS "Program podpory",
       ci."Kód" ,
       p.kodwfstav ,
       p.KodPrioritniOsa "Prioritní osa",
       hs.datumod "Datum PP29",
       p.exportzed
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  p.ID_AGRAKCEZED
LEFT JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND hs.stavdo = 'PP29'

WHERE p."Registraèní èíslo projektu" like 'CZ.31.%'
AND  p."Registraèní èíslo projektu" not like 'CZ.31.6%'
AND p.zed in ('A')
AND p.akcezed is not null
AND p.akcezed like 'Z1%'
-- AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PU30')
