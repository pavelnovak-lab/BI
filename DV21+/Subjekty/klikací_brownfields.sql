SELECT	
	p."Registraèní èíslo projektu",
       s."Název subjektu" AS "Název ¾adatele",
       s."IÈ" AS "IÈ ¾adatele",
       pa."IÈ" AS "IÈ zástupcù ¾adatele",
       pa."Název" AS "Název zástupcù ¾adatele"
FROM 		     (projekt AS p INNER JOIN vyzva AS v ON v.id = p.id_vyzva)
		     INNER JOIN vyzva_hierarchie AS vh
			 ON vh.id_vyzva = v.id
		 )
		 INNER JOIN v_rav_umshisc AS op
		     ON op.id = vh.id_speccil
	     )
	     INNER JOIN subjekt AS s
		 ON (s.id_prjgg = p.id AND s."Neplatný od" IS NULL AND s.id_typsubjektuedit = 413462)
	 )
	 LEFT OUTER JOIN (
	     SELECT group_concat(subjekt."IÈ") AS "IÈ",
		    group_concat(subjekt."Název subjektu") AS "Název",
		    subjekt.id_prjgg
	     FROM subjekt
	     WHERE ("Neplatný od" IS NULL AND id_typsubjektuedit = 413437)
	     GROUP BY subjekt.id_prjgg
	 ) AS pa
	     ON pa.id_prjgg = p.id
 WHERE p."Registraèní èíslo projektu" IS NOT NULL
