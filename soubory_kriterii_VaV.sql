SELECT	sk.id,
        v."Název výzvy" ,
        sk.nazev "Název souboru kritérií",
        cis.nazev "Fáze hodnocení" ,
       	skv.LIMITROZDILARBBODU ,
	skv.limitvyhovelbodu
       
FROM isum.v_bi_UmzVyzva v   
INNER JOIN isum.v_bi_UMVHodnSoubKritVyz skv ON skv.id_vyzva = v.id
INNER JOIN isum.v_bi_UMVHodnSouborKrit sk  ON sk.id = skv.id_souborkrit
INNER JOIN isum.v_bi_UMVHodnDruhCis cis ON cis.id = skv.id_druhhodn

WHERE skv.pocethodnotitelu > 1
--AND v.id = 1047819161
AND  v."Èíslo výzvy" IN ('01_15_007','01_15_018','01_15_019','01_16_053','01_16_056','01_16_079','01_16_083','01_16_084','01_17_103','01_17_106','01_17_107','01_17_125','01_17_147','01_17_166','01_17_173','01_17_174','01_17_175','01_17_176','01_18_212','01_19_262','01_19_263','01_19_274','01_19_275','01_20_321','01_20_336','01_21_374','01_21_375','01_21_373','01_20_339','01_20_338','01_20_318','01_19_297','01_19_273','01_19_268','01_19_267','01_19_266','01_19_261','01_18_243','01_17_206','01_17_170','01_17_165','01_17_164','01_17_163','01_17_162','01_17_157','01_17_127','01_17_124','01_17_121','01_17_109','01_17_093','01_16_092','01_16_051','01_16_050','01_16_049','01_15_030','01_15_014','01_15_002')

-- AND v."Èíslo výzvy" = '01_15_007'

-- GROUP BY sk.nazev, cis.nazev

ORDER BY v."Název výzvy"


----------------------------------------

SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       v."Název výzvy" ,
       p."Registraèní èíslo projektu",
       eh.ciskod kodhodnotitle,
       eh."Externí hodnotitel",
       hod.poradi,
       hod.typhodnotitele ,
       hod.pocetbodu celkembodu,
       hod.vyhovel pozitivniposudek,
       krit.NAZEVCELK,
       krit.islist lisotve,
       krit.uroven,
       krit.pocetbodu,
       krit.vyhovel,
       ci."Kód" typkriteria,
       krit.maxbodu,
       krit.minbodu,
       krit.relevantni ,
       SUBSTR(REPLACE(REPLACE(krit.zpusobhodn ,CHR(10),' --- '),CHR(13),' --- '),1,499) as zpusobhodn

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmvHodnoceniPRJ hod ON hod.id_noshodnoceni = p.id
INNER JOIN isum.v_bi_UmvHodnotitel eh ON eh.id = hod.id_hodnotitel
INNER JOIN isum.v_bi_UMVHodnotaKritPRJ krit ON krit.id_hodnoceni = hod.id
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  id_typkriteria

WHERE hod.id_souborkrit IN -- ('1328619286')
('167514216', '67961229', '1469442', '1481839', '1481839', '1482105', '1426174', '293358016', '286378827', '387243486', '500298389', '296739436', '286378827', '332642733', '644809187', '500298389', '303483016', '144851078', '167514216', '156287839', '329110340', '282283159', '144851078', '286378827', '503919876', '293358016', '500022849', '900219257', '843158513', '837487013', '672255592', '644718600', '644718600', '842622531', '1025807008', '500022849', '1017555722', '1060103712', '303483016', '286378827', '1061361796', '656772600', '1016241678', '1325509797','1328619286', '1328137647', '672223139', '166133488', '500022849', '1482105','66586657')
AND p."Registraèní èíslo projektu" is not null 
-- AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_007/0000956'
AND hod.finalizovano = 'A'
AND hod.PLATNOST = 'A'
AND hod.SCHVALENOSCHVAL = 'A'
AND (hod.typhodnotitele = 'Øádný hodnotitel'
    OR
    (hod.typhodnotitele = 'Opravný hodnotitel' AND krit.needitovatelne = 'N' ))
-- AND krit.nazevcelk <> 'Koøen'
AND krit.uroven > 0
AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'


ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC , eh.ciskod, hod.poradi, krit.nazevcelk

