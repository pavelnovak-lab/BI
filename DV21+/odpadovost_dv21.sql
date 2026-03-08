SELECT p."Registrační číslo projektu",
       p."Datum prvního podání",
       p."Datum změny stavu",
       w."Kód" ,
       pf."Příspěvek Unie",
       /* Podmínka vezme maximální (poslední)  stav daný měsíc, pokud jsme s intervalem moc vepředu, tak null, pokud moc vzadu, tak aktuální stav */
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2022-09-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2022-09-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2022-10-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 09-22",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2022-10-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2022-10-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2022-11-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 10-22",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2022-11-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2022-11-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2022-12-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 11-22",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2022-12-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2022-12-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2023-01-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 12-22",

       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2023-01-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2023-01-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2023-02-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 01-23",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2023-02-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2023-02-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2023-03-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 02-23",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2023-03-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2023-03-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2023-04-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 03-23",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2023-04-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2023-04-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2023-05-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 04-23",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2023-06-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2023-05-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2023-06-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 05-23",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2023-06-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2023-06-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2023-07-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 06-23",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2023-07-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2023-07-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2023-08-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 07-23",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2023-08-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2023-08-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2023-09-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 08-23",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2023-09-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2023-09-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2023-10-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 09-23",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2023-10-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2023-10-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2023-11-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 10-23",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2023-11-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2023-11-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2023-12-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 11-23",
       CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2023-12-01 00:00:00') THEN w."Kód" 
       	    ELSE ( MAX(CASE WHEN hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2023-12-01 00:00:00')
       		 	  AND hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2024-01-01 00:00:00') THEN sw."Kód" 
 		 	  ELSE NULL END) )
            END AS "stav 12-23"

FROM projekt p
INNER JOIN historie_stavu hs on hs.nositelid = p.id
INNER JOIN ciselnik_stav_workflow sw on sw.id = hs.id_stavdo
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id	
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 

where p."Registrační číslo projektu" is not null
AND id_vyzva = 19421537 -- úspory energie 01_22_006

GROUP BY p."Registrační číslo projektu" ,
       p."Datum prvního podání",
       p."Datum změny stavu",
       w."Kód" ,
       pf."Příspěvek Unie" 



----------------------------------------

SELect p."Datum změny stavu" ,
       	hs."Datum změny",
       sw."Kód"
       -- CASE WHEN p."Datum změny stavu" < to_date('yyyy-MM-dd HH:mm:ss','2023-03-01 00:00:00') THEN w."Kód" 
       -- 	    ELSE ( LAST(CASE WHEN
       -- 	    	   	    -- hs."Datum změny" >= to_date('yyyy-MM-dd HH:mm:ss','2023-03-01 00:00:00')
       -- 		 	    -- AND
       -- 			    hs."Datum změny" < to_date('yyyy-MM-dd HH:mm:ss','2023-04-01 00:00:00') THEN sw."Kód" 
       -- 		 	  ELSE NULL END) )
       --      END AS "stav 03-23"

FROM projekt p
INNER JOIN historie_stavu hs on hs.nositelid = p.id
INNER JOIN ciselnik_stav_workflow sw on sw.id = hs.id_stavdo
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id

where p."Registrační číslo projektu" = 'CZ.01.04.01/01/22_006/0001005'

GROUP BY p."Registrační číslo projektu" ,
       p."Datum prvního podání",
       p."Datum změny stavu",
       w."Kód" ,
       -- pf."Příspěvek Unie" 
       hs."Datum změny",
       sw."Kód",
       p."Datum změny stavu"


ORDER BY hs."Datum změny" 


----------------------------------------
SELECT hs."Datum změny",
       FORMATDATE(FLOOR(hs."Datum změny" TO MONTH), 'YY-MM') AS Month,
       sw."Kód"

FROM projekt p
INNER JOIN historie_stavu hs on hs.nositelid = p.id
INNER JOIN ciselnik_stav_workflow sw on sw.id = hs.id_stavdo
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id

where p."Registrační číslo projektu" = 'CZ.01.04.01/01/22_006/0001005'

-- GROUP BY 
--  p."Registrační číslo projektu" ,
--        p."Datum prvního podání",
--        p."Datum změny stavu",
--        w."Kód" ,
        
--        hs."Datum změny",
--        sw."Kód",
--        p."Datum změny stavu" 
       
ORDER BY hs."Datum změny" 

----------------------------------------


WITH MissingMonths AS (
  SELECT
    TO_CHAR(FLOOR(month_date TO MONTH), 'YY-MM') AS Month,
    LAG(Kód) OVER (ORDER BY month_date) AS LastKód
  FROM (
    SELECT
      TO_DATE(TO_CHAR(
        SERIES_START(TO_TIMESTAMP(MIN(Datum), 'YYYY-MM-DD')),
        'YYYY-MM-01'
      ), 'YYYY-MM-01') AS month_date
    FROM kody
  ) AS months
  LEFT JOIN kody t ON FLOOR(month_date TO MONTH) = FLOOR(t.Datum TO MONTH)
)
SELECT Month, COALESCE(LastKód, 'N/A') AS Kód
FROM MissingMonths
ORDER BY Month;
