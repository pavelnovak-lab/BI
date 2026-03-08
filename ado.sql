SELECT p."Registraèní èíslo projektu",
       p."IÈ",
       ci."Název" "Typ kontroly",
       k.*
       -- k."Datum zahájení",
       -- k."Datum ukonèení",
       -- k."Název kontroly",
       -- k."Pøedmìt kontroly",,
       -- k.wfstav  ,
       -- k."KOD#Èíslo kontroly",
       -- -- k.VYCHAZIMN "Vychází z MN",
       -- k.KONTROLNIZJISTENI ,
       -- -- DECODE (k.id_subjekt, 0, 'Administrativní ovìøení', 
       -- 'Kontrola na místì') "Druh kontroly",
       

       -- -- z."DRUHVZ",
       -- -- z."HODNOTAVZ",
       -- -- z.nazev,
    
       -- -- -- k.wfstav,
       -- -- -- k.kodwfstav ,
       -- zj.CISLO "Èíslo zji¹tìní",
       -- zj.popis

FROM  isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmvKontrolaNaMiste k ON p.id = k.id_nositelkontroly
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = k.id_typkontroly
-- LEFT JOIN isum.v_bi_UMVKontrZpravy z ON k.id = z.id_kontrola
-- LEFT JOIN isum.v_bi_UMVKontrZjisteni zj ON zj.id_kontrola = k.id



WHERE p."Registraèní èíslo projektu" is not null 
-- p."Registraèní èíslo projektu" in ('CZ.01.1.02/0.0/0.0/15_014/0001797', 'CZ.01.4.04/0.0/0.0/18_237/0018351')
-- AND k.kodwfstav not in ('KN01','KP01','KP02') -- kontrola 1 - zru¹ena, plánována, zahájena
-- -- AND k.ID_TYPKONTROLY = 275810
-- -- AND k.ID_ROCNIPLAN <> 0
-- AND k.id_zop = 0 
-- AND UPPER(k."Název kontroly") not like '%®OP%'
-- AND UPPER(k."Název kontroly") not like '%KL%'
-- AND UPPER(k."Název kontroly") not like '%ZOU%'
-- AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 
AND p."Registraèní èíslo projektu" = 'CZ.01.3.10/0.0/0.0/19_251/0020503'
AND k.id = 1777671977

-- ORDER BY p."Registraèní èíslo projektu" , k."Datum ukonèení", zj.cislo
