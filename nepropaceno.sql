SELECT DISTINCT
       p."Registraèní èíslo projektu",
       p.wfstav,
       p.kodwfstav,
       p."IÈ",
       p.zadatel,
       p."Název projektu CZ" ,
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
       hs.datumod AS "Datum vydání RoPD",
       hs.stavdo,
       platba.id,
       platba.vyuctskut

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND hs.stavdo = 'PP30'
LEFT JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND (platba.vyuctskut < 0.01 or platba.vyuctskut is null) AND platba.souctovyradek is null  

WHERE 
-- 
trunc(hs.datumod) <= to_date('2021-06-01','yyyy-mm-dd')
AND trunc(hs.datumod) >= to_date('2020-01-01','yyyy-mm-dd')
AND SUBSTR(p.kompetencniutvar, 6 ) <> 'Technická pomoc'
AND p."Registraèní èíslo projektu" = 'CZ.01.3.10/0.0/0.0/17_138/0011656'


ORDER BY hs.datumod 
