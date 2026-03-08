-- CREATE OR replace VIEW "Schválena 2. stupeò" FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/finanèní_data' AS
SELECT --op.nazev AS "Opatøení",
       -- pl."Èíslo platby",
       -- s."Název subjektu" AS "Pøíjemce",
       -- rf."Schválená záloha ZS/ØO v této ®oP" AS "Schválená záloha",
       -- rf."Schválené vyúètování ZS/ØO v této ®oP" AS "Schválené vyúètování",
       -- hs."Datum od" AS "Datum schválení" ,
       v."Èíslo výzvy",
       -- v."Název výzvy"
       pwf."Kód" ,
       pl."Èíslo platby",
       pl."Datum a èas poslední zmìny" 
FROM projekt AS p
INNER JOIN vyzva AS v ON v.id = p.id_vyzva
INNER JOIN platba AS pl ON pl.id_nositelplatby = p.id
-- INNER JOIN subjekt AS s ON (s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462)
-- INNER JOIN vyzva_hierarchie AS vh ON vh.id_vyzva = v.id
-- INNER JOIN v_rav_umshisc AS op ON op.id = vh.id_speccil
INNER JOIN ciselnik_stav_workflow AS pwf ON pwf.id = pl.id_wfstav
-- INNER JOIN rozpis_financovani AS rf ON rf.id_platba = pl.id
-- INNER JOIN ciselnik_ukazatel_rozpis_financovani AS cu ON (rf.id_ukazatel = cu.id AND cu."Kód" = '7')
-- INNER JOIN historie_stavu AS hs ON hs.nositelid = pl.id
-- INNER JOIN ciselnik_stav_workflow AS plwf ON (plwf.id = hs.id_stavdo AND plwf."Kód" IN ('P6T', 'P9T'))
-- LEFT JOIN ( -- zatím v DV21+ chybí view s pøílohami platby
--      SELECT LISTAGG( priloha.nazevpril, '; ') "Název pøíloh" ,
-- 	    priloha.id_nositelpril
--      FROM isum.v_bi_UMSPrilohyPlatba priloha
--      WHERE UPPER(priloha.nazevpril) like '%MINISTR%'
--      GROUP BY priloha.id_nositelpril) pril ON pril.id_nositelpril = platba.id

WHERE v."Èíslo výzvy" = '01_23_023'
AND pwf."Kód" <> 'P0'

      
-- ORDER BY "Datum schválení" DESC;


