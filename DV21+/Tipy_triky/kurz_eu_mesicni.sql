 WITH posledni_kurz AS (
             SELECT "Měsíční kurz (CZK/EUR)" AS kurz,
                    row_number() OVER(ORDER BY "Datum" DESC) AS rn
             FROM skutecnost_sc_eu
             WHERE (id_kr = 0 AND id_sc = 0 AND id_fond = 0)
         )
    SELECT substr("Datum", 1, 7) AS mesic,
           CASE WHEN (substr("Datum", 0, 7) < '2022-10') THEN
               24.687
           ELSE
               "Měsíční kurz (CZK/EUR)"
           END AS kurz
    FROM skutecnost_sc_eu
    WHERE (id_kr = 0 AND id_sc = 0 AND id_fond = 0)
    SQL UNION ALL
    SELECT substr(now(), 1, 7) AS mesic,
           posledni_kurz.kurz
    FROM posledni_kurz
    WHERE posledni_kurz.rn = 1
    SQL UNION ALL
    SELECT substr(addmonth(now(),1) 1, 7) AS mesic,
           posledni_kurz.kurz
    FROM posledni_kurz
    WHERE posledni_kurz.rn = 1
    ORDER BY mesic DESC;
    
