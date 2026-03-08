SELECT	v."Èíslo výzvy" ,
	v."Název výzvy" ,
	p."Registraèní èíslo projektu" ,
	w."Kód" "Kód stavu" ,
	p."Poèet ZoU" ,
	s."Název subjektu" ,
	vp."Velikost kategorie podniku"
	

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462 -- ¾adatel
INNER JOIN ciselnik_velikost_podniku vp ON vp.id = s.id_velikostpodniku

WHERE p."Registraèní èíslo projektu" is not null
AND v."Èíslo výzvy" IN ('01_23_028','01_23_029')
