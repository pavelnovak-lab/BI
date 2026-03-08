CREATE OR REPLACE VIEW "tak-novak-spatna-agregacni-akce-ris-zed" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Projekty' AS 

SELECT DISTINCT 
	op.nazev as "Opatøení",
	p."Registraèní èíslo projektu",
	v."Èíslo výzvy",
	v."Název výzvy",
	w."Kód" "Kód stavu" ,
	CASE WHEN w."Kód" REGEXP_LIKE 'P[PU]2[0-5][ab]?|Z[1-4]'
 	     	  AND op.nazev IN ('Aplikace', 'Partnerství znalostního transferu', 'Spolupráce', 'Proof of concept', 'Slu¾by infrastruktury')
		  AND v."Èíslo výzvy" not IN ('01_24_052','01_23_010') -- Spolupráce Technologické platformy - nejsou vvi
		  AND substr(zed."Kód",0,7) <> 'Z220401'
		  THEN 'PM'
	     WHEN w."Kód" REGEXP_LIKE 'P[PU]2[0-5][ab]?|Z[1-4]'
 	     	  AND op.nazev NOT IN ('Aplikace', 'Partnerství znalostního transferu',  'Proof of concept', 'Slu¾by infrastruktury')
		  AND v."Název výzvy" NOT LIKE ('Spolupráce - Klastry%') -- Spolupráce Klastry - jsou vvi
		  AND substr(zed."Kód",0,7) <> 'Z220402'
		  THEN 'PM'
	     WHEN w."Kód" REGEXP_LIKE 'P[PU][34][0-6]|P[UP]26'
	     	  AND op.nazev IN ('Aplikace', 'Partnerství znalostního transferu', 'Spolupráce', 'Proof of concept', 'Slu¾by infrastruktury')
		  AND v."Èíslo výzvy" not IN ('01_24_052','01_23_010') -- Spolupráce Technologické platformy - nejsou vvi		  
		  AND substr(zed."Kód",0,7) <> 'Z220401' THEN 'Dodavatel MS21+'
	     WHEN w."Kód" REGEXP_LIKE 'P[PU][34][0-6]|P[UP]26'
	     	  AND op.nazev NOT IN ('Aplikace', 'Partnerství znalostního transferu', 'Proof of concept', 'Slu¾by infrastruktury')
 		  AND v."Název výzvy" NOT LIKE ('Spolupráce - Klastry%') -- Spolupráce Klastry - jsou vvi
		  AND substr(zed."Kód",0,7) <> 'Z220402' THEN 'Dodavatel MS21+'
	     ELSE NULL
	     END "Chybná AA, opraví:",
	substr(zed."Kód",0,7) "Kód akce ZED",
        zed."Název" "Název agregaèní akce" ,
        p."Identifikaèní èíslo akce RIS ZED",
	pm.id_uzivatel
	
   
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
INNER JOIN ciselnik_agregacni_akce_zed AS zed ON zed.id = p.id_agrakcezed
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
-- LEFT JOIN projekt_odpovednost pm ON pm.id_prjgg = p.id AND pm."Datum do" IS NULL AND (pm."Vedlej¹í" IS NULL  OR pm."Vedlej¹í" = 'N')
LEFT JOIN (
    SELECT id_prjgg,
    	   id_uzivatel,
	   ROW_NUMBER() OVER (PARTITION BY id_prjgg ORDER BY id) as rn
    FROM projekt_odpovednost
    WHERE "Datum do" IS NULL AND ("Vedlej¹í" IS NULL OR "Vedlej¹í" = 'N')
) pm ON pm.id_prjgg = p.id AND pm.rn = 1


WHERE p."Registraèní èíslo projektu" IS NOT NULL
AND (
     (
     op.nazev IN ('Aplikace', 'Partnerství znalostního transferu', 'Spolupráce', 'Proof of concept', 'Slu¾by infrastruktury')
     AND v."Èíslo výzvy" not IN ('01_24_052','01_23_010') -- Spolupráce Technologické platformy - nejsou vvi
     AND substr(zed."Kód",0,7) <> 'Z220401'
     )
     OR 	
     (
     op.nazev NOT IN ('Aplikace', 'Partnerství znalostního transferu', 'Proof of concept', 'Slu¾by infrastruktury')
     AND v."Název výzvy" NOT LIKE ('Spolupráce - Klastry%') -- Spolupráce Klastry - jsou vvi
     AND substr(zed."Kód",0,7) <> 'Z220402'
     )
    )	
AND w."Kód" REGEXP_LIKE 'P[PU][2-4][0-6][ab]?|Z[1-4]' 

ORDER BY w."Kód" DESC 




 --------------------------------------------------
WITH zed AS (
     SELECT substr("Kód", 0, 7) as zed_kod ,
     	    id,
	    "Název"
     FROM ciselnik_agregacni_akce_zed
     )
     

SELECT op.nazev as "Opatøení",
	p."Registraèní èíslo projektu",
	v."Èíslo výzvy",
	v."Název výzvy",
	w."Kód" "Kód stavu",
	CASE WHEN w."Kód" REGEXP_LIKE 'P[PU]2[0-5][ab]?|Z[1-4]' THEN 'PM'
	     WHEN w."Kód" REGEXP_LIKE 'P[PU][34][0-6]|P[UP]26' THEN 'Dodavatel MS21+'
 	     ELSE NULL
	     END "Chybná AA, opraví:",
	zed_kod "Kód akce ZED",
	zed."Název" "Název agregaèní akce",
	p."Identifikaèní èíslo akce RIS ZED",
	pm.id_uzivatel

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
INNER JOIN zed ON zed.id = p.id_agrakcezed
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id = vh.id_speccil

LEFT JOIN (
	SELECT id_prjgg, id_uzivatel,
		ROW_NUMBER() OVER (PARTITION BY id_prjgg ORDER BY id) as rn
	FROM projekt_odpovednost
	WHERE "Datum do" IS NULL AND ("Vedlej¹í" IS NULL OR "Vedlej¹í" = 'N')
) pm ON pm.id_prjgg = p.id AND pm.rn = 1

WHERE p."Registraèní èíslo projektu" IS NOT NULL
AND w."Kód" REGEXP_LIKE 'P[PU][2-4][0-6][ab]?|Z[1-4]'
AND (
	(
		op.nazev IN ('Aplikace', 'Partnerství znalostního transferu', 'Spolupráce', 'Proof of concept', 'Slu¾by infrastruktury')
		AND v."Èíslo výzvy" NOT IN ('01_24_052','01_23_010')
		AND zed.zed_kod <> 'Z220401'
	)
	OR 	
	(
		op.nazev NOT IN ('Aplikace', 'Partnerství znalostního transferu', 'Proof of concept', 'Slu¾by infrastruktury')
		AND v."Název výzvy" NOT LIKE 'Spolupráce - Klastry%'
		AND zed.zed_kod <> 'Z220402'
	)
)
