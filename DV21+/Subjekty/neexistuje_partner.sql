SELECT p."Registraèní èíslo projektu",
       w."Kód" "Kód stavu" 

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  

WHERE p."Registraèní èíslo projektu" is not null
AND v."Èíslo výzvy" = '01_22_002'
AND not exists (SELECT 1
    	       	FROM subjekt
		WHERE id_prjgg = p.id
		AND id_typsubjektuedit = 413467 -- partner s finanèním pøíspìvkemn
		)
