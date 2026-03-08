select 
p.id,
p."Registraèní èíslo projektu",
       sc."Specifický cíl RIS3 (Kód)",
       sc."Specifický cíl RIS3 (Název)",
       sc."Procento" as "Specifický cíl RIS3 (Procento)",
 
       ds."Doména specializace (Kód)",
       ds."Doména specializace (Název)",
       ds."Procento" as "Doména specializace (Procento)",
 
       vavai."VaVaI téma k DS (Kód)",    
       vavai."VaVaI téme k DS (Název)",
 
       ket."RIS3 KET (Kód)",    
       ket."RIS3 KET (Název)",
 
       shuv."Témata VaVaI v SHUV (Kód)",    
       shuv."Témata VaVaI v SHUV (Název)",
 
       cm."Cíle mise (Kód)",    
       cm."Cíle mise (Název)",       
       cm."Procento" as "Cíle mise (Procento)",
 
       dsk."Krajské DS (Kód)",   
       dsk."Krajské DS (Název)",
       dsk."Krajské DS (Název územní jednotky)",
       dsk."Procento" as "Krajské DS (Procento)",
 
--ris."Kód",
ris."RIS3 VaVaI téma k DS (body)",
--ris1."Kód",
ris1."RIS3 KET (body)",
--ris4."Kód",
ris4."RIS3 cíle mise (body)"


----------------------------------------
    WITH ris AS (
             SELECT a.id_projekt,
                    a."Èíslo výzvy",
                    a."Registraèní èíslo projektu",
                    k."Kód",
                    avg(p30."Poèet bodù") AS "RIS3 VaVaI téma k DS (body)"
             FROM (
                      SELECT a.id_projekt,
                             a."Èíslo výzvy",
                             a."Registraèní èíslo projektu",
                             k."Kód",
                             p30."Poèet bodù",
                             h."Arbitr",
                             sum(CASE WHEN (h."Arbitr" = 'A') THEN 1 ELSE 0 END) OVER(PARTITION BY id_projekt) AS pocet
                      FROM (
                               (
                                   (
                                       (
                                           SELECT v.id AS id_vyzva,
                                                  p.id AS id_projekt,
                                                  pl."Kód" AS "Operaèní program (Kód)",
                                                  pl."Název" AS "Operaèní program (Název)",
                                                  v."Èíslo výzvy",
                                                  v."Název výzvy",
                                                  p."Registraèní èíslo projektu",
                                                  p."Název projektu CZ" AS "Název projektu",
                                                  w.kod AS "Kód stavu",
                                                  w.nazev AS "Název stavu"
                                           FROM (
                                                    (
                                                        projekt AS p
                                                        INNER JOIN v_rav_umscisstavwf AS w
                                                            ON w.id = p.id_wfstav
                                                    )
                                                    INNER JOIN vyzva AS v
                                                        ON v.id = p.id_vyzva
                                                )
                                                INNER JOIN programova_linie AS pl
                                                    ON pl.id = v.id_program
                                           WHERE (
                                                     w.kod IN (
                                                         'PP30',
                                                         'PP31',
                                                         'PP36',
                                                         'PP37',
                                                         'PP40',
                                                         'PP41',
                                                         'PP42',
                                                         'PP43',
                                                         'PU30'
                                                     )
                                                     AND v."Èíslo výzvy" IN (
                                                         '01_22_001',
                                                         '01_22_002',
                                                         '01_22_005',
                                                         '01_23_010',
                                                         '01_23_011',
                                                         '01_23_012',
                                                         '01_23_013',
                                                         '01_23_014',
                                                         '01_23_024',
                                                         '01_23_030',
                                                         '01_23_031',
                                                         '01_23_040',
                                                         '01_23_041',
                                                         '01_24_046',
                                                         '01_24_045',
                                                         '01_24_047',
                                                         '01_24_048',
                                                         '01_24_052',
                                                         '01_24_056',
                                                         '01_24_061'
                                                     )
                                                 )
                                       ) AS a
                                       INNER JOIN soubor_kriterii_vyzvy AS skv
                                           ON (
                                               skv.id_vyzva = a.id_vyzva
                                               AND skv."Poèet hodnotitelù" = 2
                                               AND skv."Platnost do" IS NULL
                                           )
                                   )
                                   INNER JOIN hodnoceni AS h
                                       ON (h.id_noshodnoceni = a.id_projekt AND h.id_krokvechodn = skv.id_krokvechodn)
                               )
                               INNER JOIN hodnota_kriteria AS k
                                   ON k.id_hodnoceni = h.id
                           )
                           INNER JOIN hodnota_kriteria_pp30 AS p30
                               ON p30.id = k.id
                      WHERE (
                                h."Platný" = 'A'
                                AND h."Finalizováno" = 'A'
                                AND h."Schváleno schvalovatelem" = 'A'
                                AND h."Opravný posudek" = 'N'
                                AND h.id_krokvechodn IN (488854, 488849)
                                AND k."Kód" LIKE 'B1%'
                            )
                  )
             WHERE ((h."Arbitr" = 'N' AND pocet = 0) OR (h."Arbitr" = 'A' AND pocet = 1))
             GROUP BY a.id_projekt,
                      a."Èíslo výzvy",
                      a."Registraèní èíslo projektu",
                      k."Kód"
             SQL UNION ALL
             SELECT a.id_projekt,
                    a."Èíslo výzvy",
                    a."Registraèní èíslo projektu",
                    k."Kód",
                    avg(p30."Poèet bodù") AS "RIS3 VaVaI téma k DS (body)"
             FROM (
                      SELECT a.id_projekt,
                             a."Èíslo výzvy",
                             a."Registraèní èíslo projektu",
                             k."Kód",
                             p30."Poèet bodù",
                             h."Arbitr",
                             sum(CASE WHEN (h."Arbitr" = 'A') THEN 1 ELSE 0 END) OVER(PARTITION BY id_projekt) AS pocet
                      FROM (
                               (
                                   (
                                       (
                                           SELECT v.id AS id_vyzva,
                                                  p.id AS id_projekt,
                                                  pl."Kód" AS "Operaèní program (Kód)",
                                                  pl."Název" AS "Operaèní program (Název)",
                                                  v."Èíslo výzvy",
                                                  v."Název výzvy",
                                                  p."Registraèní èíslo projektu",
                                                  p."Název projektu CZ" AS "Název projektu",
                                                  w.kod AS "Kód stavu",
                                                  w.nazev AS "Název stavu"
                                           FROM (
                                                    (
                                                        projekt AS p
                                                        INNER JOIN v_rav_umscisstavwf AS w
                                                            ON w.id = p.id_wfstav
                                                    )
                                                    INNER JOIN vyzva AS v
                                                        ON v.id = p.id_vyzva
                                                )
                                                INNER JOIN programova_linie AS pl
                                                    ON pl.id = v.id_program
                                           WHERE (
                                                     w.kod IN (
                                                         'PP30',
                                                         'PP31',
                                                         'PP36',
                                                         'PP37',
                                                         'PP40',
                                                         'PP41',
                                                         'PP42',
                                                         'PP43',
                                                         'PU30'
                                                     )
                                                     AND v."Èíslo výzvy" IN ('01_22_003', '01_24_051')
                                                 )
                                       ) AS a
                                       INNER JOIN soubor_kriterii_vyzvy AS skv
                                           ON (
                                               skv.id_vyzva = a.id_vyzva
                                               AND skv."Poèet hodnotitelù" = 2
                                               AND skv."Platnost do" IS NULL
                                           )
                                   )
                                   INNER JOIN hodnoceni AS h
                                       ON (h.id_noshodnoceni = a.id_projekt AND h.id_krokvechodn = skv.id_krokvechodn)
                               )
                               INNER JOIN hodnota_kriteria AS k
                                   ON k.id_hodnoceni = h.id
                           )
                           INNER JOIN hodnota_kriteria_pp30 AS p30
                               ON p30.id = k.id
                      WHERE (
                                h."Platný" = 'A'
                                AND h."Finalizováno" = 'A'
                                AND h."Schváleno schvalovatelem" = 'A'
                                AND h."Opravný posudek" = 'N'
                                AND h.id_krokvechodn IN (488854, 488849)
                                AND k."Kód" = 'B 7.'
                            )
                  )
             WHERE ((h."Arbitr" = 'N' AND pocet = 0) OR (h."Arbitr" = 'A' AND pocet = 1))
             GROUP BY a.id_projekt,
                      a."Èíslo výzvy",
                      a."Registraèní èíslo projektu",
                      k."Kód"
         ),
         ris1 AS (
             SELECT a.id_projekt,
                    a."Èíslo výzvy",
                    a."Registraèní èíslo projektu",
                    k."Kód",
                    avg(p30."Poèet bodù") AS "RIS3 KET (body)"
             FROM (
                      SELECT a.id_projekt,
                             a."Èíslo výzvy",
                             a."Registraèní èíslo projektu",
                             k."Kód",
                             p30."Poèet bodù",
                             h."Arbitr",
                             sum(CASE WHEN (h."Arbitr" = 'A') THEN 1 ELSE 0 END) OVER(PARTITION BY id_projekt) AS pocet
                      FROM (
                               (
                                   (
                                       (
                                           SELECT v.id AS id_vyzva,
                                                  p.id AS id_projekt,
                                                  pl."Kód" AS "Operaèní program (Kód)",
                                                  pl."Název" AS "Operaèní program (Název)",
                                                  v."Èíslo výzvy",
                                                  v."Název výzvy",
                                                  p."Registraèní èíslo projektu",
                                                  p."Název projektu CZ" AS "Název projektu",
                                                  w.kod AS "Kód stavu",
                                                  w.nazev AS "Název stavu"
                                           FROM (
                                                    (
                                                        projekt AS p
                                                        INNER JOIN v_rav_umscisstavwf AS w
                                                            ON w.id = p.id_wfstav
                                                    )
                                                    INNER JOIN vyzva AS v
                                                        ON v.id = p.id_vyzva
                                                )
                                                INNER JOIN programova_linie AS pl
                                                    ON pl.id = v.id_program
                                           WHERE (
                                                     w.kod IN (
                                                         'PP30',
                                                         'PP31',
                                                         'PP36',
                                                         'PP37',
                                                         'PP40',
                                                         'PP41',
                                                         'PP42',
                                                         'PP43',
                                                         'PU30'
                                                     )
                                                     AND v."Èíslo výzvy" IN (
                                                         '01_22_001',
                                                         '01_22_002',
                                                         '01_22_005',
                                                         '01_23_010',
                                                         '01_23_011',
                                                         '01_23_012',
                                                         '01_23_013',
                                                         '01_23_014',
                                                         '01_23_024',
                                                         '01_23_030',
                                                         '01_23_031',
                                                         '01_23_040',
                                                         '01_23_041',
                                                         '01_24_063'
                                                     )
                                                 )
                                       ) AS a
                                       INNER JOIN soubor_kriterii_vyzvy AS skv
                                           ON (
                                               skv.id_vyzva = a.id_vyzva
                                               AND skv."Poèet hodnotitelù" = 2
                                               AND skv."Platnost do" IS NULL
                                           )
                                   )
                                   INNER JOIN hodnoceni AS h
                                       ON (h.id_noshodnoceni = a.id_projekt AND h.id_krokvechodn = skv.id_krokvechodn)
                               )
                               INNER JOIN hodnota_kriteria AS k
                                   ON k.id_hodnoceni = h.id
                           )
                           INNER JOIN hodnota_kriteria_pp30 AS p30
                               ON p30.id = k.id
                      WHERE (
                                h."Platný" = 'A'
                                AND h."Finalizováno" = 'A'
                                AND h."Schváleno schvalovatelem" = 'A'
                                AND h."Opravný posudek" = 'N'
                                AND h.id_krokvechodn IN (488854, 488849)
                                AND k."Kód" LIKE 'B1%'
                            )
                  )
             WHERE ((h."Arbitr" = 'N' AND pocet = 0) OR (h."Arbitr" = 'A' AND pocet = 1))
             GROUP BY a.id_projekt,
                      a."Èíslo výzvy",
                      a."Registraèní èíslo projektu",
                      k."Kód"
             SQL UNION ALL
             SELECT a.id_projekt,
                    a."Èíslo výzvy",
                    a."Registraèní èíslo projektu",
                    k."Kód",
                    avg(p30."Poèet bodù") AS "RIS3 KET (body)"
             FROM (
                      SELECT a.id_projekt,
                             a."Èíslo výzvy",
                             a."Registraèní èíslo projektu",
                             k."Kód",
                             p30."Poèet bodù",
                             h."Arbitr",
                             sum(CASE WHEN (h."Arbitr" = 'A') THEN 1 ELSE 0 END) OVER(PARTITION BY id_projekt) AS pocet
                      FROM (
                               (
                                   (
                                       (
                                           SELECT v.id AS id_vyzva,
                                                  p.id AS id_projekt,
                                                  pl."Kód" AS "Operaèní program (Kód)",
                                                  pl."Název" AS "Operaèní program (Název)",
                                                  v."Èíslo výzvy",
                                                  v."Název výzvy",
                                                  p."Registraèní èíslo projektu",
                                                  p."Název projektu CZ" AS "Název projektu",
                                                  w.kod AS "Kód stavu",
                                                  w.nazev AS "Název stavu"
                                           FROM (
                                                    (
                                                        projekt AS p
                                                        INNER JOIN v_rav_umscisstavwf AS w
                                                            ON w.id = p.id_wfstav
                                                    )
                                                    INNER JOIN vyzva AS v
                                                        ON v.id = p.id_vyzva
                                                )
                                                INNER JOIN programova_linie AS pl
                                                    ON pl.id = v.id_program
                                           WHERE (
                                                     w.kod IN (
                                                         'PP30',
                                                         'PP31',
                                                         'PP36',
                                                         'PP37',
                                                         'PP40',
                                                         'PP41',
                                                         'PP42',
                                                         'PP43',
                                                         'PU30'
                                                     )
                                                     AND v."Èíslo výzvy" IN (
                                                         '01_24_046',
                                                         '01_24_045',
                                                         '01_24_047',
                                                         '01_24_048',
                                                         '01_24_052',
                                                         '01_24_056',
                                                         '01_24_061'
                                                     )
                                                 )
                                       ) AS a
                                       INNER JOIN soubor_kriterii_vyzvy AS skv
                                           ON (
                                               skv.id_vyzva = a.id_vyzva
                                               AND skv."Poèet hodnotitelù" = 2
                                               AND skv."Platnost do" IS NULL
                                           )
                                   )
                                   INNER JOIN hodnoceni AS h
                                       ON (h.id_noshodnoceni = a.id_projekt AND h.id_krokvechodn = skv.id_krokvechodn)
                               )
                               INNER JOIN hodnota_kriteria AS k
                                   ON k.id_hodnoceni = h.id
                           )
                           INNER JOIN hodnota_kriteria_pp30 AS p30
                               ON p30.id = k.id
                      WHERE (
                                h."Platný" = 'A'
                                AND h."Finalizováno" = 'A'
                                AND h."Schváleno schvalovatelem" = 'A'
                                AND h."Opravný posudek" = 'N'
                                AND h.id_krokvechodn IN (488854, 488849)
                                AND k."Kód" LIKE 'B2%'
                            )
                  )
             WHERE ((h."Arbitr" = 'N' AND pocet = 0) OR (h."Arbitr" = 'A' AND pocet = 1))
             GROUP BY a.id_projekt,
                      a."Èíslo výzvy",
                      a."Registraèní èíslo projektu",
                      k."Kód"
             SQL UNION ALL
             SELECT a.id_projekt,
                    a."Èíslo výzvy",
                    a."Registraèní èíslo projektu",
                    k."Kód",
                    avg(p30."Poèet bodù") AS "RIS3 KET (body)"
             FROM (
                      SELECT a.id_projekt,
                             a."Èíslo výzvy",
                             a."Registraèní èíslo projektu",
                             k."Kód",
                             p30."Poèet bodù",
                             h."Arbitr",
                             sum(CASE WHEN (h."Arbitr" = 'A') THEN 1 ELSE 0 END) OVER(PARTITION BY id_projekt) AS pocet
                      FROM (
                               (
                                   (
                                       (
                                           SELECT v.id AS id_vyzva,
                                                  p.id AS id_projekt,
                                                  pl."Kód" AS "Operaèní program (Kód)",
                                                  pl."Název" AS "Operaèní program (Název)",
                                                  v."Èíslo výzvy",
                                                  v."Název výzvy",
                                                  p."Registraèní èíslo projektu",
                                                  p."Název projektu CZ" AS "Název projektu",
                                                  w.kod AS "Kód stavu",
                                                  w.nazev AS "Název stavu"
                                           FROM (
                                                    (
                                                        projekt AS p
                                                        INNER JOIN v_rav_umscisstavwf AS w
                                                            ON w.id = p.id_wfstav
                                                    )
                                                    INNER JOIN vyzva AS v
                                                        ON v.id = p.id_vyzva
                                                )
                                                INNER JOIN programova_linie AS pl
                                                    ON pl.id = v.id_program
                                           WHERE (
                                                     w.kod IN (
                                                         'PP30',
                                                         'PP31',
                                                         'PP36',
                                                         'PP37',
                                                         'PP40',
                                                         'PP41',
                                                         'PP42',
                                                         'PP43',
                                                         'PU30'
                                                     )
                                                     AND v."Èíslo výzvy" IN ('01_22_003')
                                                 )
                                       ) AS a
                                       INNER JOIN soubor_kriterii_vyzvy AS skv
                                           ON (
                                               skv.id_vyzva = a.id_vyzva
                                               AND skv."Poèet hodnotitelù" = 2
                                               AND skv."Platnost do" IS NULL
                                           )
                                   )
                                   INNER JOIN hodnoceni AS h
                                       ON (h.id_noshodnoceni = a.id_projekt AND h.id_krokvechodn = skv.id_krokvechodn)
                               )
                               INNER JOIN hodnota_kriteria AS k
                                   ON k.id_hodnoceni = h.id
                           )
                           INNER JOIN hodnota_kriteria_pp30 AS p30
                               ON p30.id = k.id
                      WHERE (
                                h."Platný" = 'A'
                                AND h."Finalizováno" = 'A'
                                AND h."Schváleno schvalovatelem" = 'A'
                                AND h."Opravný posudek" = 'N'
                                AND h.id_krokvechodn IN (488854, 488849)
                                AND k."Kód" = 'B 7.'
                            )
                  )
             WHERE ((h."Arbitr" = 'N' AND pocet = 0) OR (h."Arbitr" = 'A' AND pocet = 1))
             GROUP BY a.id_projekt,
                      a."Èíslo výzvy",
                      a."Registraèní èíslo projektu",
                      k."Kód"
             SQL UNION ALL
             SELECT a.id_projekt,
                    a."Èíslo výzvy",
                    a."Registraèní èíslo projektu",
                    k."Kód",
                    avg(p30."Poèet bodù") AS "RIS3 KET (body)"
             FROM (
                      SELECT a.id_projekt,
                             a."Èíslo výzvy",
                             a."Registraèní èíslo projektu",
                             k."Kód",
                             p30."Poèet bodù",
                             h."Arbitr",
                             sum(CASE WHEN (h."Arbitr" = 'A') THEN 1 ELSE 0 END) OVER(PARTITION BY id_projekt) AS pocet
                      FROM (
                               (
                                   (
                                       (
                                           SELECT v.id AS id_vyzva,
                                                  p.id AS id_projekt,
                                                  pl."Kód" AS "Operaèní program (Kód)",
                                                  pl."Název" AS "Operaèní program (Název)",
                                                  v."Èíslo výzvy",
                                                  v."Název výzvy",
                                                  p."Registraèní èíslo projektu",
                                                  p."Název projektu CZ" AS "Název projektu",
                                                  w.kod AS "Kód stavu",
                                                  w.nazev AS "Název stavu"
                                           FROM (
                                                    (
                                                        projekt AS p
                                                        INNER JOIN v_rav_umscisstavwf AS w
                                                            ON w.id = p.id_wfstav
                                                    )
                                                    INNER JOIN vyzva AS v
                                                        ON v.id = p.id_vyzva
                                                )
                                                INNER JOIN programova_linie AS pl
                                                    ON pl.id = v.id_program
                                           WHERE (
                                                     w.kod IN (
                                                         'PP30',
                                                         'PP31',
                                                         'PP36',
                                                         'PP37',
                                                         'PP40',
                                                         'PP41',
                                                         'PP42',
                                                         'PP43',
                                                         'PU30'
                                                     )
                                                     AND v."Èíslo výzvy" IN ('01_24_051')
                                                 )
                                       ) AS a
                                       INNER JOIN soubor_kriterii_vyzvy AS skv
                                           ON (
                                               skv.id_vyzva = a.id_vyzva
                                               AND skv."Poèet hodnotitelù" = 2
                                               AND skv."Platnost do" IS NULL
                                           )
                                   )
                                   INNER JOIN hodnoceni AS h
                                       ON (h.id_noshodnoceni = a.id_projekt AND h.id_krokvechodn = skv.id_krokvechodn)
                               )
                               INNER JOIN hodnota_kriteria AS k
                                   ON k.id_hodnoceni = h.id
                           )
                           INNER JOIN hodnota_kriteria_pp30 AS p30
                               ON p30.id = k.id
                      WHERE (
                                h."Platný" = 'A'
                                AND h."Finalizováno" = 'A'
                                AND h."Schváleno schvalovatelem" = 'A'
                                AND h."Opravný posudek" = 'N'
                                AND h.id_krokvechodn IN (488854, 488849)
                                AND k."Kód" = 'B 8.'
                            )
                  )
             WHERE ((h."Arbitr" = 'N' AND pocet = 0) OR (h."Arbitr" = 'A' AND pocet = 1))
             GROUP BY a.id_projekt,
                      a."Èíslo výzvy",
                      a."Registraèní èíslo projektu",
                      k."Kód"
         ),
         ris4 AS (
             SELECT a.id_projekt,
                    a."Èíslo výzvy",
                    a."Registraèní èíslo projektu",
                    k."Kód",
                    avg(p30."Poèet bodù") AS "RIS3 cíle mise (body)"
             FROM (
                      SELECT a.id_projekt,
                             a."Èíslo výzvy",
                             a."Registraèní èíslo projektu",
                             k."Kód",
                             p30."Poèet bodù",
                             h."Arbitr",
                             sum(CASE WHEN (h."Arbitr" = 'A') THEN 1 ELSE 0 END) OVER(PARTITION BY id_projekt) AS pocet
                      FROM (
                               (
                                   (
                                       (
                                           SELECT v.id AS id_vyzva,
                                                  p.id AS id_projekt,
                                                  pl."Kód" AS "Operaèní program (Kód)",
                                                  pl."Název" AS "Operaèní program (Název)",
                                                  v."Èíslo výzvy",
                                                  v."Název výzvy",
                                                  p."Registraèní èíslo projektu",
                                                  p."Název projektu CZ" AS "Název projektu",
                                                  w.kod AS "Kód stavu",
                                                  w.nazev AS "Název stavu"
                                           FROM (
                                                    (
                                                        projekt AS p
                                                        INNER JOIN v_rav_umscisstavwf AS w
                                                            ON w.id = p.id_wfstav
                                                    )
                                                    INNER JOIN vyzva AS v
                                                        ON v.id = p.id_vyzva
                                                )
                                                INNER JOIN programova_linie AS pl
                                                    ON pl.id = v.id_program
                                           WHERE (
                                                     w.kod IN (
                                                         'PP30',
                                                         'PP31',
                                                         'PP36',
                                                         'PP37',
                                                         'PP40',
                                                         'PP41',
                                                         'PP42',
                                                         'PP43',
                                                         'PU30'
                                                     )
                                                     AND v."Èíslo výzvy" IN ('01_23_039')
                                                 )
                                       ) AS a
                                       INNER JOIN soubor_kriterii_vyzvy AS skv
                                           ON (
                                               skv.id_vyzva = a.id_vyzva
                                               AND skv."Poèet hodnotitelù" = 2
                                               AND skv."Platnost do" IS NULL
                                           )
                                   )
                                   INNER JOIN hodnoceni AS h
                                       ON (h.id_noshodnoceni = a.id_projekt AND h.id_krokvechodn = skv.id_krokvechodn)
                               )
                               INNER JOIN hodnota_kriteria AS k
                                   ON k.id_hodnoceni = h.id
                           )
                           INNER JOIN hodnota_kriteria_pp30 AS p30
                               ON p30.id = k.id
                      WHERE (
                                h."Platný" = 'A'
                                AND h."Finalizováno" = 'A'
                                AND h."Schváleno schvalovatelem" = 'A'
                                AND h."Opravný posudek" = 'N'
                                AND h.id_krokvechodn IN (488854, 488849)
                                AND k."Kód" LIKE 'B1 E'
                            )
                  )
             WHERE ((h."Arbitr" = 'N' AND pocet = 0) OR (h."Arbitr" = 'A' AND pocet = 1))
             GROUP BY a.id_projekt,
                      a."Èíslo výzvy",
                      a."Registraèní èíslo projektu",
                      k."Kód"
             SQL UNION ALL
             SELECT a.id_projekt,
                    a."Èíslo výzvy",
                    a."Registraèní èíslo projektu",
                    k."Kód",
                    avg(p30."Poèet bodù") AS "RIS3 cíle mise (body)"
             FROM (
                      SELECT a.id_projekt,
                             a."Èíslo výzvy",
                             a."Registraèní èíslo projektu",
                             k."Kód",
                             p30."Poèet bodù",
                             h."Arbitr",
                             sum(CASE WHEN (h."Arbitr" = 'A') THEN 1 ELSE 0 END) OVER(PARTITION BY id_projekt) AS pocet
                      FROM (
                               (
                                   (
                                       (
                                           SELECT v.id AS id_vyzva,
                                                  p.id AS id_projekt,
                                                  pl."Kód" AS "Operaèní program (Kód)",
                                                  pl."Název" AS "Operaèní program (Název)",
                                                  v."Èíslo výzvy",
                                                  v."Název výzvy",
                                                  p."Registraèní èíslo projektu",
                                                  w.kod AS "Kód stavu",
                                                  w.nazev AS "Název stavu"
                                           FROM (
                                                    (
                                                        projekt AS p
                                                        INNER JOIN v_rav_umscisstavwf AS w
                                                            ON w.id = p.id_wfstav
                                                    )
                                                    INNER JOIN vyzva AS v
                                                        ON v.id = p.id_vyzva
                                                )
                                                INNER JOIN programova_linie AS pl
                                                    ON pl.id = v.id_program
                                           WHERE (
                                                     w.kod IN (
                                                         'PP30',
                                                         'PP31',
                                                         'PP36',
                                                         'PP37',
                                                         'PP40',
                                                         'PP41',
                                                         'PP42',
                                                         'PP43',
                                                         'PU30'
                                                     )
                                                     AND v."Èíslo výzvy" IN ('01_24_063')
                                                 )
                                       ) AS a
                                       INNER JOIN soubor_kriterii_vyzvy AS skv
                                           ON (
                                               skv.id_vyzva = a.id_vyzva
                                               AND skv."Poèet hodnotitelù" = 2
                                               AND skv."Platnost do" IS NULL
                                           )
                                   )
                                   INNER JOIN hodnoceni AS h
                                       ON (h.id_noshodnoceni = a.id_projekt AND h.id_krokvechodn = skv.id_krokvechodn)
                               )
                               INNER JOIN hodnota_kriteria AS k
                                   ON k.id_hodnoceni = h.id
                           )
                           INNER JOIN hodnota_kriteria_pp30 AS p30
                               ON p30.id = k.id
                      WHERE (
                                h."Platný" = 'A'
                                AND h."Finalizováno" = 'A'
                                AND h."Schváleno schvalovatelem" = 'A'
                                AND h."Opravný posudek" = 'N'
                                AND h.id_krokvechodn IN (488854, 488849)
                                AND k."Kód" LIKE 'B2%'
                            )
                  )
             WHERE ((h."Arbitr" = 'N' AND pocet = 0) OR (h."Arbitr" = 'A' AND pocet = 1))
             GROUP BY a.id_projekt,
                      a."Èíslo výzvy",
                      a."Registraèní èíslo projektu",
                      k."Kód"
             SQL UNION ALL
             SELECT a.id_projekt,
                    a."Èíslo výzvy",
                    a."Registraèní èíslo projektu",
                    k."Kód",
                    avg(p30."Poèet bodù") AS "RIS3 cíle mise (body)"
             FROM (
                      SELECT a.id_projekt,
                             a."Èíslo výzvy",
                             a."Registraèní èíslo projektu",
                             k."Kód",
                             p30."Poèet bodù",
                             h."Arbitr",
                             sum(CASE WHEN (h."Arbitr" = 'A') THEN 1 ELSE 0 END) OVER(PARTITION BY id_projekt) AS pocet
                      FROM (
                               (
                                   (
                                       (
                                           SELECT v.id AS id_vyzva,
                                                  p.id AS id_projekt,
                                                  pl."Kód" AS "Operaèní program (Kód)",
                                                  pl."Název" AS "Operaèní program (Název)",
                                                  v."Èíslo výzvy",
                                                  v."Název výzvy",
                                                  p."Registraèní èíslo projektu",
                                                  w.kod AS "Kód stavu",
                                                  w.nazev AS "Název stavu"
                                           FROM (
                                                    (
                                                        projekt AS p
                                                        INNER JOIN v_rav_umscisstavwf AS w
                                                            ON w.id = p.id_wfstav
                                                    )
                                                    INNER JOIN vyzva AS v
                                                        ON v.id = p.id_vyzva
                                                )
                                                INNER JOIN programova_linie AS pl
                                                    ON pl.id = v.id_program
                                           WHERE (
                                                     w.kod IN (
                                                         'PP30',
                                                         'PP31',
                                                         'PP36',
                                                         'PP37',
                                                         'PP40',
                                                         'PP41',
                                                         'PP42',
                                                         'PP43',
                                                         'PU30'
                                                     )
                                                     AND v."Èíslo výzvy" IN ('01_24_056')
                                                 )
                                       ) AS a
                                       INNER JOIN soubor_kriterii_vyzvy AS skv
                                           ON (
                                               skv.id_vyzva = a.id_vyzva
                                               AND skv."Poèet hodnotitelù" = 2
                                               AND skv."Platnost do" IS NULL
                                           )
                                   )
                                   INNER JOIN hodnoceni AS h
                                       ON (h.id_noshodnoceni = a.id_projekt AND h.id_krokvechodn = skv.id_krokvechodn)
                               )
                               INNER JOIN hodnota_kriteria AS k
                                   ON k.id_hodnoceni = h.id
                           )
                           INNER JOIN hodnota_kriteria_pp30 AS p30
                               ON p30.id = k.id
                      WHERE (
                                h."Platný" = 'A'
                                AND h."Finalizováno" = 'A'
                                AND h."Schváleno schvalovatelem" = 'A'
                                AND h."Opravný posudek" = 'N'
                                AND h.id_krokvechodn IN (488854, 488849)
                                AND k."Kód" = 'B3'
                            )
                  )
             WHERE ((h."Arbitr" = 'N' AND pocet = 0) OR (h."Arbitr" = 'A' AND pocet = 1))
             GROUP BY a.id_projekt,
                      a."Èíslo výzvy",
                      a."Registraèní èíslo projektu",
                      k."Kód"
             SQL UNION ALL
             SELECT a.id_projekt,
                    a."Èíslo výzvy",
                    a."Registraèní èíslo projektu",
                    k."Kód",
                    avg(p30."Poèet bodù") AS "RIS3 cíle mise (body)"
             FROM (
                      SELECT a.id_projekt,
                             a."Èíslo výzvy",
                             a."Registraèní èíslo projektu",
                             k."Kód",
                             p30."Poèet bodù",
                             h."Arbitr",
                             sum(CASE WHEN (h."Arbitr" = 'A') THEN 1 ELSE 0 END) OVER(PARTITION BY id_projekt) AS pocet
                      FROM (
                               (
                                   (
                                       (
                                           SELECT v.id AS id_vyzva,
                                                  p.id AS id_projekt,
                                                  pl."Kód" AS "Operaèní program (Kód)",
                                                  pl."Název" AS "Operaèní program (Název)",
                                                  v."Èíslo výzvy",
                                                  v."Název výzvy",
                                                  p."Registraèní èíslo projektu",
                                                  w.kod AS "Kód stavu",
                                                  w.nazev AS "Název stavu"
                                           FROM (
                                                    (
                                                        projekt AS p
                                                        INNER JOIN v_rav_umscisstavwf AS w
                                                            ON w.id = p.id_wfstav
                                                    )
                                                    INNER JOIN vyzva AS v
                                                        ON v.id = p.id_vyzva
                                                )
                                                INNER JOIN programova_linie AS pl
                                                    ON pl.id = v.id_program
                                           WHERE (
                                                     w.kod IN (
                                                         'PP30',
                                                         'PP31',
                                                         'PP36',
                                                         'PP37',
                                                         'PP40',
                                                         'PP41',
                                                         'PP42',
                                                         'PP43',
                                                         'PU30'
                                                     )
                                                     AND v."Èíslo výzvy" IN ('01_24_045', '01_24_047', '01_24_061')
                                                 )
                                       ) AS a
                                       INNER JOIN soubor_kriterii_vyzvy AS skv
                                           ON (
                                               skv.id_vyzva = a.id_vyzva
                                               AND skv."Poèet hodnotitelù" = 2
                                               AND skv."Platnost do" IS NULL
                                           )
                                   )
                                   INNER JOIN hodnoceni AS h
                                       ON (h.id_noshodnoceni = a.id_projekt AND h.id_krokvechodn = skv.id_krokvechodn)
                               )
                               INNER JOIN hodnota_kriteria AS k
                                   ON k.id_hodnoceni = h.id
                           )
                           INNER JOIN hodnota_kriteria_pp30 AS p30
                               ON p30.id = k.id
                      WHERE (
                                h."Platný" = 'A'
                                AND h."Finalizováno" = 'A'
                                AND h."Schváleno schvalovatelem" = 'A'
                                AND h."Opravný posudek" = 'N'
                                AND h.id_krokvechodn IN (488854, 488849)
                                AND k."Kód" LIKE 'D5%'
                            )
                  )
             WHERE ((h."Arbitr" = 'N' AND pocet = 0) OR (h."Arbitr" = 'A' AND pocet = 1))
             GROUP BY a.id_projekt,
                      a."Èíslo výzvy",
                      a."Registraèní èíslo projektu",
                      k."Kód"
             SQL UNION ALL
             SELECT a.id_projekt,
                    a."Èíslo výzvy",
                    a."Registraèní èíslo projektu",
                    k."Kód",
                    avg(p30."Poèet bodù") AS "RIS3 cíle mise (body)"
             FROM (
                      SELECT a.id_projekt,
                             a."Èíslo výzvy",
                             a."Registraèní èíslo projektu",
                             k."Kód",
                             p30."Poèet bodù",
                             h."Arbitr",
                             sum(CASE WHEN (h."Arbitr" = 'A') THEN 1 ELSE 0 END) OVER(PARTITION BY id_projekt) AS pocet
                      FROM (
                               (
                                   (
                                       (
                                           SELECT v.id AS id_vyzva,
                                                  p.id AS id_projekt,
                                                  pl."Kód" AS "Operaèní program (Kód)",
                                                  pl."Název" AS "Operaèní program (Název)",
                                                  v."Èíslo výzvy",
                                                  v."Název výzvy",
                                                  p."Registraèní èíslo projektu",
                                                  w.kod AS "Kód stavu",
                                                  w.nazev AS "Název stavu"
                                           FROM (
                                                    (
                                                        projekt AS p
                                                        INNER JOIN v_rav_umscisstavwf AS w
                                                            ON w.id = p.id_wfstav
                                                    )
                                                    INNER JOIN vyzva AS v
                                                        ON v.id = p.id_vyzva
                                                )
                                                INNER JOIN programova_linie AS pl
                                                    ON pl.id = v.id_program
                                           WHERE (
                                                     w.kod IN (
                                                         'PP30',
                                                         'PP31',
                                                         'PP36',
                                                         'PP37',
                                                         'PP40',
                                                         'PP41',
                                                         'PP42',
                                                         'PP43',
                                                         'PU30'
                                                     )
                                                     AND v."Èíslo výzvy" IN (
                                                         '01_23_024',
                                                         '01_23_030',
                                                         '01_23_031',
                                                         '01_23_041',
                                                         '01_23_040'
                                                     )
                                                 )
                                       ) AS a
                                       INNER JOIN soubor_kriterii_vyzvy AS skv
                                           ON (
                                               skv.id_vyzva = a.id_vyzva
                                               AND skv."Poèet hodnotitelù" = 2
                                               AND skv."Platnost do" IS NULL
                                           )
                                   )
                                   INNER JOIN hodnoceni AS h
                                       ON (h.id_noshodnoceni = a.id_projekt AND h.id_krokvechodn = skv.id_krokvechodn)
                               )
                               INNER JOIN hodnota_kriteria AS k
                                   ON k.id_hodnoceni = h.id
                           )
                           INNER JOIN hodnota_kriteria_pp30 AS p30
                               ON p30.id = k.id
                      WHERE (
                                h."Platný" = 'A'
                                AND h."Finalizováno" = 'A'
                                AND h."Schváleno schvalovatelem" = 'A'
                                AND h."Opravný posudek" = 'N'
                                AND h.id_krokvechodn IN (488854, 488849)
                                AND k."Kód" LIKE 'D7%'
                            )
                  )
             WHERE ((h."Arbitr" = 'N' AND pocet = 0) OR (h."Arbitr" = 'A' AND pocet = 1))
             GROUP BY a.id_projekt,
                      a."Èíslo výzvy",
                      a."Registraèní èíslo projektu",
                      k."Kód"
             SQL UNION ALL
             SELECT a.id_projekt,
                    a."Èíslo výzvy",
                    a."Registraèní èíslo projektu",
                    k."Kód",
                    avg(p30."Poèet bodù") AS "RIS3 cíle mise (body)"
             FROM (
                      SELECT a.id_projekt,
                             a."Èíslo výzvy",
                             a."Registraèní èíslo projektu",
                             k."Kód",
                             p30."Poèet bodù",
                             h."Arbitr",
                             sum(CASE WHEN (h."Arbitr" = 'A') THEN 1 ELSE 0 END) OVER(PARTITION BY id_projekt) AS pocet
                      FROM (
                               (
                                   (
                                       (
                                           SELECT v.id AS id_vyzva,
                                                  p.id AS id_projekt,
                                                  pl."Kód" AS "Operaèní program (Kód)",
                                                  pl."Název" AS "Operaèní program (Název)",
                                                  v."Èíslo výzvy",
                                                  v."Název výzvy",
                                                  p."Registraèní èíslo projektu",
                                                  w.kod AS "Kód stavu",
                                                  w.nazev AS "Název stavu"
                                           FROM (
                                                    (
                                                        projekt AS p
                                                        INNER JOIN v_rav_umscisstavwf AS w
                                                            ON w.id = p.id_wfstav
                                                    )
                                                    INNER JOIN vyzva AS v
                                                        ON v.id = p.id_vyzva
                                                )
                                                INNER JOIN programova_linie AS pl
                                                    ON pl.id = v.id_program
                                           WHERE (
                                                     w.kod IN (
                                                         'PP30',
                                                         'PP31',
                                                         'PP36',
                                                         'PP37',
                                                         'PP40',
                                                         'PP41',
                                                         'PP42',
                                                         'PP43',
                                                         'PU30'
                                                     )
                                                     AND v."Èíslo výzvy" IN ('01_24_046')
                                                 )
                                       ) AS a
                                       INNER JOIN soubor_kriterii_vyzvy AS skv
                                           ON (
                                               skv.id_vyzva = a.id_vyzva
                                               AND skv."Poèet hodnotitelù" = 2
                                               AND skv."Platnost do" IS NULL
                                           )
                                   )
                                   INNER JOIN hodnoceni AS h
                                       ON (h.id_noshodnoceni = a.id_projekt AND h.id_krokvechodn = skv.id_krokvechodn)
                               )
                               INNER JOIN hodnota_kriteria AS k
                                   ON k.id_hodnoceni = h.id
                           )
                           INNER JOIN hodnota_kriteria_pp30 AS p30
                               ON p30.id = k.id
                      WHERE (
                                h."Platný" = 'A'
                                AND h."Finalizováno" = 'A'
                                AND h."Schváleno schvalovatelem" = 'A'
                                AND h."Opravný posudek" = 'N'
                                AND h.id_krokvechodn IN (488854, 488849)
                                AND k."Kód" = 'D6.'
                            )
                  )
             WHERE ((h."Arbitr" = 'N' AND pocet = 0) OR (h."Arbitr" = 'A' AND pocet = 1))
             GROUP BY a.id_projekt,
                      a."Èíslo výzvy",
                      a."Registraèní èíslo projektu",
                      k."Kód"
             SQL UNION ALL
             SELECT a.id_projekt,
                    a."Èíslo výzvy",
                    a."Registraèní èíslo projektu",
                    k."Kód",
                    avg(p30."Poèet bodù") AS "RIS3 cíle mise (body)"
             FROM (
                      SELECT a.id_projekt,
                             a."Èíslo výzvy",
                             a."Registraèní èíslo projektu",
                             k."Kód",
                             p30."Poèet bodù",
                             h."Arbitr",
                             sum(CASE WHEN (h."Arbitr" = 'A') THEN 1 ELSE 0 END) OVER(PARTITION BY id_projekt) AS pocet
                      FROM (
                               (
                                   (
                                       (
                                           SELECT v.id AS id_vyzva,
                                                  p.id AS id_projekt,
                                                  pl."Kód" AS "Operaèní program (Kód)",
                                                  pl."Název" AS "Operaèní program (Název)",
                                                  v."Èíslo výzvy",
                                                  v."Název výzvy",
                                                  p."Registraèní èíslo projektu",
                                                  w.kod AS "Kód stavu",
                                                  w.nazev AS "Název stavu"
                                           FROM (
                                                    (
                                                        projekt AS p
                                                        INNER JOIN v_rav_umscisstavwf AS w
                                                            ON w.id = p.id_wfstav
                                                    )
                                                    INNER JOIN vyzva AS v
                                                        ON v.id = p.id_vyzva
                                                )
                                                INNER JOIN programova_linie AS pl
                                                    ON pl.id = v.id_program
                                           WHERE (
                                                     w.kod IN (
                                                         'PP30',
                                                         'PP31',
                                                         'PP36',
                                                         'PP37',
                                                         'PP40',
                                                         'PP41',
                                                         'PP42',
                                                         'PP43',
                                                         'PU30'
                                                     )
                                                     AND v."Èíslo výzvy" IN ('01_24_051')
                                                 )
                                       ) AS a
                                       INNER JOIN soubor_kriterii_vyzvy AS skv
                                           ON (
                                               skv.id_vyzva = a.id_vyzva
                                               AND skv."Poèet hodnotitelù" = 2
                                               AND skv."Platnost do" IS NULL
                                           )
                                   )
                                   INNER JOIN hodnoceni AS h
                                       ON (h.id_noshodnoceni = a.id_projekt AND h.id_krokvechodn = skv.id_krokvechodn)
                               )
                               INNER JOIN hodnota_kriteria AS k
                                   ON k.id_hodnoceni = h.id
                           )
                           INNER JOIN hodnota_kriteria_pp30 AS p30
                               ON p30.id = k.id
                      WHERE (
                                h."Platný" = 'A'
                                AND h."Finalizováno" = 'A'
                                AND h."Schváleno schvalovatelem" = 'A'
                                AND h."Opravný posudek" = 'N'
                                AND h.id_krokvechodn IN (488854, 488849)
                                AND k."Kód" = 'D 22.'
                            )
                  )
             WHERE ((h."Arbitr" = 'N' AND pocet = 0) OR (h."Arbitr" = 'A' AND pocet = 1))
             GROUP BY a.id_projekt,
                      a."Èíslo výzvy",
                      a."Registraèní èíslo projektu",
                      k."Kód"
         )
    SELECT p.id,
           p."Registraèní èíslo projektu",
           sc."Specifický cíl RIS3 (Kód)",
           sc."Specifický cíl RIS3 (Název)",
           sc."Procento" AS "Specifický cíl RIS3 (Procento)",
           ds."Doména specializace (Kód)",
           ds."Doména specializace (Název)",
           ds."Procento" AS "Doména specializace (Procento)",
           vavai."VaVaI téma k DS (Kód)",
           vavai."VaVaI téme k DS (Název)",
           ket."RIS3 KET (Kód)",
           ket."RIS3 KET (Název)",
           shuv."Témata VaVaI v SHUV (Kód)",
           shuv."Témata VaVaI v SHUV (Název)",
           cm."Cíle mise (Kód)",
           cm."Cíle mise (Název)",
           cm."Procento" AS "Cíle mise (Procento)",
           dsk."Krajské DS (Kód)",
           dsk."Krajské DS (Název)",
           dsk."Krajské DS (Název územní jednotky)",
           dsk."Procento" AS "Krajské DS (Procento)",
           ris."RIS3 VaVaI téma k DS (body)",
           ris1."RIS3 KET (body)",
           ris4."RIS3 cíle mise (body)"
    FROM (
             (
                 (
                     (
                         (
                             (
                                 (
                                     (
                                         (
                                             (
                                                 (
                                                     (
                                                         projekt AS p
                                                         INNER JOIN v_rav_umscisstavwf AS w
                                                             ON w.id = p.id_wfstav
                                                     )
                                                     INNER JOIN vyzva AS v
                                                         ON v.id = p.id_vyzva
                                                 )
                                                 INNER JOIN programova_linie AS pl
                                                     ON pl.id = v.id_program
                                             )
                                             LEFT OUTER JOIN ris
                                                 ON ris.id_projekt = p.id
                                         )
                                         LEFT OUTER JOIN ris1
                                             ON ris1.id_projekt = p.id
                                     )
                                     LEFT OUTER JOIN ris4
                                         ON ris4.id_projekt = p.id
                                 )
                                 INNER JOIN (
                                     SELECT rsc."Kód" AS "Specifický cíl RIS3 (Kód)",
                                            rsc."Název" AS "Specifický cíl RIS3 (Název)",
                                            pr.id_projekt,
                                            pr."Procento"
                                     FROM projekt_ris3 AS pr
                                          INNER JOIN ciselnik_ris3_specificky_cil AS rsc
                                              ON pr.id_ris3 = rsc.id
                                 ) AS sc
                                     ON sc.id_projekt = p.id
                             )
                             LEFT OUTER JOIN (
                                 SELECT rds."Kód" AS "Doména specializace (Kód)",
                                        rds."Název" AS "Doména specializace (Název)",
                                        pr.id_projekt,
                                        pr."Procento",
                                        pr.id AS id_ds
                                 FROM projekt_ris3 AS pr
                                      INNER JOIN ciselnik_ris3_domeny_specializace AS rds
                                          ON pr.id_ris3 = rds.id
                             ) AS ds
                                 ON ds.id_projekt = p.id
                         )
                         LEFT OUTER JOIN (
                             SELECT vvi."Kód" AS "VaVaI téma k DS (Kód)",
                                    vvi."Název" AS "VaVaI téme k DS (Název)",
                                    pr.id_projekt,
                                    pr.id_hierarchie
                             FROM projekt_ris3 AS pr
                                  INNER JOIN ciselnik_ris3_vavai_tema_k_domene_specializace AS vvi
                                      ON pr.id_ris3 = vvi.id
                         ) AS vavai
                             ON (vavai.id_projekt = p.id AND vavai.id_hierarchie = ds.id_ds)
                     )
                     LEFT OUTER JOIN (
                         SELECT k."Kód" AS "RIS3 KET (Kód)",
                                k."Název" AS "RIS3 KET (Název)",
                                pr.id_projekt,
                                pr.id_hierarchie
                         FROM projekt_ris3 AS pr
                              INNER JOIN ciselnik_ris3_ket AS k
                                  ON pr.id_ris3 = k.id
                     ) AS ket
                         ON (ket.id_projekt = p.id AND ket.id_hierarchie = ds.id_ds)
                 )
                 LEFT OUTER JOIN (
                     SELECT s."Kód" AS "Témata VaVaI v SHUV (Kód)",
                            s."Název" AS "Témata VaVaI v SHUV (Název)",
                            pr.id_projekt,
                            pr.id_hierarchie
                     FROM projekt_ris3 AS pr
                          INNER JOIN ciselnik_ris3_temata_vavai_v_oblasti_shuv AS s
                              ON pr.id_ris3 = s.id
                 ) AS shuv
                     ON (shuv.id_projekt = p.id AND shuv.id_hierarchie = ds.id_ds)
             )
             LEFT OUTER JOIN (
                 SELECT c."Kód" AS "Cíle mise (Kód)",
                        c."Název" AS "Cíle mise (Název)",
                        pr.id_projekt,
                        pr."Procento"
                 FROM projekt_ris3 AS pr
                      INNER JOIN ciselnik_ris3_cile_mise AS c
                          ON pr.id_ris3 = c.id
             ) AS cm
                 ON cm.id_projekt = p.id
         )
         LEFT OUTER JOIN (
             SELECT kds."Kód" AS "Krajské DS (Kód)",
                    kds."Název" AS "Krajské DS (Název)",
                    u."Název" AS "Krajské DS (Název územní jednotky)",
                    pr."Procento",
                    pr.id_projekt
             FROM (projekt_ris3 AS pr INNER JOIN ciselnik_ris3_krajske_domeny_specializace AS kds ON pr.id_ris3 = kds.id)
                  INNER JOIN ciselnik_uzemni_jednotky AS u
                      ON u.id = kds.id_uzemnijednotky
         ) AS dsk
             ON dsk.id_projekt = p.id
    WHERE (
              w.kod IN ('PP30', 'PP31', 'PP36', 'PP37', 'PP40', 'PP41', 'PP42', 'PP43', 'PU30')
              AND v."Èíslo výzvy" IN (
                  '01_22_001',
                  '01_22_002',
                  '01_22_005',
                  '01_23_010',
                  '01_23_011',
                  '01_23_012',
                  '01_23_013',
                  '01_23_014',
                  '01_23_024',
                  '01_23_030',
                  '01_23_031',
                  '01_23_040',
                  '01_23_041',
                  '01_24_046',
                  '01_24_045',
                  '01_24_047',
                  '01_24_048',
                  '01_24_052',
                  '01_24_056',
                  '01_24_061',
                  '01_22_003',
                  '01_24_051',
                  '01_23_039',
                  '01_24_056',
                  '01_24_045'
              )
          )
    ORDER BY "Registraèní èíslo projektu" ASC;


