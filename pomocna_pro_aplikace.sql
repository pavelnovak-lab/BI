SELECT  p."Registraèní èíslo projektu" 
-- count(p.id)

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmvHodnoceni hod ON hod.id_noshodnoceni = p.id AND hod.id_KrokVecHodn in (171214,171213)
INNER JOIN isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id = hod.id_hodnotitel -- AND hodnotitel."Externí hodnotitel" = 'A'
-- LEFT JOIN isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel AND n."Je souèástí projektu?" = 'A'
-- LEFT JOIN isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
-- LEFT JOIN isum.v_bi_UmvHodnNosOdbornost o ON o.id_noshodnoceni = p.id
-- LEFT JOIN isum.v_bi_UMSCisOdbornost odb ON odb.id = o.id_odbornost


WHERE p."Registraèní èíslo projektu" is not null
AND v."Èíslo výzvy" in ('01_15_007','01_15_018','01_15_019','01_16_053','01_16_056','01_16_079','01_16_083','01_16_084','01_17_103','01_17_106','01_17_107','01_17_125','01_17_147','01_17_166','01_17_173','01_17_174','01_17_175','01_17_176','01_18_212','01_18_269','01_19_262','01_19_263','01_19_274','01_19_275','01_20_321','01_20_336','01_21_374')
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PU30','PP20','PP21','PP22','PP23a','PP23b','PP27a','PP27b','PP29','PU21','PU27','V2','V5','Z1','Z3')
-- AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/20_321/0023609'

AND hod.platnost = 'A'
AND hod.agregat = 'N'
AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/17_175/0015501'

-- GROUP BY p."Registraèní èíslo projektu" ,
--        SUBSTR(p.kompetencniutvar, 6),
--        v."Èíslo výzvy",
--        v."Název výzvy",
--        p.kodwfstav ,
--        p."Datum ukonèení pøedp",
--        p."Datum ukonèení skut" ,
--        p.id



-------------------------------------------------
SELECT p."Registraèní èíslo projektu" ,
       p.zed,
       p.akcezed,
       ci."Název",
       ci."Kód" ,
       p.kodwfstav ,
       -- hs.datumod,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       p.wfstavdatum ,
       listagg(manazeri.nazev , '; ')
       
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  p.ID_AGRAKCEZED
left JOIN isum.v_bi_UMZProjOdpovedn manazeri ON manazeri.idprojekt = p.id AND manazeri.datumdo is null 

WHERE p."Registraèní èíslo projektu" is not null 
AND p."Bude se poøizovat EDSSMVS" = 'N'
AND SUBSTR(p.kompetencniutvar, 6) = 'Inovaèní vouchery'
AND p.akcezed is not null 
AND ci."Kód"  = 'Z220601000000'

GROUP BY p."Registraèní èíslo projektu" ,
       p.zed,
       p.akcezed,
       ci."Název",
       ci."Kód" ,
       p.kodwfstav ,
       -- hs.datumod,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       p.wfstavdatum 
