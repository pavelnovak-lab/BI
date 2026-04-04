CREATE or REPLACE view "tak_novak_indikator_obrat" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Indikatory'  AS	

SELECT p."Registrační číslo projektu",
       w."Kód" "Kód stavu",
       s."Název subjektu" ,
       s."IČ" ,
       extract(year from p."Datum registrace žádosti") "Rok registrace" ,   
       p."Předpokládané datum ukončení", 
       p."Předpokládané datum zahájení",
       p."Předpokládané datum ukončení"  - p."Předpokládané datum zahájení" "Realizace dní",
       (p."Předpokládané datum ukončení"  - p."Předpokládané datum zahájení")/365.0 "Předpokládaná doba realizace (v letech)" ,
       ih."Datum cílové hodnoty",
       ih."Datum cílové hodnoty" - p."Předpokládané datum ukončení" "Rozdíl dní datum ukončení a cílové hodnoty",
       pf."Příspěvek Unie"/1000 "Dotace EU (v tis. Kč)",
       100/1000 * pf."Příspěvek Unie" / NULLIF(ih."Výchozí hodnota", 0) "Kolik % výchozí hodnoty obratu tvoří dotace",
       ih."Výchozí hodnota" "Výchozí hodnota indikátoru Obrat (tis. Kč/rok)", 
       ih."Cílová hodnota" "Cílová hodnota indikátoru Obrat (tis. Kč/rok)",
       100/1000 * NULLIF(pf."Příspěvek Unie", 0) / NULLIF(ih."Cílová hodnota" - ih."Výchozí hodnota",0) / ((p."Předpokládané datum ukončení"  - p."Předpokládané datum zahájení") / 365) AS "O kolik % se zvýší obrat vlivem dotace (škálováno na 1 rok)"


FROM projekt p
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null  AND s.id_typsubjektuedit IN (413462) -- žadatel
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
INNER JOIN indikator_hodnota ih ON ih.id_nositelindi = p.id
INNER JOIN indikator i ON i.id = ih.id_indikator
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005

WHERE v."Číslo výzvy" = '01_24_062'
AND p."Registrační číslo projektu" IS NOT NULL
AND (w."Kód" REGEXP_LIKE 'P[PU]2[0-6][ab]?|Z[1-4]' OR w."Kód" REGEXP_LIKE 'P[PU][34][0-6]')
AND i."Kód NČI 2021+" = '107501'-- CREATE or REPLACE view "tak_novak_indikator_obrat" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Indikatory'  AS	

ORDER BY CASE
	     WHEN w."Kód" IN 'PP20' THEN 1  
	     WHEN w."Kód" IN 'PP22' THEN 2
	     WHEN w."Kód" IN ('PP23a','PP23b') THEN 3
	     WHEN w."Kód" IN ('PP25a','PP25b') THEN 4
	     WHEN w."Kód" in ('Z1', 'Z2', 'Z3', 'Z4') THEN 5
	     WHEN w."Kód" = 'PP26' THEN 6
	     ELSE 7
	 END,
	 w."Kód"
----------------------------------------
SELECT  p."Registrační číslo projektu",
	pril.LinkDMS

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN prilohy_projektu prilprj ON prilprj.id_id_nositelpril = p.id 

WHERE LOWER(pril."Název dokumentu") like '.*ekonomick[eé].*hodnocen[ií].*'
AND (w."Kód" REGEXP_LIKE 'P[PU]2[0-6][ab]?|Z[1-4]' OR w."Kód" REGEXP_LIKE 'P[PU][34][0-6]')
AND v."Číslo výzvy" = '01_24_062'
