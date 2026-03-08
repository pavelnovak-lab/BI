SELECT	op.nazev as "Opatøení" ,
	pl."Èíslo platby" ,
	w."Kód" "Kód stavu" ,
	k."Charakter nezpùsobilých výdajù",
	k."Krácení celkem",
	k.id
	
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN platba pl ON pl.id_nositelplatby = p.id 
INNER JOIN korekce k ON k.id_platba = pl.id AND k."Typ krácení" = 2  -- krácení jiné
INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id




