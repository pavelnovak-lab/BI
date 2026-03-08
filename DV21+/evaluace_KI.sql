WITH
prvnidruhy AS (
SELECT min(h."Poøadí") "Prvý poøadí",
       max(h."Poøadí") "Druhý poøadí",
       h.id_noshodnoceni,
       a."Poøadí" "Poøadí arbitr",
       count(h.id)
FROM hodnoceni h
LEFT JOIN (
     SELECT h."Poøadí",
     	    h.id_noshodnoceni,
	    h.id
     FROM hodnoceni h
     WHERE h."Platný" = 'A'
     AND h."Finalizováno" = 'A'
     AND h."Schváleno schvalovatelem" = 'A'
     AND h.id_krokvechodn = 488854 -- 2. krok VH
     AND h."Arbitr" = 'A' ) a ON a.id_noshodnoceni = h.id_noshodnoceni
WHERE h."Platný" = 'A'
AND h."Finalizováno" = 'A'
AND h."Schváleno schvalovatelem" = 'A'
AND h.id_krokvechodn = 488854 -- 2. krok VH
AND h."Opravný posudek" = 'N'
AND h."Arbitr" = 'N'
-- AND h.id_noshodnoceni = 28619333 -- p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000120' -- má arbitra
GROUP BY h.id_noshodnoceni,
      	 a."Poøadí"
HAVING count(h.id) IN (2,3) /* k ostranìní prj, pouze s jedním platným posudkem */ ),

kriteria AS (
SELECT kprvni."Poèet bodù" "H1 bodù",
       kdruhy."Poèet bodù" "H2 bodù",
       karb."Poèet bodù" "Arbitr",
       prvni.id "id_prvnihodn",
       druhy.id "id_druhehodn",
       arb.id "id_arbhodn",
       prvni.id_noshodnoceni 
FROM prvnidruhy pd
INNER JOIN hodnoceni prvni ON prvni.id_noshodnoceni = pd.id_noshodnoceni AND prvni."Poøadí" = pd."Prvý poøadí" AND prvni.id_krokvechodn = 488854
INNER JOIN hodnota_kriteria kprvni ON kprvni.id_hodnoceni = prvni.id 
INNER JOIN hodnoceni druhy ON druhy.id_noshodnoceni = pd.id_noshodnoceni AND druhy."Poøadí" = pd."Druhý poøadí" AND druhy.id_krokvechodn = 488854
INNER JOIN hodnota_kriteria kdruhy ON kdruhy.id_hodnoceni = druhy.id AND kdruhy."Kód" = kprvni."Kód"
LEFT JOIN hodnoceni arb ON arb.id_noshodnoceni = pd.id_noshodnoceni AND arb."Poøadí" = pd."Poøadí arbitr" AND arb.id_krokvechodn = 488854
LEFT JOIN hodnota_kriteria karb ON karb.id_hodnoceni = arb.id  AND karb."Kód" = kprvni."Kód"
WHERE kprvni."Kód" = 'D 28.'
AND kdruhy."Kód" = 'D 28.'
AND karb."Kód" = 'D 28.')


SELECT	v."Název výzvy" ,
	p."Registraèní èíslo projektu" ,
	w.kod "Kód stavu",
	CASE WHEN k."Arbitr" is null AND k."H1 bodù" >= 1 AND k."H2 bodù" >= 1 THEN 'Ano'
	     WHEN k."Arbitr" is not null AND k."Arbitr" >= 1 THEN 'Ano'
	     ELSE 'Ne' END AS "Relevantní pro KI 29 nebo 30",
	k."H1 bodù",
 	k."H2 bodù",
 	k."Arbitr",
	GROUP_CONCAT(DISTINCT cki."Kód") "Kód KI",
        GROUP_CONCAT(DISTINCT cki."Název") "Název KI",
        GROUP_CONCAT(DISTINCT ki."Klimatické zmìny - indikativní alokace") "Klimatické zmìny - indikativní alokace" ,
        GROUP_CONCAT(DISTINCT ki."Procentní podíl") "Procento KI"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
-- INNER JOIN prvnidruhy pd ON pd.id_noshodnoceni = p.id AND h.id_krokvechodn = 488854 AND 
INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id
INNER JOIN prvnidruhy pd ON pd.id_noshodnoceni = p.id 
INNER JOIN hodnota_kriteria hk ON hk.id_hodnoceni = h.id 
INNER JOIN v_rav_umscisstavwf w ON w.id = p.id_wfstav
INNER JOIN kriteria k ON k.id_noshodnoceni = p.id

LEFT JOIN kategorie_intervenci_oblast_intervence ki ON ki.id_projekt = p.id
LEFT JOIN ciselnik_oblast_intervence cki ON cki.id = ki.id_ki

WHERE h."Platný" = 'A'
AND h."Finalizováno" = 'A'
AND h."Schváleno schvalovatelem" = 'A'
--AND (v."Èíslo výzvy" = '01_22_002'
-- AND hk."Kód" = 'D 28.' 
AND p.id_vyzva = 19009827 -- inovace 1. výzva, 01_22_003
AND h.id_krokvechodn = 488854 -- 2. krok VH
AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/02/22_003/0000173'
AND w.kod not like 'PN%'
AND w.kod not IN ('PU22','PP20','PP22')

GROUP BY v."Název výzvy" ,
      p."Registraèní èíslo projektu" ,
	w.kod ,
 	k."H1 bodù",
 	k."H2 bodù",
 	k."Arbitr",
	"Relevantní pro KI 29 nebo 30"
