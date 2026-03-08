CREATE or REPLACE view arbitr FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Hodnoceni/' AS 

WITH posudky AS
(SELECT MIN(h.id) "id_hodnoceni_prvni",
 	MAX(h.id) "id_hodnoceni_druhy",
	h.id_noshodnoceni
	
 FROM hodnoceni h
 WHERE h."Platný" = 'A'
 AND h."Finalizováno" = 'A'
 AND h."Schváleno schvalovatelem" = 'A'
 AND h."Opravný posudek" = 'N'
 /* Místo natvrdo zapsaného kroku hodnocení vyhodnocuji existenci arbitra (pro stejný soubor kritérií hodnocení)
-- AND h.id_krokvechodn = 488854 /* 2. krok VH */
 AND h."Arbitr" = 'N'
 /* jen projekty s arbitrem */
 AND EXISTS
 (SELECT 0
  FROM hodnoceni
  WHERE "Arbitr" = 'A'
  AND "Platný" = 'A'
  AND "Finalizováno" = 'A'
  AND "Schváleno schvalovatelem" = 'A'
  -- AND id_krokvechodn = 488854
  AND id_noshodnoceni = h.id_noshodnoceni
  AND id_souborkrit = h.id_souborkrit
 )
 GROUP BY h.id_noshodnoceni
),

status AS
(
 SELECT  h.id_noshodnoceni,
        max(CASE WHEN h.id = ps.id_hodnoceni_prvni THEN h."Výsledek (v bodech)" END) "Body 1.",
	max(CASE WHEN h.id = ps.id_hodnoceni_prvni THEN sh."Název"  END) "Status 1.",
	max(CASE WHEN h.id = ps.id_hodnoceni_druhy THEN h."Výsledek (v bodech)" END) "Body 2.",
	max(CASE WHEN h.id = ps.id_hodnoceni_druhy THEN sh."Název"  END) "Status 2." ,
 	max(CASE WHEN h."Arbitr" = 'A' THEN h."Výsledek (v bodech)" END) "Body arbitr" ,
 	max(CASE WHEN h."Arbitr" = 'A' THEN sh."Název"  END) "Status arbitr"
 FROM posudky ps
  INNER JOIN hodnoceni h ON ps.id_noshodnoceni = h.id_noshodnoceni
  INNER JOIN ciselnik_status_hodnoceni sh on sh.id = h.id_statushodn
 WHERE h."Platný" = 'A'
  AND h."Finalizováno" = 'A'
  AND h."Schváleno schvalovatelem" = 'A'
  -- AND h.id_krokvechodn = 488854
 GROUP BY h.id_noshodnoceni
)

SELECT	op.nazev as "Opatøení",
	v."Èíslo výzvy",
	v."Název výzvy" ,
	p."Registraèní èíslo projektu",
	w."Kód" "Kód stavu" ,
	skv."Bodová hranice" "Bodová hranice (z výzvy)",
	skv."Hranice pro arbitra (body)" "Rozdíl bodù posudkù pro arbitra" ,
	st."Body 1.",
	st."Status 1.",
	st."Body 2.",
	st."Status 2.",
	st."Body arbitr",
	st."Status arbitr" ,
	st."Body arbitr" - (st."Body 1."+st."Body 2.")/2  AS "Rozdíl bodù arbitra od prùmìru øádných" ,
	CASE WHEN st."Status 1." = 'Vyhovìl'
 	     	  AND st."Status 2." = 'Vyhovìl'
 	     	  THEN 'Bodovì vzdálené posudky'
 	     WHEN st."Status 1." = 'Vyhovìl'
 	     	  AND st."Status 2." = 'Nevyhovìl'
 		  AND st."Body 2." < skv."Bodová hranice"
 		  THEN 'Nad i pod bodovou hranicí'
 	     WHEN st."Status 1." = 'Nevyhovìl'
 	     	  AND st."Status 2." = 'Vyhovìl'
 		  AND st."Body 1." < skv."Bodová hranice"
 		  THEN 'Nad i pod bodovou hranicí'
 	     WHEN st."Status 1." = 'Nevyhovìl'
 	     	  AND st."Status 2." = 'Nevyhovìl'
 		  AND abs(st."Body 1."-st."Body 2.") >= skv."Hranice pro arbitra (body)" 
 		  THEN 'Bodovì vzdálené nevyhovující posudky'
 	     WHEN st."Status 1." = 'Nevyhovìl'
 	     	  AND st."Status 2." = 'Nevyhovìl'
 		  AND st."Body 1." < skv."Bodová hranice"
		  AND st."Body 2." < skv."Bodová hranice"
 		  THEN 'Nesoulad binár (+ oba posudky pod bodovaou hranicí), arbitr mù¾e obodovat na hranici'
	     ELSE 'Nesoulad binár'
	END "Dùvod arbitra"


FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id 
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN status st ON st.id_noshodnoceni = p.id
INNER JOIN posudky ps ON ps.id_noshodnoceni = p.id
INNER JOIN soubor_kriterii_vyzvy skv ON skv.id_vyzva = v.id AND skv."Poèet hodnotitelù" = 2 AND skv."Platnost do" is null 
-- INNER JOIN hodnoceni_status stp ON stp.id_noshodnoceni = p.id AND stp.id_krokvechodn = 488854

-- WHERE p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/24_063/0006485'


ORDER BY SUBSTR(p."Registraèní èíslo projektu",24) desc























