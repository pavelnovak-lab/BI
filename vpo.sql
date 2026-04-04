-- CREATE VIEW "tak-mpo-novak-pavel Nenulové VPo na projektech"
    -- FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/finanèní_data' AS
CREATE or REPLACE VIEW "tak-mpo-novak-pavel Nenulové VPo na projektech" FOLDER = '/06_Data_models/01_OP_TAK/MPO/novak-pavel/Finanèní_data' AS
CREATE or REPLACE view "RIS3_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 
SELECT op.nazev AS "Opatøení",
           v."Èíslo výzvy",
           v."Název výzvy",
           p."Registraèní èíslo projektu",
           w."Kód" AS "Kód stavu",
           -- rp."Re¾im podpory",
	   vpo.id_nositel,
	   kvpo."Název",
           count(kvpo."Kód")
    --        vpo."Èástka veøejné podpory\n (CZK, dotaèní zdroje)",
    --        vpo."Èástka poskytnuté veøejné podpory celkem - Ostatní zdroje v Kè",
    --        vpo."Èástka poskytnuté veøejné podpory celkem v Kè",
    --        vpo."Platnost",
    --        vpo."Souètový øádek"
    FROM (
             (
                 (
                     (
                         (
                             (projekt AS p INNER JOIN vyzva AS v ON v.id = p.id_vyzva)
                             INNER JOIN ciselnik_stav_workflow AS w
                                 ON p.id_wfstav = w.id
                         )
                         INNER JOIN verejna_podpora AS vpo
                             ON vpo.id_projekt = p.id
                     )
                     INNER JOIN vyzva_hierarchie AS vh
                         ON vh.id_vyzva = v.id
                 )
                 INNER JOIN v_rav_umshisc AS op
                     ON op.id = vh.id_speccil
             )
             INNER JOIN ciselnik_kombinace_verejne_podpory AS kvpo
                 ON vpo.id_verejnapodpora = kvpo.id
         )
         INNER JOIN ciselnik_rezim_podpory AS rp
             ON vpo.id_rezimpodpory = rp.id

WHERE p."Registraèní èíslo projektu" IS NOT NULL
      AND vpo."Èástka veøejné podpory\n (CZK, dotaèní zdroje)" > 0
      AND vpo."Souètový øádek" IS NULL
      AND vpo."Platnost" = 'A'

GROUP BY op.nazev,
           v."Èíslo výzvy",
           v."Název výzvy",
           p."Registraèní èíslo projektu",
           w."Kód" ,
	   vpo.id_nositel,
	   -- rp."Re¾im podpory",
           kvpo."Název"

having count(kvpo."Kód") > 1


-- ORDER BY "Registraèní èíslo projektu" ASC,
--              "Re¾im podpory" ASC,
--              "Kód" ASC;

