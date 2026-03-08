SELECT v."Èíslo výzvy",
       v."Název výzvy",
       ci."Kód" "Kód Micíle",
       ci."Název" "Micíl",
       p."Registraèní èíslo projektu",
       p."Název projektu CZ",
       p.kodwfstav ,
       p.zadatel,
       zi."Poøadové èíslo ZoR/IoP",
       REPLACE(REPLACE(zi."Popis pokroku v realizaci", CHR(10), ' $ '), CHR(13), ' $ ') "Popis pokroku v realizaci",
       zi.kodwfstav,
       zi.wfstav,
       zi.DATUMSCHVALENI,
       zi.ZAVERECNA

FROM isum.v_bi_UmzProjekt p

INNER JOIN isum.v_bi_UmzVyzva v ON v.id = p.id_vyzva
INNER JOIN isum.v_bi_UMZZIProjekt zi ON zi.id_zad = p.id
INNER JOIN isum.v_bi_UMZCisTypZI ct ON ct.id = zi.id_CisTypZI
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = p.id_micil

WHERE ct."Poznámka" = 'ZOR'
  AND zi.kodwfstav <> 'P0'
  AND v."Èíslo výzvy" IN ('31_25_157', '31_22_018', '31_22_010', '31_22_008')

ORDER BY v."Èíslo výzvy", p."Registraèní èíslo projektu", zi."Poøadové èíslo ZoR/IoP"
