with kriterium AS (
SELECT v."Èíslo výzvy" ,
       v."Název výzvy" ,
       p."Registraèní èíslo projektu",
       p.id id_projekt, 
       v.id id_vyzva,
       h.id id_hodnoceni,
       k.id id_kriterium,
       h."Arbitr",
       hdntl."Kód u¾ivatele" "Kód hodnotitele",
       k."Kód",
       k."Poèet bodù",
       k."Popis",
       -- st."Celkový výsledek - v bodech" "VH bodù projekt",
       -- cis."Název" "Status VH",
       h."Výsledek (v bodech)" "VH bodù posudek",
       CASE WHEN a.id_noshodnoceni is null THEN 'N'
	    ELSE 'A' END AS "Rozhodoval arbitr",
       CASE WHEN h.id = id_hodnoceni_prvni THEN 'H1'
       	    WHEN h.id = id_hodnoceni_druhy THEN 'H2'
	    ELSE 'Arbitr' END "Poøadí hodnotitele"
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id
INNER JOIN hodnotitel hdntl ON hdntl.id = h.id_hodnotitel
INNER JOIN hodnota_kriteria k ON k.id_hodnoceni = h.id 
-- INNER JOIN hodnoceni_status st ON st.id_noshodnoceni = p.id  -- AND (st.id_krokvechodn = 488854 OR (st.id_krokvechodn = 488849 AND v."Èíslo výzvy" IN ('01_23_011')))
-- INNER JOIN ciselnik_status_hodnoceni cis on cis.id = st.id_statushodn
LEFT JOIN (
     SELECT h.id_noshodnoceni
     FROM hodnoceni h
     WHERE h."Platný" = 'A'
     AND h."Finalizováno" = 'A'
     AND h."Schváleno schvalovatelem" = 'A'
     AND h.id_krokvechodn = 488854 /* 2. krok VH */
     AND h."Arbitr" = 'A') a ON a.id_noshodnoceni = p.id
INNER JOIN (
      SELECT MIN(h.id) "id_hodnoceni_prvni",
      	     MAX(h.id) "id_hodnoceni_druhy",
	     h.id_noshodnoceni
     FROM hodnoceni h
     WHERE h."Platný" = 'A'
     AND h."Finalizováno" = 'A'
     AND h."Schváleno schvalovatelem" = 'A'
     AND h.id_krokvechodn = 488854 /* 2. krok VH */
     AND h."Arbitr" = 'N'
     GROUP BY h.id_noshodnoceni) radnih ON radnih.id_noshodnoceni = p.id
WHERE h."Platný" = 'A'
AND h."Finalizováno" = 'A'
AND p."Registraèní èíslo projektu" in ('CZ.01.01.01/02/22_003/0000242', 'CZ.01.01.01/08/22_005/0000150','CZ.01.01.01/08/22_001/0000349','CZ.01.01.01/01/22_002/0000523','CZ.01.01.01/01/22_002/0000011')
AND h."Schváleno schvalovatelem" = 'A'
AND (
    -- (h.id_krokvechodn = 488854 AND k."Kód" = 'D 28.' AND v."Èíslo výzvy" = '01_22_003') -- Inovace
    -- OR
    (h.id_krokvechodn = 488854 AND k."Kód" = 'B1.' AND v."Èíslo výzvy" IN ('01_22_001','01_22_002','01_22_005')) -- PoC, Aplikace
    -- OR
    -- (h.id_krokvechodn = 488854 AND k."Kód" = 'D7' AND v."Èíslo výzvy" IN ('01_23_031','01_23_041','01_23_024')) -- SI
    -- OR
    -- (h.id_krokvechodn = 488849 AND k."Kód" = 'D7' AND v."Èíslo výzvy" IN ('01_23_030','01_23_040')) -- SI, Potenciál
    )

-- ORDER BY p."Registraèní èíslo projektu"
)

SELECT p."Registraèní èíslo projektu",
       case WHEN  k."Rozhodoval arbitr" = 'N' then avg(k."Poèet bodù")
       	    WHEN  k."Rozhodoval arbitr" = 'A' AND k."Arbitr" = 'A' then max(k."Poèet bodù")
       end "Body vavai + ket"
      

from projekt p
INNER JOIN kriterium k ON k.id_projekt = p.id

GROUP BY p."Registraèní èíslo projektu" , k."Rozhodoval arbitr", k."Arbitr" -- , k."Arbitr"-

having (case WHEN  k."Rozhodoval arbitr" = 'N' then avg(k."Poèet bodù")
       	    WHEN  k."Rozhodoval arbitr" = 'A' AND k."Arbitr" = 'A' then max(k."Poèet bodù")
       end) is not null
