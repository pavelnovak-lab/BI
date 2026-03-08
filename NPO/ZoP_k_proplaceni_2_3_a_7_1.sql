SELECT v."Číslo výzvy", 
       p."Registrační číslo projektu" ,
       p.zed,
       p.zadatel,
       p."IČ",
       platba."Číslo žádosti o platbu" ,
       p.akcezed,
       p.EXPORTZED,
       ci."Název",
       ci."Kód" ,
       p.kodwfstav,
       p.wfstavdatum "Daum změny stavu projektu", 
       platba."PORADI#Pořadí finančního plánu" ,
       platba.kodwfstav  "Stav ŽoP" ,
       platba."Datum změny stavu" "Datum změny stavu ŽoP" ,
       rf.CASTKASCHVALENA "Částka schválená" ,
       platba."Datum proplacení příjemci" ,
       LISTAGG( substr(dp.REGCISLO, -7, 7), ', ') "Detail platby",
       LISTAGG( DISTINCT zdroj."Kód", '; ') "Zdroj SR Kód",
       LISTAGG( DISTINCT zdroj."Název", '; ') "Zdroj SR" ,
       -- SUBSTR(p.kompetencniutvar, 6) "Komponenta NPO",
       -- hs.datumod,
       -- p."Bude se pořizovat EDSSMVS" EDS
       platba."Datum změny stavu",
       CASE WHEN (v."Číslo výzvy" IN ('31_22_001','31_22_005') AND platba."PORADI#Pořadí finančního plánu" not like '9%' AND zdroj."Kód" = '1517071') THEN 'Fotovoltaika, komp. 7.1'
       	    WHEN (v."Číslo výzvy" IN ('31_22_001','31_22_005') AND platba."PORADI#Pořadí finančního plánu" like '9%') THEN 'Doplatková ŽoP'
       	    WHEN (v."Číslo výzvy" IN ('31_22_006') AND zdroj."Kód" = '4517023') THEN 'Distribuce tepla, komp. 2.3'
	    WHEN (v."Číslo výzvy" IN ('31_23_116') AND zdroj."Kód" = '1517071') THEN 'Distribuční sítě, komp. 7.1'
	    ELSE 'Špatný zdroj' END AS "Zdroj v DP" 

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  p.ID_AGRAKCEZED
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
LEFT JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in (361356) -- XX, YY, 10a
LEFT JOIN isum.v_bi_umpklasifikace dp ON dp.id_platba = platba.id AND dp.druhdp = 1
INNER JOIN isum.v_bi_UmsCisZakladni zdroj ON zdroj.id = dp.id_zdroj

WHERE platba.SOUCTOVYRADEK is null 
AND v."Číslo výzvy" IN ('31_22_001','31_22_005','31_22_006','31_23_116')
AND p."Registrační číslo projektu" is not null 

AND platba.kodwfstav in ('P6','P9')
AND
(
      (
      (SELECT dentydne FROM isum.v_bi_UmsKalendar WHERE trunc(datum) = trunc(current_date)) IN (2,3,4,5)  AND platba."Datum změny stavu" BETWEEN trunc(current_date-1) AND trunc(current_date)
      )
      OR
      (	
      (SELECT dentydne FROM isum.v_bi_UmsKalendar WHERE trunc(datum) = trunc(current_date)) in ( 1, 6, 7)  AND platba."Datum změny stavu" BETWEEN trunc(current_date-7) AND trunc(current_date)
      )
    )

AND p.akcezed is not null  

GROUP BY v."Číslo výzvy", 
	p."Registrační číslo projektu" ,
       p.zed,
       p.akcezed,
       p.EXPORTZED,
       ci."Název",
       ci."Kód" ,
       p.kodwfstav,
       p.wfstavdatum , 
       platba."PORADI#Pořadí finančního plánu" ,
       platba.kodwfstav   ,
       platba."Datum změny stavu"  ,
       rf.CASTKASCHVALENA  ,
       platba."Datum proplacení příjemci" ,
       p.zadatel,
       p."IČ" ,
       platba."Číslo žádosti o platbu" ,
       zdroj."Kód",
       CASE WHEN (v."Číslo výzvy" IN ('31_22_001','31_22_005') AND platba."PORADI#Pořadí finančního plánu" not like '9%' AND zdroj."Kód" = '1517071') THEN 'Fotovoltaika, komp. 7.1'

       	    WHEN (v."Číslo výzvy" IN ('31_22_001','31_22_005') AND platba."PORADI#Pořadí finančního plánu" like '9%') THEN 'Doplatková ŽoP'
       	    WHEN (v."Číslo výzvy" IN ('31_22_006') AND zdroj."Kód" = '4517023') THEN 'Distribuce tepla, komp. 2.3'
	    WHEN (v."Číslo výzvy" IN ('31_23_116') AND zdroj."Kód" = '1517071') THEN 'Distribuční sítě, komp. 7.1'
	    ELSE 'Špatný zdroj' END 
       
ORDER BY platba."Datum změny stavu" DESC
