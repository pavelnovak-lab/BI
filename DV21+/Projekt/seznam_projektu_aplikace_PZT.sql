CREATE or REPLACE view "projekty-konverze-sablony_wf" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Projekty' AS 

SELECT v."Číslo výzvy" ,
	v."Název výzvy" ,
 	v."Datum ukončení příjmu žádostí o podporu",  
	p."Identifikace žádosti (hash)" , 
	p."Registrační číslo projektu" ,
 	w."Kód" "Stav projektu" ,
	p.id "ID projektu" 


FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN ciselnik_stav_workflow wv ON v.id_wfstav = wv.id  

WHERE (
    ( p."Registrační číslo projektu" IS NOT NULL 
    v."Číslo výzvy" IN ('01_22_002', '01_23_013', '01_23_027', '01_24_046',  '01_24_062', '01_24_063', '01_25_067')
    AND w."Kód" REGEXP_LIKE 'P[PU][23][0-6][ab]?|Z[1-4]|PP40' 
    )
    OR
    (v."Číslo výzvy" = '01_24_056')
    )


ORDER BY v."Číslo výzvy" 

