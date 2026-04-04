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
       druhy.pocetbodu as "Bodů 2. krok VH", 
       druhy.LimitVyhovelBodu as "Limit 2. krok VH" 

       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva AND v."OP kod" = '01' AND v."Číslo výzvy" = '01_20_321'

LEFT JOIN (SELECT p.id ,
       status.pocetbodu ,
       skv.LimitVyhovelBodu 
FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva AND v."Číslo výzvy" = '01_20_321'
INNER JOIN isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni = p.id AND id_krokvechodn = 171213
INNER JOIN isum.v_bi_UMVHodnSoubKritVyz skv ON skv.id_vyzva = v.id AND skv.id_krokvechodn = 171213 AND skv.platnostdo is null
) prvni ON prvni.id = p.id

LEFT JOIN (SELECT p.id ,
       status.pocetbodu ,
       skv.LimitVyhovelBodu 
FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva AND v."Číslo výzvy" = '01_20_321'
INNER JOIN isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni = p.id AND id_krokvechodn = 171214
INNER JOIN isum.v_bi_UMVHodnSoubKritVyz skv ON skv.id_vyzva = v.id AND skv.id_krokvechodn = 171214 AND skv.platnostdo is null
) druhy ON druhy.id = p.id

WHERE p."Registrační číslo projektu" = 'CZ.01.1.02/0.0/0.0/20_321/0024409'


