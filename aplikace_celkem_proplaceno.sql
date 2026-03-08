SELECT p."Registraèní èíslo projektu",
       p.zadatel,
       p.kodwfstav ,
       p."IÈ" ,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       sum(czv.castkaschvalena) "Celkové schválené CZV",
       sum(dotace.castkaschvalena) "Celkové schválená dotace",
       count(platba.id) "Poèet proplacených ®oP"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.kodwfstav in ('P10','P11') AND  platba."Datum proplacení pøíjemci" < to_date('2023-01-01','yyyy-mm-dd') <
INNER JOIN (
 SELECT rf.id_platba,
        rf.castkaschvalena
 FROM isum.v_bi_UmpRozpisFin rf
 WHERE rf.id_ukazatel = 361356 -- øádek 10a - dotace
 ) dotace ON dotace.id_platba = platba.id 
INNER JOIN (
 SELECT rf.id_platba,
        rf.castkaschvalena
 FROM isum.v_bi_UmpRozpisFin rf
 WHERE rf.id_ukazatel = 361347 -- øádek 2 - CZV
 ) czv ON czv.id_platba = platba.id 

WHERE p.kodwfstav in ('PP37','PP40','PP41','PP42','PP43','PU30')
AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'

GROUP BY  p."Registraèní èíslo projektu",
       p.zadatel,
       p.kodwfstav ,
       p."IÈ" ,
       v."Èíslo výzvy",
       v."Název výzvy"
