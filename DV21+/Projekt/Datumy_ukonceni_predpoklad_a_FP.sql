SELECT p."Registrační číslo projektu" ,
       w."Kód" ,
       p."Předpokládané datum ukončení"  ,
       -- max(pl."Datum předložení")
       i."Kód NČI 2021+" ,       
       ih."Datum cílové hodnoty"

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id   
INNER JOIN vyzva v ON v.id = p.id_vyzva 
-- INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN indikator_hodnota ih ON ih.id_nositelindi = p.id
INNER JOIN indikator i ON i.id = ih.id_indikator 



WHERE v."Číslo výzvy" = '01_24_045'
-- AND p."Registrační číslo projektu" = 'CZ.01.01.01/06/24_045/0005179'
AND i."Kód NČI 2021+" = '218100'
AND ih."Datum cílové hodnoty" <> p."Předpokládané datum ukončení"   

-- HAVING max(pl."Datum předložení") = p."Předpokládané datum ukončení"

-- GROUP BY p."Registrační číslo projektu" ,
--        w."Kód" ,
--        p."Předpokládané datum ukončení"  

-- having 
