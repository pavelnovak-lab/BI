CREATE or REPLACE view "Zástupce ¾adatele (poradenská agentura)" FOLDER= AS 
SELECT op.nazev as "Opatøení" ,
       p."Registraèní èíslo projektu" ,
       w."Kód" "Kód stavu" ,
       s."Název subjektu" "Název ¾adatele",
       s."IÈ" "IÈ ¾adatele",
       pa."IÈ" "IÈ zástupcù ¾adatele",
       pa."Název" "Název zástupcù ¾adatele"
       

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null AND s.id_typsubjektuedit = 413462 -- ¾adatel, partner s FP
LEFT JOIN (SELECT GROUP_CONCAT( s."IÈ" ) "IÈ" ,
     	  	  GROUP_CONCAT( s."Název subjektu" ) "Název" ,
		  s.id_prjgg		  
	   FROM subjekt s
	   WHERE s."Neplatný od" is null
	   AND s.id_typsubjektuedit = 413437 -- zástupce ¾adatele, tedy poradenka)
	   GROUP BY s.id_prjgg) pa ON pa.id_prjgg = p.id
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id   


WHERE p."Registraèní èíslo projektu" is not null
