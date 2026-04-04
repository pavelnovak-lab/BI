SELECT v."Název výzvy",
       v."Číslo výzvy" ,
       p."Registrační číslo projektu",
       p."Název projektu CZ" ,       		      
       p.zadatel,
       p."Datum registrace žádosti",
       p.VelikostPodniku,
       p.kodwfstav,
       gg.eu,
       gg.czv ,
       prvni.pocetbodu as "Bodů 1. krok VH", 
       prvni.LimitVyhovelBodu as "Limit 1. krok VH" ,
       druhy.pocetbodu as "Bodů 1. krok VH", 
       druhy.LimitVyhovelBodu as "Limit 1. krok VH" ,

       listagg (DISTINCT uj."Název", '; ' ) as "Místo realizace"

       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva AND v."OP kod" = '01'
INNER JOIN isum.v_bi_UmzVyzvaKategorie kat ON kat.id_vyzva = v.id AND kat.integrovany = 'Ano'
INNER JOIN isum.v_bi_umzprjumisteni um ON um.id_projekt = p.id
LEFT JOIN  isum.v_bi_umscisuzemnijednotky uj ON um.id_uzemnijednotky = uj.id AND uj.urovennazev <> 'Kraj' AND uj."Název" not like '%-město'
-- LEFT JOIN isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni = p.id AND (status.id_krokvechodn = 171213 or status.id_krokvechodn is null)
-- INNER JOIN isum.v_bi_UMVHodnSoubKritVyz skv ON skv.id_vyzva = v.id AND skv.id_krokvechodn = 171214 AND skv.PLATNOSTDO is null

LEFT JOIN (SELECT p.id ,
       status.pocetbodu ,
       skv.LimitVyhovelBodu 
FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni = p.id AND id_krokvechodn = 171213
INNER JOIN isum.v_bi_UMVHodnSoubKritVyz skv ON skv.id_vyzva = v.id AND skv.id_krokvechodn = 171213 AND skv.platnostdo is null

-- WHERE p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/17_123/0016945','CZ.01.1.02/0.0/0.0/17_125/0014246','CZ.01.1.02/0.0/0.0/17_142/0013021','CZ.01.1.02/0.0/0.0/17_121/0014419')
WHERE NOT EXISTS
(SELECT	1
 FROM isum.v_bi_UmvHodnStatusDH status
 WHERE status.id_krokvechodn = 171214
 AND  status.id_noshodnoceni = p.id)

) prvni ON prvni.id = p.id

LEFT JOIN (SELECT p.id ,
       status.pocetbodu ,
       skv.LimitVyhovelBodu 
FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni = p.id AND id_krokvechodn = 171214
INNER JOIN isum.v_bi_UMVHodnSoubKritVyz skv ON skv.id_vyzva = v.id AND skv.id_krokvechodn = 171214 AND skv.platnostdo is null
) druhy ON druhy.id = p.id


-- WHERE p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/17_123/0016945','CZ.01.1.02/0.0/0.0/17_125/0014246','CZ.01.1.02/0.0/0.0/17_142/0013021','CZ.01.1.02/0.0/0.0/17_121/0014419')

-- AND NOT REGEXP_LIKE(uj."Název", '[0-9]$')

GROUP BY v."Číslo výzvy",
       v."Název výzvy" ,
       p."Registrační číslo projektu",
       p."Název projektu CZ",
       p.zadatel,
       p."Datum registrace žádosti",
       p.VelikostPodniku,
       p.kodwfstav,
       gg.eu,
       gg.czv ,
       prvni.pocetbodu ,
       prvni.LimitVyhovelBodu ,
       druhy.pocetbodu ,
       druhy.LimitVyhovelBodu 

--       -- skv.LimitVyhovelBodu


--------------
-- kde neexistuje 2. krok vh , VH tedy probíhá v 1. kroku

SELECT p."Registrační číslo projektu" ,
       prvni.pocetbodu as "Bodů 1. krok VH", 
       prvni.LimitVyhovelBodu as "Limit 1. krok VH" 


FROM isum.v_bi_UmzPrjGGII p 
LEFT JOIN (SELECT p.id ,
       status.pocetbodu ,
       skv.LimitVyhovelBodu 
FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni = p.id AND id_krokvechodn = 171213
INNER JOIN isum.v_bi_UMVHodnSoubKritVyz skv ON skv.id_vyzva = v.id AND skv.id_krokvechodn = 171213 AND skv.platnostdo is null

WHERE p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/17_123/0016945','CZ.01.1.02/0.0/0.0/17_125/0014246','CZ.01.1.02/0.0/0.0/17_142/0013021','CZ.01.1.02/0.0/0.0/17_121/0014419')

AND NOT EXISTS
--  (SELECT 1
--  FROM isum.v_bi_UMVHodnSoubKritVyz skv
--  WHERE v.id=p.id_vyzva
--  AND skv.id_vyzva = v.id
--  AND skv.id_krokvechodn = 171214)
(SELECT	1
 FROM isum.v_bi_UmvHodnStatusDH status
 WHERE status.id_krokvechodn = 171214
 AND status.id_noshodnoceni = p.id)

) prvni ON prvni.id = p.id

-- LEFT JOIN (SELECT p.id ,
--        status.pocetbodu ,
--        skv.LimitVyhovelBodu 
--        FROM isum.v_bi_UmzPrjGGII p
--        INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
--        INNER JOIN isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni = p.id AND id_krokvechodn = 171214
--        INNER JOIN isum.v_bi_UMVHodnSoubKritVyz skv ON skv.id_vyzva = v.id AND skv.id_krokvechodn = 171214 AND skv.platnostdo is null

-- -- WHERE p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/17_123/0016945','CZ.01.1.02/0.0/0.0/17_125/0014246','CZ.01.1.02/0.0/0.0/17_142/0013021')
-- ) druhy ON druhy.id = p.id

WHERE p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/17_123/0016945','CZ.01.1.02/0.0/0.0/17_125/0014246','CZ.01.1.02/0.0/0.0/17_142/0013021','CZ.01.1.02/0.0/0.0/17_121/0014419')




---------------
-- Testovací


SELECT p."Registrační číslo projektu",	
       status.pocetbodu 
       
FROM isum.v_bi_UmzPrjGGII p  
LEFT JOIN isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni = p.id AND status.id_krokvechodn = 171214

WHERE status.id = 604025782
-- p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/17_123/0016945','CZ.01.1.02/0.0/0.0/17_125/0014246','CZ.01.1.02/0.0/0.0/17_142/0013021')



