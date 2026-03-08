-- CREATE or REPLACE view "tak-novak-proc-na-zoz-vetsi-nez-na-projektu" FOLDER='' AS 
SELECT op.nazev as "Opatøení" ,
       pl."Èíslo platby" ,
       pl."Závìreèná platba",
       w."Kód" "Kód stavu" ,
       rf."Pøedlo¾ené vyúètování v toto ®oP" "Procento EU ®oP",
       rf."Aktuální rozpis financování projektu" "Procento EU projekt"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id 
INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel -- AND cuk."Kód" = '7' -- øádek F1-C EU celkem
INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id  
WHERE -- pl."Èíslo platby" = '
-- AND
cuk."Kód" = '7c'
AND rf."Pøedlo¾ené vyúètování v toto ®oP" > rf."Aktuální rozpis financování projektu"

ORDER BY w."Kód" DESC 
