SELECT p."Registraèní èíslo projektu",
       -- substr(p."Registraèní èíslo projektu",-5,5) "Projekt" ,
       p.zadatel,
       p."Název projektu CZ",
       p.id,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       -- LISTAGG( platba."Datum proplacení pøíjemci", '; ')  "Datum proplacení pøíjemci" ,
       -- LISTAGG( platba."Èíslo ¾ádosti o platbu", '; ') "Èíslo ¾ádaosti o platbu",
       pril.NAZEVPRIL,
       pril."Link DMS" 
       -- vs.pocet "Poèet partnerù",

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id = p.id_vyzva 
-- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id = platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UMFSmlouva sml ON  sml.id_nositelsml = p.id
INNER JOIN isum.v_bi_UMSPrilohyPA pril ON pril.id_nositelpril = sml.id

WHERE p."Registraèní èíslo projektu" is not null 
-- p.kodwfstav in ('PP37','PP40','PP41','PP42','PP43','PU30')
-- AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'
-- AND v."Èíslo výzvy" IN ('01_17_106','01_17_107','01_17_175','01_17_176','01_19_262','01_20_321')
-- AND p."Registraèní èíslo projektu" IN ('CZ.01.1.02/0.0/0.0/17_176/0015727')
-- AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/17_176/0015523'
-- AND to_date('2021-12-31','yyyy-mm-dd') < platba."Datum proplacení pøíjemci"
-- AND platba."Datum proplacení pøíjemci" < to_date('2023-01-01','yyyy-mm-dd')  
-- AND platba.kodwfstav in ('P10','P11')
AND (
    upper(pril.NAZEVPRIL) like upper('%Rozpoèet%')
    OR
    upper(pril.NAZEVPRIL) like upper('%Rozpocet%')
    )

AND sml."Poøadí" = 1

GROUP BY p."Registraèní èíslo projektu",
       substr(p."Registraèní èíslo projektu",-5,5),
       p.zadatel,
       p."Název projektu CZ",
       p.id,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       -- platba."Datum proplacení pøíjemci",
       -- platba."Èíslo ¾ádosti o platbu" ,
       pril.NAZEVPRIL,
       pril."Link DMS" ,
       vs.pocet
