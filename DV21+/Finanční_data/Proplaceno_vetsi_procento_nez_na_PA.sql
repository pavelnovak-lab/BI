-- CREATE or REPLACE view "EU_podpora_na_Z®oP_vetsi_nez_v_PA" FOLDER
-- CREATE or REPLACE view "RIS3_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS


SELECT op.nazev as "Opatøení" ,
       p."Registraèní èíslo projektu" ,
       w."Kód" "Stav" ,
       pl."Èíslo platby" ,
       wpl."Kód" "Stav ®oP",
       pl."Závìreèná platba",
       cuk."Kód" "Kód øádku na F1-C" ,
       cuk."Název" "Název øádku na F1-C" ,
       rf."Aktuální rozpis financování projektu",
       rf."Schváleno a proplaceno za projekt vèetnì této ®oP"

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN ciselnik_stav_workflow wpl ON pl.id_wfstav = wpl.id
INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id 
INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel AND cuk."Kód" in ('7')  -- øádek F1-C EU celkem

WHERE  rf."Aktuální rozpis financování projektu" < rf."Schváleno a proplaceno za projekt vèetnì této ®oP"
AND pl."Závìreèná platba" = 'A'

