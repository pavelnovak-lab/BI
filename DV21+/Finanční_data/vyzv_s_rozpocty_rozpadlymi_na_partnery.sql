-- CREATE OR REPLACE VIEW "Skupina_rozpočtu_s_rozpadem_na_partnery" FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/vyzvy' AS
    SELECT DISTINCT v."Číslo výzvy",
                    v."Název výzvy",
                    c."Kód",
                    c."Název"
    FROM (
             (vyzva AS v INNER JOIN vyzva_matricni_data AS md ON (md.id_vyzva = v.id AND md."Platný" = 'A'))
             INNER JOIN ciselnik_skupina_rozpoctu AS c
                 ON c.id = md.id_ciszakladni
         )
         INNER JOIN rozpocet_skupina_polozka AS rsp
             ON rsp.id_predpis = md.id_ciszakladni
    WHERE EXISTS (
              SELECT 1
              FROM rozpocet_skupina_polozka
              WHERE ("Rozpad položky pro partnery s finančním příspěvkem" = 'A' AND id_predpis = md.id_ciszakladni)
          );
