SELECT p."Registraèní èíslo projektu",
       -- avg(hk."Poèet bodù") "Bodù"
       -- hk."Poèet bodù"
       hk."Kód"
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id AND h."Platný" = 'A' AND h."Finalizováno" = 'A' AND h."Schváleno schvalovatelem" = 'A' 
INNER JOIN hodnota_kriteria hk ON hk.id_hodnoceni = h.id -- AND (v."Èíslo výzvy" = '01_22_003' AND hk."Kód" = 'B 7.')


WHERE p."Registraèní èíslo projektu" IN (
-- 'CZ.01.01.01/01/22_002/0000322','CZ.01.01.01/02/22_003/0000181',
'CZ.01.01.01/08/22_001/0000163')
AND h.id_krokvechodn = 488854  -- 2. krok VH


GROUP BY p."Registraèní èíslo projektu" 
