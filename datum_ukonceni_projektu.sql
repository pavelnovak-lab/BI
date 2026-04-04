SELECT p."Registrační číslo projektu" ,
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       v."Číslo výzvy",
       v."Název výzvy",
       p.kodwfstav ,
       p."Datum ukončení předp",
       p."Datum ukončení skut",
       LISTAGG(distinct hodnotitel.CISKOD, '; ') "Hodnotitelé VH",
       LISTAGG(distinct ci."Kód",'; ' on overflow truncate) AS "Kód CZ NACE",
       LISTAGG(distinct ci."Název",'; ' on overflow truncate) AS "Název CZ NACE" ,
       LISTAGG(distinct odb."Název", '; ' on overflow truncate) AS "Odbornost",
       p.id

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmvHodnoceni hod ON hod.id_noshodnoceni = p.id AND hod.id_KrokVecHodn in (171214,171213)
INNER JOIN isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id = hod.id_hodnotitel -- AND hodnotitel."Externí hodnotitel" = 'A'
LEFT JOIN isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel AND n."Je součástí projektu?" = 'A'
LEFT JOIN isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
LEFT JOIN isum.v_bi_UmvHodnNosOdbornost o ON o.id_noshodnoceni = p.id
LEFT JOIN isum.v_bi_UMSCisOdbornost odb ON odb.id = o.id_odbornost


WHERE p."Registrační číslo projektu" is not null
AND v."Číslo výzvy" in ('01_15_007','01_15_018','01_15_019','01_16_053','01_16_056','01_16_079','01_16_083','01_16_084','01_17_103','01_17_106','01_17_107','01_17_125','01_17_147','01_17_166','01_17_173','01_17_174','01_17_175','01_17_176','01_18_212','01_18_269','01_19_262','01_19_263','01_19_274','01_19_275','01_20_321','01_20_336','01_21_374')
AND p.kodwfstav in ('PP30','PP36','PP37','PU30','PP20','PP21','PP22','PP23a','PP23b','PP27a','PP27b','PP29','PU21','PU27','V2','V5','Z1','Z3')
-- AND p."Registrační číslo projektu" = 'CZ.01.1.02/0.0/0.0/20_321/0023609'

AND hod.platnost = 'A'
AND hod.agregat = 'N'


GROUP BY p."Registrační číslo projektu" ,
       SUBSTR(p.kompetencniutvar, 6),
       v."Číslo výzvy",
       v."Název výzvy",
       p.kodwfstav ,
       p."Datum ukončení předp",
       p."Datum ukončení skut" ,
       p.id

----------------------------------------

SELECT platba."PORADI#Pořadí finančního plánu" "Pořadí poslední ŽoP",
       platba.kodwfstav ,
       rf.CASTKASCHVALENA "Schválená částka" ,
       roz.vyuctplan
       platba.id_NositelPlatby

FROM isum.v_bi_UmpPlatbaPrj platba -- ON p.id=platba.id_NositelPlatby
LEFT JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356 -- dotace na řádku 10a
INNER JOIN isum.v_bi_UmpRozpady roz ON roz.id_platba = platba.id AND roz.id_zdrojfin = 171665 AND roz.souctovyradek = 'N'
-- INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 

WHERE platba."Závěrečná platba" = 'A'
AND platba.id_NositelPlatby = 631124615
-- 6368168 -- CZ.01.1.02/0.0/0.0/15_019/0004451
-- 1084958894 -- projekt CZ.01.1.02/0.0/0.0/20_321/0023609


----------------------------------------
SELECT *

FROM isum.v_bi_UmpRozpady
