SELECT p."Registrační číslo projektu",
       p.zadatel,
       p.kodwfstav ,
       p."IČ" ,
       v."Číslo výzvy",
       v."Název výzvy" ,
       sum(czv.castkaschvalena) "Celkové schválené CZV",
       sum(dotace.castkaschvalena) "Celkové schválená dotace",
       count(platba.id) "Počet proplacených ŽoP"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.kodwfstav in ('P10','P11') AND to_date('2021-12-31','yyyy-mm-dd') < platba."Datum proplacení příjemci"
INNER JOIN (
 SELECT rf.id_platba,
        rf.castkaschvalena
 FROM isum.v_bi_UmpRozpisFin rf
 WHERE rf.id_ukazatel = 361356 -- řádek 10a - dotace
 ) dotace ON dotace.id_platba = platba.id 
INNER JOIN (
 SELECT rf.id_platba,
        rf.castkaschvalena
 FROM isum.v_bi_UmpRozpisFin rf
 WHERE rf.id_ukazatel = 361347 -- řádek 10a - dotace
 ) czv ON czv.id_platba = platba.id 

WHERE p.kodwfstav in ('PP37','PP40','PP41','PP42','PP43','PU30')
AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'

GROUP BY  p."Registrační číslo projektu",
       p.zadatel,
       p.kodwfstav ,
       p."IČ" ,
       v."Číslo výzvy",
       v."Název výzvy"


--------------------------------------------

SELECT platba."Číslo žádosti o platbu" ,
       platba.id,
       platba.id_nositelPlatby ,
       platba."Datum proplacení příjemci"
       
FROM  isum.v_bi_UmpPlatbaPrj platba

WHERE to_date('2021-12-31','yyyy-mm-dd') < platba."Datum proplacení příjemci"
AND platba."Datum proplacení příjemci" < to_date('2023-01-01','yyyy-mm-dd')  
AND platba.kodwfstav in ('P10','P11')


--------------------------------------------

SELECT rf.id_platba,
       rf.castkaschvalena "Dotace schválená" -- řádek 10a

FROM isum.v_bi_UmpRozpisFin rf 
WHERE rf.id_ukazatel = 361356 -- řádek 10a

--------------------------------------------

SELECT rf.id_platba,
       rf.castkaschvalena "CZV", -- řádek 10a

FROM isum.v_bi_UmpRozpisFin rf 
WHERE rf.id_ukazatel = 361347 -- řádek 2

