-- CREATE or REPLACE view "vpo_aplikace_subjekt" FOLDER= AS	
SELECT p.id id_projekt , 
       p."Registraèní èíslo projektu",
       s."Název subjektu",
       s."IÈ",
       cts."Název" "Typ subjektu",
       s.id_typsubjektuedit ,
       vpo.eu,
       vpo.vlastni ,
       vpo.zv ,
       vpo.id_nositel id_subjekt,
       pzf."Pøíspìvek Unie" ,
       pzf."Národní veøejné zdroje" ,
       pzf."Soukromé zdroje",
       pzf."Pøíspìvek Unie + Národní spolufinancování"  

FROM projekt p
INNER JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000011 -- Finance v RoPD 
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null AND s.id_typsubjektuedit IN (413462, 413467) -- ¾adatel, partner s FP
INNER JOIN ciselnik_typ_subjektu cts ON s.id_typsubjektuedit = cts.id
INNER JOIN (SELECT sum("Èástka poskytnuté veøejné podpory celkem - Pøíspìvek Unie v Kè") eu,
       	   	   sum("Èástka poskytnuté veøejné podpory celkem v Kè") zv ,
       		   sum("Èástka poskytnuté veøejné podpory celkem - Ostatní zdroje v Kè") vlastni,
		   id_nositel
	    FROM verejna_podpora
	    WHERE "Platnost" = 'A'
	    GROUP BY id_nositel) vpo ON vpo.id_nositel = s.id 

-- WHERE p."Registraèní èíslo projektu" IN ('CZ.01.01.01/01/24_063/0006961','CZ.01.01.01/01/24_063/0006507')
-- ORDER BY p."Registraèní èíslo projektu" , "Typ subjektu"


----------------------------------------

SELECT p."Registraèní èíslo projektu" ,
--       csdp."Název" ,
--       csdp."Kód" ,
       f.vedni_oblast,
       f.ford_kategorie,
       f.ford_popis

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN projekt_sdp psdp ON psdp.id_projekt = p.id 
INNER JOIN ciselnik_sdp_projekt csdp ON csdp.id = psdp.id_sdpcis
INNER JOIN fields_of_research_and_development f ON f.ford_kod = csdp."Kód" 
	   
WHERE p."Registraèní èíslo projektu" IN ('CZ.01.01.01/01/24_063/0006961','CZ.01.01.01/01/24_063/0006507')
AND psdp.id_sdp = 427525289 -- SDP "OP TAK 15" | DETAILED FORD - Oblast výzkumu a vývoje
