SELECT v."Èíslo výzvy" ,
       v."Název výzvy",
       CASE WHEN v."Druh výzvy" = 0 THEN 'Kolová'
       	    WHEN v."Druh výzvy" = 1 THEN 'Prùbì¾ná'
	    END "Druh výzvy",
       wv."Název" "Stav výzvy", 
       sk."Název souboru kritérií",
       pp.pocet "Poèet projektù",       
       -- p."Registraèní èíslo projektu" ,
       -- w."Kód" "Kód stavu" ,
       -- h."Výsledek (v bodech)",
       sum(CASE WHEN h."Finalizováno" = 'A' THEN 1
       	    ELSE 0 END ) "Poèet zalo¾ených posudkù",
       sum(CASE WHEN h."Finalizováno" = 'A' THEN 1
       	    ELSE 0 END ) "Poèet finalizovaných posudkù",
       sum(CASE WHEN h."Schváleno schvalovatelem" = 'A' THEN 1
       	    ELSE 0 END) "Poèet schválených posudkù"

              
	      
FROM vyzva v 
INNER JOIN soubor_kriterii_vyzvy skv ON skv.id_vyzva = v.id
INNER JOIN soubor_kriterii sk ON sk.id = skv.id_souborkrit
INNER JOIN projekt p ON p.id_vyzva = v.id AND p."Registraèní èíslo projektu" is not null 
INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id AND h.id_souborkrit = sk.id AND h.id_hodnotitel > 0 -- AND h.id_statushodn = 488649 -- nevyhovìl 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN ciselnik_stav_workflow wv ON v.id_wfstav = wv.id  
LEFT JOIN (SELECT count(p.id) pocet,
     	  	  v.id
 	   FROM projekt p
	   INNER JOIN vyzva v ON v.id = p.id_vyzva
	   WHERE v."Èíslo výzvy" in ('01_23_039','01_24_050','01_24_051')
	   AND p."Registraèní èíslo projektu" is not null
	   GROUP BY v.id) pp ON pp.id = v.id


WHERE skv.id_souborkrit IN (21177955, 163054420) -- sk s jedním bodem Technologie 4.0
-- and  h."Výsledek (v bodech)" >= 5
AND  v."Èíslo výzvy" in ('01_23_039','01_24_050','01_24_051')

-- order by v."Èíslo výzvy"

GROUP BY v."Èíslo výzvy" ,
       v."Název výzvy",
       sk."Název souboru kritérií",
       "Stav výzvy",
       "Poèet projektù",
       "Druh výzvy"
       -- p."Registraèní èíslo projektu" 


----------------------------------------
SELECT v."Èíslo výzvy" ,
       v."Název výzvy",
       sk."Název souboru kritérií",
       p."Registraèní èíslo projektu" ,
       w."Kód" "Kód stavu" ,
       p."Datum prvního podání" 
       -- h."Výsledek (v bodech)" ,
       -- h."Finalizováno",
       -- h."Schváleno schvalovatelem"       
       -- count(CASE WHEN h."Finalizováno" = 'A' THEN 1
       -- 	    ELSE 0 END ) "Poèet zalo¾ených posudkù".
       -- count(CASE WHEN h."Finalizováno" = 'A' THEN 1
       -- 	    ELSE 0 END ) "Poèet finalizovaných posudkù".
       -- count(CASE WHEN h."Schváleno schvalovatelem" = 'A' THEN 1
       -- 	    ELSE 0 END) "Poèet schválených posudkù"
              
	      
FROM vyzva v 
INNER JOIN soubor_kriterii_vyzvy skv ON skv.id_vyzva = v.id
INNER JOIN soubor_kriterii sk ON sk.id = skv.id_souborkrit
INNER JOIN projekt p ON p.id_vyzva = v.id AND p."Registraèní èíslo projektu" is not null 
-- INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id AND h.id_souborkrit = sk.id AND h.id_hodnotitel > 0 -- AND h.id_statushodn = 488649 -- nevyhovìl 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  

WHERE skv.id_souborkrit IN (21177955, 163054420) -- sk s jedním bodem Technologie 4.0
-- and  h."Výsledek (v bodech)" >= 5
AND  v."Èíslo výzvy" in ('01_23_039','01_24_050','01_24_051')
AND not exists
    (SELECT 0
     FROM hodnoceni h
     WHERE h.id_noshodnoceni = p.id
     AND h.id_souborkrit IN (21177955, 163054420) )

ORDER BY v."Èíslo výzvy", p."Registraèní èíslo projektu" 
-- order by v."Èíslo výzvy"

-- GROUP BY v."Èíslo výzvy" ,
--        v."Název výzvy",
--        sk."Název souboru kritérií",
--        -- p."Registraèní èíslo projektu" 
----------------------------------------

SELECT p."Registraèní èíslo projektu",
       w."Kód" "Kód stavu" 
FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva


WHERE v."Èíslo výzvy" = '01_24_050'
AND p."Registraèní èíslo projektu" is not null
AND exists 
(SELECT *
 FROM hodnoceni hdn
 WHERE hdn.id_souborkrit IN (21177955, 163054420)
 AND hdn.id_noshodnoceni = p.id)



