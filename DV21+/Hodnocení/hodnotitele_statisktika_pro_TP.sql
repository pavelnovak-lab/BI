SELECT	tel."Kód u¾ivatele2" "Kód hodnotitele",
	dep."Adresa u¾ivatele",
	h."Datum finalizace",
	h."Datum schválení",
	p."Registraèní èíslo projektu" ,                           
	pf."Celkové zdroje pøipadající na zpùsobilé výdaje" "CZV",
	CASE WHEN pf."Celkové zdroje pøipadající na zpùsobilé výdaje" < 10000000 then 12
	     WHEN pf."Celkové zdroje pøipadající na zpùsobilé výdaje" < 50000000 then 14
	     WHEN pf."Celkové zdroje pøipadající na zpùsobilé výdaje" < 100000000 then 16
	     ELSE 18
	END as "Poèet hodin podle CVZ" ,
	op.plnynazev "Opatrøení" ,
	h."Opravný posudek" ,
	h."Známka (rating hodnotitele)",
	h."Poèet hodin" "Poèet hodin (od EH, vyplnìno na posudku)",
	c."Krok hodnocení",
	h."Schváleno schvalovatelem",
	h.id,
	w."Kód" "Kód stavu" 
	
FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id 
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav
INNER JOIN hodnoceni h ON p.id = h.id_noshodnoceni
INNER JOIN hodnotitel tel ON h.id_hodnotitel = tel.id
INNER JOIN hodnotitel_adresa_depese dep ON dep.id = tel.id
INNER JOIN ciselnik_krok_vecneho_hodnoceni c ON c.id = h.id_krokvechodn

WHERE h."Platný" = 'A'
 AND h."Finalizováno" = 'A'
 AND h."Schváleno schvalovatelem" = 'A'
 -- AND h.id_krokvechodn = 488854 /* 2. krok VH */
 -- AND h."Arbitr" = 'N'
 -- AND h."Schváleno schvalovatelem" = 'A'
 AND tel."Interní hodnotitel" = 'N'
AND  p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000602'


----------------------------------------

SELECT *
from hodnoceni_schvaleni

----------------------------------------
select *
from v_rav_umvhodnoceni h
INNER JOIN 
where id in (137812052, 102846762)
