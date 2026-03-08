CREATE or REPLACE view "RIS3_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS SELECT v."Èíslo výzvy" ,
       i."Kód NÈI 2021+",
       i."Název indikátoru CZ",
       hodn.*
       
from vyzva v
INNER JOIN v_rav_umvindihodnota hodn ON hodn.id_nositelindi = v.id
INNER JOIN indikator i ON i.id = hodn.id_indikator
-- INNER JOIN ciselnik_typ_indikatoru c on c.id = i.id_typindi

where v."Èíslo výzvy" = '01_22_006'
AND c.zdroj = '®/P'



----------------------------------------

SELECT p."Registraèní èíslo projektu"
       i."Kód NÈI 2021+",
       i."Název indikátoru CZ",
       hodn.*

FROM projekt p
INNER JOIN v_rav_umvindihodnota hodn ON hodn.id_nositelindi = p.id
INNER JOIN indikator i ON i.id = hodn.id_indikator

WHERE p."Registraèní èíslo projektu" = 'CZ.01.04.01/01/24_049/0005026'
----------------------------------------
SELECT p."Registraèní èíslo projektu",
       i."Kód NÈI 2021+",
       i."Název indikátoru CZ",
       substr(1000*(hodn.cilovahodnota- TRUNC(hodn.cilovahodnota)),3,1)

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN v_rav_umvindihodnota hodn ON hodn.id_nositelindi = p.id
INNER JOIN indikator i ON i.id = hodn.id_indikator

WHERE p."Registraèní èíslo projektu" is not null
AND i."Kód NÈI 2021+" IN ('327005','327005','360102')
AND substr(1000*(hodn.cilovahodnota- TRUNC(hodn.cilovahodnota)),3,1) <> '0'

--- CZ.01.04.01/01/22_006/0000308


----------------------------------------
-- CREATE or REPLACE view  FOLDER= AS 
SELECT op."Název specifického cíle/opatøení" as "Opatøení" ,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       p."Registraèní èíslo projektu",
       w."Kód" "Kód stavu"  ,
       pf."Pøíspìvek Unie" "Dotace EU" ,
       pf."Pøíspìvek Unie"/ NULLIF (hi."Výchozí hodnota",NULL) "Kolik % obratu tvoøí dotace",
       -- i."Kód NÈI 2021+",
       -- i."Název indikátoru CZ",
       hi."Výchozí hodnota",
       hi."Cílová hodnota",
       100 * (hi."Cílová hodnota" /hi."Výchozí hodnota" - 1) "O kolik % je cíleno navý¹ení obratu"


FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil 
INNER JOIN indikator_hodnota hi ON hi.id_nositelindi = p.id
INNER JOIN indikator i ON i.id = hi.id_indikator
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 


WHERE p."Registraèní èíslo projektu" is not null
AND i."Kód NÈI 2021+" IN ('107501')
-- AND substr(1000*(hodn.cilovahodnota- TRUNC(hodn.cilovahodnota)),3,1) <> '0'
-- AND v."Èíslo výzvy" = '01_24_062'
AND w."Kód" not like 'PN%'
AND hi."Výchozí hodnota"  > 0
AND op."Název specifického cíle/opatøení" <> 'Aplikace'
AND (100 * (hi."Cílová hodnota" /hi."Výchozí hodnota" - 1) > 150
    OR
    100 * (hi."Cílová hodnota" /hi."Výchozí hodnota" - 1) <0)

ORDER BY "Opatøení" asc , v."Èíslo výzvy", "O kolik % je cíleno navý¹ení obratu" desc

