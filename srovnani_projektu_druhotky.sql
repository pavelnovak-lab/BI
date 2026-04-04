-- CREATE or REPLACE view "RIS3_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 
SELECT v."Název výzvy" ,
       v."Číslo výzvy" ,
       p."Registrační číslo projektu" ,
       p."Název projektu CZ",
       s."Název subjektu" "Žadatel" ,
       s."IČ" ,
       pf."Příspěvek Unie" "EU",
       w."Kód" "Stav projektu" ,
       pp."LinkDMS" ,
       pp."Název dokumentu"
       
FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN prilohy_projektu pp ON pp.id_nositelpril = p.id
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null AND s.id_typsubjektuedit IN (413462) -- žadatel
INNER JOIN ciselnik_velikost_podniku vp ON vp.id = s.id_velikostpodniku 

WHERE p."Registrační číslo projektu" IS NOT NULL
AND pp.id_prilohadef = 19421355
AND v."Číslo výzvy" IN ('01_25_068','01_23_028')
AND w."Kód" REGEXP_LIKE 'P[PU][34][0-6][ab]?' 
