SELECT op.nazev as "Opatøení" ,
       p."Registraèní èíslo projektu" ,
       w."Kód" "Kód stavu" ,
       pf."Pøíspìvek Unie"  "Dotace po zmìnì",
       ropd."EU" "Dotace RoPD",
       pf."Pøíspìvek spoleèenství (% veøejných)" "% EU po zmìnì",
       ropd.dprocento  "% EU RoPD"
    


FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze in (99991000000000005) -- aktuální stav
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
INNER JOIN (SELECT pf."Pøíspìvek spoleèenství (% veøejných)" dprocento ,
      	   	   pf."Pøíspìvek Unie" "EU" ,
		   pf.id_projekt
	    FROM projekt p
	    INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze in (99991000000000011) -- RoPD
	    ) ropd ON ropd.id_projekt = p.id 


WHERE p."Registraèní èíslo projektu" is not null
AND w."Kód" not like 'PN%'
AND pf."Pøíspìvek spoleèenství (% veøejných)" > ropd.dprocento

