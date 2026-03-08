SELECT p.zadatel ,
       p."Registraèní èíslo projektu",
       p."IÈ",
       gg.czv,
       gg.eu,
       (gg.eu/gg.czv) as "Procento dotace",
       v."Èíslo výzvy",
       v."Název výzvy" ,
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       -- hs.datumod AS "Datum RoPD",
       sum( rf.CASTKASCHVALENA ) AS  "Proplacená dotace" 

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
-- INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356  -- øádek 10a   

WHERE p."Registraèní èíslo projektu" is not null 
-- AND hs.stavdo = 'PP30'
-- AND trunc(platba."Datum zmìny stavu") < to_date('2022-01-01','yyyy-mm-dd')
-- AND trunc(platba."Datum zmìny stavu") > to_date('2020-12-31','yyyy-mm-dd')
AND platba.kodwfstav in ('P10','P11','P12','P13','P14','P15')
AND rf.CASTKASCHVALENA > 0
AND p."IÈ" = '24166855'
GROUP BY p.zadatel ,
      	 p."Registraèní èíslo projektu",
       p."IÈ",
       gg.czv,
       gg.eu,
       (gg.eu/gg.czv) ,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       SUBSTR(p.kompetencniutvar, 6)

