
-- CREATE OR replace VIEW subjekt_pravni_forma FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/subjekty' AS

SELECT op.nazev AS "Opatøení",
       p."Registraèní èíslo projektu",
       w."Kód" AS "Kód stavu",
       s."Název subjektu",
       s."IÈ",
       ts."Název" AS "Typ subjektu",
       pf."Právní forma",
       max(CASE WHEN pzf.id_faze = 99991000000000005 then pzf."Národní veøejné zdroje"
       ELSE NULL END) "NVZ aktuální" ,

       max(CASE WHEN pzf.id_faze = 99991000000000005 then pzf."Soukromé zdroje"
       ELSE NULL END) "Soukromé aktuální" ,

       max(CASE WHEN pzf.id_faze = 99991000000000011 then pzf."Národní veøejné zdroje"
       ELSE NULL END) "NVZ RoPD" ,

       max(CASE WHEN pzf.id_faze = 99991000000000011 then pzf."Soukromé zdroje"
       ELSE NULL END) "Soukromé RoPD" 


--       SUBSTR(p."Registraèní èíslo projektu",24) 
FROM projekt AS p INNER JOIN vyzva AS v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie AS vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc AS op ON op.id = vh.id_speccil
INNER JOIN subjekt AS s ON s.id_prjgg = p.id
INNER JOIN ciselnik_pravni_forma AS pf ON pf.id = s.id_hosppravforma
INNER JOIN ciselnik_stav_workflow AS w ON p.id_wfstav = w.id
INNER JOIN ciselnik_typ_subjektu AS ts ON ts.id = s.id_typsubjektuedit
INNER JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze in (99991000000000005, 99991000000000011) -- aktuální a PA

WHERE p."Registraèní èíslo projektu" IS NOT NULL
-- AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000334'
and pf."Právní forma" like 'Vysoká%'
AND ts."Název" = '®adatel/pøíjemce'
AND w."Kód" not like 'PN%'

GROUP BY op.nazev ,
       p."Registraèní èíslo projektu",
       w."Kód" ,
       s."Název subjektu",
       s."IÈ",
       ts."Název" ,
       pf."Právní forma"


ORDER BY SUBSTR(p."Registraèní èíslo projektu",24)





