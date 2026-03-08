CREATE or REPLACE view "Detaily plateb" FOLDER= AS	
SELECT pl."Zálohová platba",
       k."Registraèní èíslo detailu platby" ,
       w."Kód" "Kód stavu" ,
       w."Název" "Stav",
       k."Èástka v CZK - ¾ádost",
       k."Èástka v CZK - skuteènost",
       CASE WHEN k."Druh detailu platby" = 0 THEN 'Standardní platba'
       	    WHEN k."Druh detailu platby" = 1 THEN 'Pøedfinancování'
 	    WHEN k."Druh detailu platby" = 2 THEN 'Refundace'
	    ELSE '?' END "Druh DP" ,
       FORMATDATE('d. M. yyyy', k."Datum workflow stavu"),
       k."Investice/Neinvestice",
       k.id
	    	           
FROM projekt p
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null AND s.id_typsubjektuedit = 413462  -- ¾adatel
-- INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 
INNER JOIN platba pl ON pl.id_nositelplatby = p.id 
INNER JOIN klasifikace k ON k.id_platba = pl.id
INNER JOIN ciselnik_stav_workflow w ON k.id_wfstav = w.id  

WHERE -- s."IÈ" = '05108861'
--p."Registraèní èíslo projektu"  = 'CZ.01.07.01/01/23_022/0003008'
k."Druh detailu platby" = 0
ORDER BY k."Registraèní èíslo detailu platby" 


----------------------------------------

-- CREATE or REPLACE view "Detaily plateb" FOLDER= AS	
SELECT pl."Zálohová platba",
       k."Registraèní èíslo detailu platby" ,
       w."Kód" "Kód stavu" ,
       w."Název" "Stav",
       k."Èástka v CZK - ¾ádost",
       k."Èástka v CZK - skuteènost",
       CASE WHEN k."Druh detailu platby" = 0 THEN 'Standardní platba'
       	    WHEN k."Druh detailu platby" = 1 THEN 'Pøedfinancování'
 	    WHEN k."Druh detailu platby" = 2 THEN 'Refundace'
	    ELSE '?' END "Druh DP" ,
       FORMATDATE('d. M. yyyy', k."Datum workflow stavu"),
       k."Investice/Neinvestice",
       k.id
	    	           
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
-- INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null AND s.id_typsubjektuedit = 413462  -- ¾adatel
-- INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 
INNER JOIN platba pl ON pl.id_nositelplatby = p.id 
INNER JOIN klasifikace k ON k.id_platba = pl.id
INNER JOIN ciselnik_stav_workflow w ON k.id_wfstav = w.id  

WHERE -- s."IÈ" = '05108861'
--p."Registraèní èíslo projektu"  = 'CZ.01.07.01/01/23_022/0003008'
k."Druh detailu platby" = 0
AND v."Èíslo výzvy" <> '01_23_022'


ORDER BY k."Registraèní èíslo detailu platby" 
