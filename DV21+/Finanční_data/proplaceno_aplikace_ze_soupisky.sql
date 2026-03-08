-- CREATE or REPLACE view "tak-novak-aplikace_proplaceno_partnteri" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Finanèní_data/Aplikace' AS 

SELECT	v."Název výzvy" ,
	v."Èíslo výzvy" ,
	p."Registraèní èíslo projektu",
	p."Název projektu CZ" ,
 	w."Kód" "Stav projektu" ,
	zop.zv_celkem "Schválené ZV projekt",
 	zop.eu_celkem "Proplaceno EU projekt",
	zop."Celkem kráceno", 
	zop.pocetzop "Poèet ®oP",
	zop.datum "Datum proplacení polslední ®oP",
	s."Název subjektu" ,
	ts."Název" "Pøíjemce / Partner" ,
	zop.zv "Schválené ZV" ,
	zop.eu "Proplacené EU",
	zop.vlastni "Schválená vlastní èást"

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil 
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null AND s.id_typsubjektuedit IN (413462, 413467) --  ¾adatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 
INNER JOIN ( SELECT count(DISTINCT pl.id) AS pocetzop,
		    sum(vpos_agg.zv) AS zv,
		    sum(vpos_agg.eu) AS eu,
		    sum(vpos_agg.vlastni) AS vlastni,
		    max(pl."Datum zmìny stavu") AS datum,
		    sum(DISTINCT sch."FMDotaceCelk") AS eu_celkem,
		    sum(sch."FinMezeraCelk") AS zv_celkem,
		    sum(kr_agg.kraceni_celkem) AS "Celkem kráceno",
		    s.id AS id_subjekt,
		    pl.id_nositelplatby

	       FROM platba pl
	       INNER JOIN ciselnik_stav_workflow wpl ON pl.id_wfstav = wpl.id
	       INNER JOIN subjekt s ON s.id_prjgg = pl.id_nositelplatby
		   AND s."Neplatný od" IS NULL
		   AND s.id_typsubjektuedit IN (413462, 413467) -- pøíjemce a partner
	       INNER JOIN castky_schvaleno sch ON sch.id = pl.id_schvalenecastky

	       -- pøedagregované korekce na úrovni platby
	       LEFT JOIN (
		   SELECT
		       kr.id_platba,
		       kr.id_typkorekce,
		       sum(kr."Krácení celkem") AS kraceni_celkem
		   FROM korekce kr
		   INNER JOIN ciselnik_typ_korekce typk ON typk.id = kr.id_typkorekce
		       AND typk."Název CZ" = 'Krácení s dopadem na disponibilní alokaci projektu'
		   WHERE kr."Typ krácení" = 2
		   AND kr."Krácení celkem" > 1
		   GROUP BY kr.id_platba, kr.id_typkorekce
	       ) kr_agg ON kr_agg.id_platba = pl.id

	       -- pøedagregované soupisky na úrovni platba + subjekt
	       INNER JOIN (
		   SELECT
		       vpos.id_platba,
		       vpos.id_subjekt,
		       sum(vpos."Èástka pro výpoèet veøejné podporky (CZK) - Schváleno") AS zv,
		       sum(vpos."Èástka EU - Schváleno") AS eu,
		       sum(vpos."Èástka Vlastní zdroje - Schváleno") AS vlastni
		   FROM verejna_podpora_soupiska vpos
		   GROUP BY vpos.id_platba, vpos.id_subjekt
	       ) vpos_agg ON vpos_agg.id_platba = pl.id AND vpos_agg.id_subjekt = s.id

	      WHERE wpl."Kód" REGEXP_LIKE ('P1[0-4][T]?')
	      AND pl."Datum proplacení pøíjemci / vypoøádání" >= DATE '2025-01-01'
	      AND pl."Datum proplacení pøíjemci / vypoøádání" < DATE '2026-01-01'
	      -- AND pl."Èíslo platby" LIKE 'CZ.01.01.01/01/22_002/0000487%'
	      GROUP BY
		  s.id,
		  pl.id_nositelplatby,
		  kr_agg.id_typkorekce
	      ) zop ON zop.id_nositelplatby = p.id AND s.id = zop.id_subjekt

-- SELECT count(DISTINCT pl.id) pocetzop,
-- 		   sum(vpos."Èástka pro výpoèet veøejné podporky (CZK) - Schváleno") zv ,
-- 		   sum(vpos."Èástka EU - Schváleno") eu ,
-- 		   sum(vpos."Èástka Vlastní zdroje - Schváleno") vlastni,
-- 		   max(pl."Datum zmìny stavu") datum,
-- 		   -- rozmyslet si distinct !
-- 		   sum(distinct sch."FMDotaceCelk") eu_celkem,
-- 		   sum(sch."FinMezeraCelk") zv_celkem ,
-- 		   sum(kr."Krácení celkem") AS "Celkem kráceno",
-- 		   s.id id_subjekt,
-- 		   pl.id_nositelplatby

-- 	    FROM platba pl
-- 	    -- LEFT JOIN !!!
-- 	    INNER JOIN korekce AS kr ON kr.id_platba = pl.id AND kr."Typ krácení" = 2 AND kr."Krácení celkem" > 1 -- ignoruju haléøové rozdíly 
--  	    INNER JOIN ciselnik_typ_korekce AS typk ON typk.id = kr.id_typkorekce AND typk."Název CZ" = 'Krácení s dopadem na disponibilní alokaci projektu'
-- 	    INNER JOIN ciselnik_stav_workflow wpl ON pl.id_wfstav = wpl.id 
-- 	    INNER JOIN subjekt s ON s.id_prjgg = pl.id_nositelplatby AND s."Neplatný od" is null AND s.id_typsubjektuedit IN (413462, 413467) -- 
-- 	    INNER JOIN verejna_podpora_soupiska vpos ON vpos.id_platba = pl.id AND vpos.id_subjekt = s.id
-- 	    INNER JOIN castky_schvaleno sch ON sch.id = pl.id_schvalenecastky

-- 	    WHERE wpl."Kód" REGEXP_LIKE ('P1[0-4][T]?') -- stavy po P11 jsou ®oP vrácené z PO 
-- 	    AND pl."Datum proplacení pøíjemci / vypoøádání" >= DATE '2025-01-01'
-- 	    AND pl."Datum proplacení pøíjemci / vypoøádání" < DATE '2026-01-01'
-- 	    AND pl."Èíslo platby" like 'CZ.01.01.01/01/22_002/0000487%'
-- 	    GROUP BY s.id,
-- 		     pl.id_nositelplatby
-- 		     , id_typkorekce
-- 	    ) zop ON zop.id_nositelplatby = p.id AND s.id = zop.id_subjekt


WHERE --v."Èíslo výzvy" = '01_22_002' -- Aplikace I
-- AND p."Registraèní èíslo projektu" IN ('CZ.01.01.01/01/22_002/0000436','CZ.01.01.01/01/22_002/0000487/2025/003/POST')
-- AND
op."Název specifického cíle/opatøení" = 'Aplikace'

ORDER BY "Datum proplacení polslední ®oP", ts."Název" DESC





----------------------------------------




SELECT count(DISTINCT pl.id) pocetzop,
       sum(vpos."Èástka pro výpoèet veøejné podporky (CZK) - Schváleno") zv ,
       sum(vpos."Èástka EU - Schváleno") eu ,
       sum(vpos."Èástka Vlastní zdroje - Schváleno") vlastni,
       max(pl."Datum zmìny stavu") datum,  
       s.id,
       pl.id_nositelplatby
       
FROM platba pl
INNER JOIN ciselnik_stav_workflow wpl ON pl.id_wfstav = wpl.id 
INNER JOIN subjekt s ON s.id_prjgg = pl.id_nositelplatby AND s."Neplatný od" is null AND s.id_typsubjektuedit IN (413462, 413467) -- 
INNER JOIN verejna_podpora_soupiska vpos ON vpos.id_platba = pl.id AND vpos.id_subjekt = s.id
INNER JOIN castky_schvaleno sch ON sch.id = pl.id_schvalenecastky

WHERE wpl."Kód" REGEXP_LIKE ('P1[0-4][T]?') -- stavy po P11 jsou ®oP vrácené z PO 
AND pl."Datum proplacení pøíjemci / vypoøádání" >= DATE '2025-01-01'
AND pl."Datum proplacení pøíjemci / vypoøádání" < DATE '2026-01-01'

GROUP BY s.id,
      	 pl.id_nositelplatby






------------------------------

