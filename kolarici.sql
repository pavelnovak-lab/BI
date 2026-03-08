SELECT SUBSTR(p.KodPrioritniOsa, 4) "Prioritní osa",
       v."Název výzvy",
       platba."Èíslo ¾ádosti o platbu",
       p.zadatel,
       -- schválená dotace
       -- nsz
              


       -- v."Èíslo výzvy",
       p."Registraèní èíslo projektu",
       p.velikostpodniku,
       kor.*
       
       -- p5t.create_cas "Èas pøepnutí do P5T",
       -- p6.create_cas "Èas pøepnutí do P6",
       -- p6t.create_cas "Èas pøepnutí do P6T",
       
       -- platba.kodwfstav ,
       -- dotace.CastkaSchvalena AS "Schválená dotace",
       -- zdroje.CastkaSchvalena AS "Národní soukromé zdroje"




FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
LEFT JOIN  isum.v_bi_UMPKorekce kor ON kor.id_platba = platba.id

-- INNER JOIN (
--  SELECT max(hs.create_cas) create_cas ,
-- 	hs.NositelId
--  FROM isum.v_bi_UmsWFHistorieStavu hs
--  WHERE hs.stavdo = 'P5T'
--  AND max(hs.create_cas) >= (:P5T_DatumOD)
--  GROUP BY hs.NositelId ) p5t ON p5t.NositelId = platba.id
-- LEFT JOIN (
--  SELECT max(hs.create_cas) create_cas ,
-- 	hs.NositelId
--  FROM isum.v_bi_UmsWFHistorieStavu hs
--  WHERE hs.stavdo = 'P6'
--  GROUP BY hs.NositelId ) p6 ON p6.NositelId = platba.id
-- LEFT JOIN (
--  SELECT max(hs.create_cas) create_cas ,
-- 	hs.NositelId
--  FROM isum.v_bi_UmsWFHistorieStavu hs
--  WHERE hs.stavdo = 'P6T'
--  GROUP BY hs.NositelId ) p6t ON p6t.NositelId = platba.id
-- INNER JOIN (
--  SELECT fin.CastkaSchvalena,
--  	fin.id_platba
--  FROM isum.v_bi_UmpRozpisFin fin
--  WHERE fin.poradi = 11 ) dotace ON dotace.id_platba = platba.id 
-- INNER JOIN (
--  SELECT fin.CastkaSchvalena,
--  	fin.id_platba
--  FROM isum.v_bi_UmpRozpisFin fin
--  WHERE fin.poradi = 25 ) zdroje ON zdroje.id_platba = platba.id 

WHERE p.kodwfstav in ('PP36','PP37','PP40','PP41','PP42','PP43')
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND p."Registraèní èíslo projektu" is not null
AND platba."Èíslo ¾ádosti o platbu" = 'CZ.01.1.02/0.0/0.0/18_213/0015446/2022/003/POST'


-- AND   p.id in ( 1638560 , 1847112 )
-- AND platba.id in (500019551, 634412189)
--- datumod 
-- ORDER BY platba.cisloplatbyzkr


