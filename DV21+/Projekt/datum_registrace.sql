SELECT	CASE WHEN v."Èíslo výzvy" = '01_24_073' THEN 'B'
	     WHEN v."Èíslo výzvy" = '01_24_059' THEN 'A'
	     ELSE null END "Aktivita" ,
 	 p."Registraèní èíslo projektu" ,
	 s."Název subjektu" "®adatel" ,
	 p."Datum registrace ¾ádosti" ,
	pf."Pøíspìvek Unie" "EU" ,
 	pf."Pøíspìvek spoleèenství (% veøejných)" "% EU" ,
 	pa."IÈ" AS "IÈ zástupcù ¾adatele",
       pa."Název" AS "Název zástupcù ¾adatele"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null AND s.id_typsubjektuedit IN (413462) -- ¾adatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 
	 LEFT OUTER JOIN (
	     SELECT group_concat(subjekt."IÈ") AS "IÈ",
		    group_concat(subjekt."Název subjektu") AS "Název",
		    subjekt.id_prjgg
	     FROM subjekt
	     WHERE ("Neplatný od" IS NULL AND id_typsubjektuedit = 413437)
	     GROUP BY subjekt.id_prjgg
	 ) AS pa ON pa.id_prjgg = p.id


WHERE v."Èíslo výzvy" IN ('01_24_073','01_24_059')
AND p."Registraèní èíslo projektu" is not null 
ORDER BY v."Èíslo výzvy" ,  p."Datum registrace ¾ádosti"



