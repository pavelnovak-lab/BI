SELECT p.id id_projekt,
       h."Arbitr",
       AVG(p30."Poèet bodù") "Poèet bodù"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id
INNER JOIN hodnota_kriteria k ON k.id_hodnoceni = h.id
INNER JOIN hodnota_kriteria_pp30 p30 ON p30.id = k.id
LEFT JOIN (
     SELECT h.id_noshodnoceni
     FROM hodnoceni h
     -- INNER JOIN hodnota_kriteria_pp30 p30 ON p30.id = k.id
     WHERE h."Platný" = 'A'
     AND h."Finalizováno" = 'A'
     AND h."Schváleno schvalovatelem" = 'A'
     AND h.id_krokvechodn IN (488849, 488854) /* 1. i 2. krok VH */
     AND h."Arbitr" = 'A') a ON a.id_noshodnoceni = p.id

WHERE h."Platný" = 'A'
AND h."Finalizováno" = 'A'
AND h."Schváleno schvalovatelem" = 'A'
AND h."Opravný posudek" = 'N'
AND h.id_krokvechodn IN  (488854, 488849)  /* 2. krok VH a 1. krok VH */
/* Následující podmínka je specifická pro OP TAK (podle èísla výzvy nahlí¾ím do kriteria pro RIS3), v OP TAK mù¾e a nebo nemusí VH být, pokud je, mù¾e mít jeden nebo dva kroky, proto to rozdìlení v id_krokvechodn */
AND (
    (h.id_krokvechodn = 488854 AND k."Kód" = 'B 7.' AND v."Èíslo výzvy" = '01_22_003') -- Inovace
    OR
    (h.id_krokvechodn = 488854 AND k."Kód" = 'B1.' AND v."Èíslo výzvy" IN ('01_22_001','01_22_002','01_22_005','01_23_12','01_23_13','01_23_014'))
    -- ,'01_23_035','01_23_036')) -- PoC, Aplikace, Klastry, PZT,  nyní tedy bez PZT !!!!!
    OR
    (h.id_krokvechodn = 488854 AND k."Kód" = 'B1' AND v."Èíslo výzvy" IN ('01_23_024','01_23_030','01_23_031','01_23_041')) -- Potenciál, SI
    OR -- 1. krok VH
    (h.id_krokvechodn = 488849 AND k."Kód" = 'B1.' AND v."Èíslo výzvy" IN ('01_23_010','01_23_011')) -- Technologické platformy, Klastry
    OR -- 1. krok VH
    (h.id_krokvechodn = 488849 AND k."Kód" = 'B1' AND v."Èíslo výzvy" IN ('01_23_040')) -- Slu¾by infrastruktury pro ITI

   /* Bez VH jsou výzvy - Potenciál 01_22_004, 01_23_009, 01_23_015  */
   /* S VH ale bez bodovaného kritéria pro RIS3 jsou výzvy 01_23_016, 01_23_017, 01_23_021, 01_23_023, 01_23_027 */
   )

-- AND p."Registraèní èíslo projektu" IN ('CZ.01.01.01/02/22_003/0000242', 'CZ.01.01.01/08/22_005/0000150','CZ.01.01.01/08/22_001/0000349','CZ.01.01.01/01/22_002/0000523','CZ.01.01.01/01/22_002/0000011', 'CZ.01.01.01/01/22_002/0000120','CZ.01.01.01/01/22_002/0001137','CZ.01.01.01/01/22_002/0000529')


/* Následující podmínka odstraní duplicitní výpis projektu, kdy¾ rozhodoval arbitr a nezasahuje do tìch, kde nerozhodoval. Dùmyslnì tahám do GROUP BY h."Arbitr", tím zamezím prùmìru na v¹ech tøech posudcích (øádní hodnotitelé + arbitr) */
AND (a.id_noshodnoceni is null -- není platný posudek arbitra
     OR (a.id_noshodnoceni is not null AND h."Arbitr" = 'A') -- na projektu je arbitr, beru jen jeho posudek
    )




GROUP BY  p.id , h."Arbitr",  
)



