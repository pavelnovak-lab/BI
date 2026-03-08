-- CREATE OR replace VIEW "Schválena 2. stupeò" FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/finanèní_data' AS
SELECT op.nazev AS "Opatøení",
       sum(rf."Schválené vyúètování ZS/ØO v této ®oP") "Dotace"        
FROM projekt AS p
INNER JOIN vyzva AS v ON v.id = p.id_vyzva
INNER JOIN platba AS pl ON pl.id_nositelplatby = p.id
INNER JOIN subjekt AS s ON (s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462)
INNER JOIN vyzva_hierarchie AS vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc AS op ON op.id = vh.id_speccil
INNER JOIN ciselnik_stav_workflow AS pwf ON pwf.id = pl.id_wfstav
INNER JOIN rozpis_financovani AS rf ON rf.id_platba = pl.id
INNER JOIN ciselnik_ukazatel_rozpis_financovani AS cu ON (rf.id_ukazatel = cu.id AND cu."Kód" = '7')



WHERE pwf."Kód" IN ('P10', 'P11','P12')
AND v."Èíslo výzvy" IN ('01_22_002','01_23_014','01_23_011','01_23_012','01_23_013','01_23_021')


GROUP BY op.nazev



