-- CREATE or REPLACE view "odbornosti_projektu" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Hodnoceni' AS

SELECT op."Název specifického cíle/opatøení" as "Opatøení" ,
       v."Èíslo výzvy" ,
       v."Název výzvy" ,
       p."Registraèní èíslo projektu",
       w."Kód" "Kód stavu" ,
       p."Datum zmìny stavu",
       GROUP_CONCAT(DISTINCT '; ',  co."Název" ) "Odbornosti projektu"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN hodnoceni_odbornosti_projektu o ON o.id_noshodnoceni = p.id
INNER JOIN ciselnik_odbornost co ON co.id = o.id_odbornost

WHERE p."Registraèní èíslo projektu" is not null
-- AND co."Název" REGEXP_LIKE 'CZ-NACE 4.*'
-- AND w."Kód" not IN ('PN20a', 'PN22')
-- AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/08/23_036/0005311'

GROUP BY op."Název specifického cíle/opatøení" ,
       v."Èíslo výzvy" ,
       v."Název výzvy" ,
       p."Registraèní èíslo projektu",
       w."Kód" "Kód stavu" ,
       p."Datum zmìny stavu"

ORDER BY "Datum zmìny stavu" DESC 
