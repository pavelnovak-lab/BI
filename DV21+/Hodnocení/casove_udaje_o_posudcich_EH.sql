-- CREATE or REPLACE view  FOLDER=  AS 

SELECT	tel."Kód u¾ivatele2" "Kód hodnotitele",
 	dep."Adresa u¾ivatele",
	-- p."Registraèní èíslo projektu" ,
	-- h."Datum schválení" ,
	sum(
	CASE WHEN h."Datum schválení" < to_date('yyyy-MM-dd HH:mm:ss','2024-01-01 00:00:00') AND h."Datum schválení" > to_date('yyyy-MM-dd HH:mm:ss','2023-12-01 00:00:00')
	     THEN
	     	CASE WHEN pf."Celkové zdroje pøipadající na zpùsobilé výdaje" < 10000000 then 12
	     	WHEN pf."Celkové zdroje pøipadající na zpùsobilé výdaje" < 50000000 then 14
	     	WHEN pf."Celkové zdroje pøipadající na zpùsobilé výdaje" < 100000000 then 16
	     	ELSE 18 END 
	     ELSE 0 END ) "Poèet hodin 2023-12", 
	sum(CASE WHEN h."Datum schválení" < to_date('yyyy-MM-dd HH:mm:ss','2024-01-01 00:00:00') AND h."Datum schválení" > to_date('yyyy-MM-dd HH:mm:ss','2023-12-01 00:00:00') THEN 1 END) AS "Celkem projektù 2023-12",
	sum(CASE WHEN h."Datum schválení" < to_date('yyyy-MM-dd HH:mm:ss','2024-01-01 00:00:00') AND h."Datum schválení" > to_date('yyyy-MM-dd HH:mm:ss','2023-12-01 00:00:00') THEN pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END ) AS "Celkem CZV 2023-12",

	sum(
	CASE WHEN h."Datum schválení" < to_date('yyyy-MM-dd HH:mm:ss','2024-02-01 00:00:00') AND h."Datum schválení" > to_date('yyyy-MM-dd HH:mm:ss','2024-01-01 00:00:00')
	     THEN
	     	CASE WHEN pf."Celkové zdroje pøipadající na zpùsobilé výdaje" < 10000000 then 12
	     	WHEN pf."Celkové zdroje pøipadající na zpùsobilé výdaje" < 50000000 then 14
	     	WHEN pf."Celkové zdroje pøipadající na zpùsobilé výdaje" < 100000000 then 16
	     	ELSE 18 END 
	     ELSE 0 END ) "Poèet hodin 2024-01", 
	sum(CASE WHEN h."Datum schválení" < to_date('yyyy-MM-dd HH:mm:ss','2024-02-01 00:00:00') AND h."Datum schválení" > to_date('yyyy-MM-dd HH:mm:ss','2024-01-01 00:00:00') THEN 1 END) AS "Celkem projektù 2024-01",
	sum(CASE WHEN h."Datum schválení" < to_date('yyyy-MM-dd HH:mm:ss','2024-02-01 00:00:00') AND h."Datum schválení" > to_date('yyyy-MM-dd HH:mm:ss','2024-01-01 00:00:00') THEN pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END ) AS "Celkem CZV 2024-01"

FROM projekt p
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav
INNER JOIN hodnoceni h ON p.id = h.id_noshodnoceni
INNER JOIN hodnotitel tel ON h.id_hodnotitel = tel.id
INNER JOIN hodnotitel_adresa_depese dep ON dep.id = tel.id

WHERE h."Platný" = 'A'
 AND h."Finalizováno" = 'A'
 AND tel."Interní hodnotitel" = 'N'
 -- AND tel."Kód u¾ivatele2" in (567) --, 963)
 -- AND h."Datum schválení" is not null 

AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000602'

GROUP BY tel."Kód u¾ivatele2" ,
      dep."Adresa u¾ivatele" 
-- 	p."Registraèní èíslo projektu" ,
-- 	h."Datum schválení"

