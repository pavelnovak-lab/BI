SELECT v."Číslo výzvy" ,
       v."Název výzvy" ,
       hsv."Datum přepnutí" ,
       vwf."Název" ,
       hsv."Změnil/a"
FROM vyzva v
INNER JOIN (SELECT *,
            ROW_NUMBER() OVER (
	    PARTITION BY nositelid
	    ORDER BY nositelid , "Datum přepnutí"  DESC
	    ) AS rn      
      	    FROM historie_stavu  
	    ORDER BY "Datum přepnutí" DESC
	    ) hsv ON hsv.NositelId = v.id 
INNER JOIN ciselnik_stav_workflow vwf ON vwf.id = hsv.id_stavdo


WHERE v."Číslo výzvy" in ('01_22_002', '01_23_013', '01_23_027', '01_24_046', '01_24_056', '01_24_062', '01_24_063', '01_25_067')
AND hsv.rn <=4

ORDER BY v."Číslo výzvy" 
