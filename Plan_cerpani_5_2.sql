SELECT p."Registraèní èíslo projektu" ,
       p.zadatel,
       -- v."Název výzvy",
       -- v."Èíslo výzvy",
       p.id_vyzva,
       p.kodwfstav,
       -- platba.zalohaskut "ZV",
       -- platba."Datum pøedlo¾ení",
       pol."Èástka celkem" "CZV",
       pol."Èástka za 1 rok" "ZV 2023",
       pol."Èástka za 2 rok" "ZV 2024",
       pol."Èástka za 3 rok" "ZV 2025",
       0.5* pol."Èástka celkem" "Dotace EU",
       0.5* pol."Èástka za 1 rok" "Dotace 2023",
       0.5* pol."Èástka za 2 rok" "Dotace 2024",
       0.5* pol."Èástka za 3 rok" "Dotace 2025"

FROM isum.v_bi_UmzProjekt p
-- INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
-- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UMFROZHlavicka roz ON roz.id_nrozpocet = p.id AND roz."Aktuální" = 'A'
INNER JOIN isum.v_bi_UMFRozpolozkyPrj pol ON pol.id_hlavicka = roz.id 

WHERE pol."Kód" = '1.1'
-- AND p.kodwfstav not like 'PN%'
AND p.id_vyzva = 1607294465 -- výzva 31_22_017


