SELECT platba."PORADI#Pořadí finančního plánu",
       p."Registrační číslo projektu" ,
       p.zadatel,
       platba."Číslo žádosti o platbu" "Číslo ZŽoP" ,
       p.kodwfstav

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
-- INNER JOIN
--       (SELECT platba."Číslo žádosti o platbu"
--       	      platba.id_NositelPlatby
--        FROM isum.v_bi_UmpPlatbaPrj platba
--        WHERE platba."Závěrečná platba" = 'A') zaver ON zaver.id_NositelPlatby = zaver.id_NositelPlatby


WHERE p.id_vyzva IN (1607294465, 1775714122) -- výzvy 017 a 069
AND p.kodwfstav in ('PP20','PP21','PP22','PP23a','PP23b','PP27a','PP27b','PP29','PU21','PU27','V2','V5','Z1','Z3','PP30','PP36','PP37','PP40','PP41','PP42','PP43','PU30') 
AND platba."Závěrečná platba" = 'A'
AND zadatel <> 'Ministerstvo průmyslu a obchodu'


-- GROUP BY p."Registrační číslo projektu" , p.zadatel , zaver."Číslo žádosti o platbu"

ORDER BY p."Registrační číslo projektu" 
