SELECT	op.nazev as "Opatøení",
	p."Registraèní èíslo projektu" ,
	w."Kód" "Kód stavu" ,
	pl."Èíslo platby" ,
	-- cuk."Kód" "Øádek F1-C",
	-- rf."Aktuální rozpis financování projektu",
	-- rf."Pøedlo¾ené vyúètování v toto ®oP" ,
	k."FMDotaceCelk"	

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
-- INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id AND cuk."Kód" = '7' -- øádek F1-C
-- INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel AND cuk."Kód" = '7' -- øádek F1-C
INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id  
INNER JOIN castky k ON k.id = pl.id_rozdilkorekce




WHERE k."FMDotaceCelk" < 0
AND pl."Èíslo platby" = 'CZ.01.01.01/05/22_004/0001396/2024/001/POST'

-- 'CZ.01.04.01/01/22_006/0001183/2023/001/POST'
-- AND cuk."Kód" = '7'
-- AND
-- rf."Aktuální rozpis financování projektu" < rf."Pøedlo¾ené vyúètování v toto ®oP"
