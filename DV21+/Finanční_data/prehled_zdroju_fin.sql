SELECT op.nazev as "Opatøení",
       p."Registraèní èíslo projektu" ,
       w."Kód" "Kód stavu" ,
       pf."Pøíspìvek spoleèenství (% veøejných)" AS "% EU RoPD",
       zoz."Pøíspìvek spoleèenství (% veøejných)" AS "% EU Dodatek"
       -- pf."Pøíspìvek Unie" "EU"
       -- pf."Celkové zdroje pøipadající na zpùsobilé výdaje" "CZV"
       --pf.*
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000011 -- ropd
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
LEFT JOIN (SELECT pf.id_projekt ,
     	  	  pf."Pøíspìvek spoleèenství (% veøejných)"
	   FROM prehled_zdroju_financovani pf
	   WHERE pf.id_faze = 99991000000000015 -- PA - zmìna
	   ) zoz ON zoz.id_projekt = p.id

-- ORDER BY p."Registraèní èíslo projektu"
WHERE w."Kód" REGEXP_LIKE 'P[PU][34].*'
AND pf."Pøíspìvek spoleèenství (% veøejných)" < zoz."Pøíspìvek spoleèenství (% veøejných)" 




-- CZ.01.01.01/01/22_002/0001065|CZ.01.01.01/01/22_002/0000682
