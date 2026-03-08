-- WITH inv_neinv AS (
-- SELECT p.id,
--        sum(CASE WHEN wpl."Kód" REGEXP_LIKE 'P1[0-4][T]?' THEN pl."Vyúčtování - Investice - skutečnost"
--        	    ELSE pl."Vyúčtování - Investice - plán"
-- 	    END) "CZV-INV",
--        sum(CASE WHEN wpl."Kód" REGEXP_LIKE 'P1[0-4][T]?' THEN pl."Vyúčtování - Neinvestice - skutečnost"
--        	    ELSE pl."Vyúčtování - Neinvestice - plán"
-- 	    END) "CZV-NEINV"
       
--        FROM projekt p
--        INNER JOIN platba pl ON pl.id_nositelplatby = p.id
--        INNER JOIN ciselnik_stav_workflow wpl ON pl.id_wfstav = wpl.id 

--        WHERE p."Registrační číslo projektu" IS NOT NULL 

--        GROUP BY p.id
-- )
       
SELECT v."Číslo výzvy",
       v."Název výzvy",
       SUBSTR(prg."Kód",4) AS "Kód Priority",
       -- prg."Název" "Priorita",
       sc."Číslo SC/opatření ŘO formát" as  "Kód SC",
       op."Název specifického cíle/opatření" as "Opatření" ,
       p."Registrační číslo projektu" AS "Registrační číslo projektu",
       w."Kód" "Kód stavu" ,
       pf."Celkové zdroje připadající na způsobilé výdaje" AS "CZV Projektu",


	pf."Příspěvek Unie" "EU" ,
	pf."Příspěvek společenství (% veřejných)" ,
       	pf."Celkové zdroje připadající na nezpůsobilé výdaje" "CNV z PZF",


       max(CASE 
        	WHEN rp."Název" like 'Celkové způsobilé výdaje - neinvestiční%' 
            	OR rp."Název" like 'Způsobilé výdaje - neinvestiční%'
		OR rp."Název" = 'Nepřímé náklady'
 		OR rp."Název" like '%zástupců - neinvestice'
        	THEN rp."Částka celkem"
        	ELSE 0
	END) AS "CZV NEINV",
       max(CASE 
             WHEN rp."Název" like 'Celkové způsobilé výdaje - investiční%' 
             OR rp."Název" like 'Způsobilé výdaje - investiční%'
	     OR rp."Název" like '%zástupců%- investice'
	     OR rp."Název" like '%CZV investiční%'
	     THEN rp."Částka celkem"
             ELSE 0
	END) AS "CZV INV" ,

	pf."Celkové zdroje připadající na způsobilé výdaje" -
        (
       max(CASE 
        	WHEN rp."Název" like 'Celkové způsobilé výdaje - neinvestiční%' 
            	OR rp."Název" like 'Způsobilé výdaje - neinvestiční%'
		OR rp."Název" = 'Nepřímé náklady'
 		OR rp."Název" like '%zástupců - neinvestice'
        	THEN rp."Částka celkem"
        	ELSE 0
	END) +
       max(CASE 
             WHEN rp."Název" like 'Celkové způsobilé výdaje - investiční%' 
             OR rp."Název" like 'Způsobilé výdaje - investiční%'
	     OR rp."Název" like '%zástupců%- investice'
	     OR rp."Název" like '%CZV investiční%'
	     THEN rp."Částka celkem"
             ELSE 0
	END) 
	) "CZV - (CZV-INV + CZV-NEINV)"




FROM projekt AS p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva AS v ON p.id_vyzva = v.id
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil
INNER JOIN specificky_cil sc on sc.id=op.id_hierarchie
INNER JOIN programova_linie prg ON prg.id = sc.id_osa
-- INNER JOIN inv_neinv ON inv_neinv.id = p.id 
INNER JOIN rozpocet_hlavicka AS rh ON p.id = rh.id_nrozpocet
INNER JOIN rozpocet_polozka AS rp ON rp.id_hlavicka = rh.id

WHERE p."Registrační číslo projektu" IS NOT NULL 
AND rh."Aktuální" = 'A'

GROUP BY v."Číslo výzvy",
       v."Název výzvy",
       SUBSTR(prg."Kód",4) ,
       sc."Číslo SC/opatření ŘO formát" ,
       op."Název specifického cíle/opatření" ,
       p."Registrační číslo projektu" ,
       w."Kód" ,
       pf."Celkové zdroje připadající na způsobilé výdaje" ,


	pf."Příspěvek Unie"  ,
	pf."Příspěvek společenství (% veřejných)" ,
       	pf."Celkové zdroje připadající na nezpůsobilé výdaje"





HAVING 	pf."Celkové zdroje připadající na způsobilé výdaje" -
        (
	max(CASE 
        	WHEN rp."Název" like 'Celkové způsobilé výdaje - neinvestiční%' 
            	OR rp."Název" like 'Způsobilé výdaje - neinvestiční%'
		OR rp."Název" like '%zástupců - neinvestice'
		OR rp."Název" = 'Nepřímé náklady'
		THEN rp."Částka celkem"
        	ELSE 0
	END) +
       max(CASE 
             WHEN rp."Název" like 'Celkové způsobilé výdaje - investiční%' 
             OR rp."Název" like 'Způsobilé výdaje - investiční%'
	     OR rp."Název" like '%CZV investiční%'
	     OR rp."Název" = '%zástupců%- investice'
             THEN rp."Částka celkem"
             ELSE 0
	END)
	) <> 0




-- Kod IN ['CZ.01.03.01/01/23_034/0006077', 'CZ.01.03.01/01/23_034/0006090', 'CZ.01.03.01/01/23_034/0006065', 'CZ.01.01.01/05/22_004/0002624', 'CZ.01.01.01/05/22_004/0000365', 'CZ.01.01.01/05/22_004/0002608', 'CZ.01.01.01/05/22_004/0003133', 'CZ.01.01.01/05/22_004/0003334', 'CZ.01.01.01/05/22_004/0003232', 'CZ.01.01.01/05/22_004/0003170', 'CZ.01.01.01/06/23_014/0001368']
