-- CREATE or REPLACE view "mpo-novak-priloha-financni-analyze" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Projekty' AS 

SELECT	  op.nazev as "Opatøení" ,
	  v."Èíslo výzvy" ,
	  v."Název výzvy" ,
	p."Registraèní èíslo projektu" ,
       -- p."Identifikace ¾ádosti (hash)" ,
       s."Název subjektu" "®adatel"  ,
       w."Kód" "Kód stavu" ,
       pf."Pøíspìvek Unie" "EU" ,
       pri."Název dokumentu",
       dd."Název" "Definovaný dokument",
       pri.id,
       pri."Soubor"
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462 -- ¾adatel A dodání je pa
INNER JOIN prilohy_projektu pri ON pri.id_nositelpril = p.id 
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 
LEFT JOIN ciselnik_definovane_dokumenty dd ON dd.id = pri.id_prilohadef -- AND dd.id = 19422844 -- formuláø finanèní analýzy


WHERE p."Registraèní èíslo projektu" is not null  
AND (pri.id_prilohadef = 19422844 OR upper(pri."Název dokumentu") like ('%FIN%ANAL%') )

ORDER BY v."Èíslo výzvy", p."Registraèní èíslo projektu" 
-- AND dd.id in (65251178, 19422844)
-- AND pri.id = 144844532
-- AND p."Registraèní èíslo projektu" =  'CZ.01.01.02/01/23_023/0001877'
-- AND pf."Pøíspìvek Unie" "EU" > 0

-- AND not exists
-- (SELECT pr."Registraèní èíslo projektu" 
--  FROM projekt pr
--  INNER JOIN prilohy_projektu pril ON pril.id_nositelpril = pr.id     

--  WHERE pril.id_prilohadef in (65251178, 19422844)
--  AND pr.id = p.id)

