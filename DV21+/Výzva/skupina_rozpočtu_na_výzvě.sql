-- CREATE or REPLACE view "tak-mpo-novak-SR-na-vyzve" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Vyzvy' AS 

SELECT v."Název výzvy",
           v."Èíslo výzvy",
           -- c.nazev,
           c.kod kod_SR,
	   w."Název" "Název stavu výzvy",
	   -- sr."Název skupiny rozpoètu",
	   -- sr.id id_skupinar ,
	   -- spol.id_predpis,
	   -- spol."SD-1 Úèetní/daòové doklady",
	   -- spol."Kód",
	   GROUP_CONCAT( spol."Název"),
	   GROUP_CONCAT( spol."Investice / Neinvestice"),
	   GROUP_CONCAT( spol."Listová")
FROM vyzva AS v
INNER JOIN ciselnik_stav_workflow w ON v.id_wfstav = w.id  
INNER JOIN v_rav_umzvyzvamd AS md ON md.id_vyzva = v.id AND md.platnost = 'A'
INNER JOIN v_rav_umsciszakladni AS c ON c.id = md.id_ciszakladni
INNER JOIN rozpocet_skupina sr ON sr.id = md.id_ciszakladni
INNER JOIN rozpocet_skupina_polozka spol ON spol.id_predpis = sr.id AND (UPPER(spol."Název") like ('%PAU©%') OR UPPER(spol."Název") like ('%NEPØÍM%') OR UPPER(spol."Název") like ('%RE®I%'))
-- INNER JOIN ciselnik_stav_workflow w ON v.id_wfstav = w.id  

WHERE --v."Èíslo výzvy" = '01_23_023'
--AND md.id = 90110119
-- AND
md.id_cisseznam = '278210' -- èíselník skupiny rozpoètu
-- c.kod IN ('OP TAK 30') -- ,'OP TAK 20','OP TAK 21','OP TAK APL DIGI','OP TAK 57','OP TAK 58')

GROUP BY v."Název výzvy",
           v."Èíslo výzvy",
           -- c.nazev,
           c.kod ,
	   w."Název" 



ORDER BY v."Èíslo výzvy" 
-- AND md.id_ciszakladni = 12675643);
