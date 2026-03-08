SELECT v."Název výzvy",
       v."Èíslo výzvy" ,
       p."Registraèní èíslo projektu" ,
       p."Název projektu CZ",
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" 
       p.zadatel,
       p."IÈ",
       gg.eu,
       gg.czv,
       hs.datumod "Datum PP30",
       p.kodwfstav,
       p.wfstavdatum,

       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 

WHERE p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43')
AND hs.stavdo = 'PP30'
AND v."Èíslo výzvy" = :cislo_vyzvy

-- '01_20_357'
