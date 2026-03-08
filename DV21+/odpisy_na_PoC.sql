CREATE or REPLACE view "Hodnota_polozky_rozpoctu" FOLDER=  AS 

SELECT v."Èíslo výzvy" ,
       v."Název výzvy" ,
       p."Registraèní èíslo projektu" ,
       s."IÈ",
       s."Název subjektu",
       w."Kód" "Kód stavu" ,  
       pr."Kód",
       pr."Název",
       
       pr."Èástka celkem"


FROM projekt p
INNER JOIN INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462 -- ¾adatel  
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN rozpocet_hlavicka hr ON hr.id_nrozpocet = p.id
INNER JOIN rozpocet_polozka pr ON pr.id_hlavicka = hr.id


WHERE hr."Aktuální" = 'A'
AND w."Kód" not like 'PN%'
AND p."Registraèní èíslo projektu" is not null 
AND pr."Kód" = '1.1.1.5'
-- AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/08/22_001/0000349'
AND v."Èíslo výzvy" IN ('01_22_001','01_22_005')

ORDER BY v."Èíslo výzvy", p."Registraèní èíslo projektu" 
