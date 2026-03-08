SELECT  op.nazev as "Opatøení",
 	p."Registraèní èíslo projektu" ,
	w."Kód" "Souèasný kód stavu" ,
	hs."Zmìnil/a",
	pwf."Kód" "Do stavu"	

	
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN historie_stavu hs ON hs.nositelid = p.id
INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
INNER JOIN ciselnik_stav_workflow w ON w.id = p.id_wfstav


WHERE hs."Zmìnil/a" IN ('DAKRIVLA','KBVLCJAN','LANDAN_EXT','MALLUC1_EXT','MALLUC2_EXT','MARJAN10_EXT','MARJAN17_EXT','MARJAN30_EXT','MARJAN7_EXT','MECJAN2_EXT','NEMJAN6_EXT','PGLANDAN','POPPAV_EXT','RLMARJAN','SAGJAR_EXT','SAMJAN1_EXT','SKRTON_EXT','TURIVO_EXT','TXSAGJAR','VLCJAN1_EXT','VLCJAN_EXT','ZAHPET_EXT')
