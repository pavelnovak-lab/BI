SELECT v."Název výzvy",
       v."Číslo výzvy" ,
       p."Registrační číslo projektu",
       p.zadatel,
       p.kodwfstav,
       status.pocetbodu as "Bodů VH" ,
       skv.LimitVyhovelBodu
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva AND v."OP kod" = '01'
INNER JOIN isum.v_bi_UmzVyzvaKategorie kat ON kat.id_vyzva = v.id AND kat.integrovany = 'Ano'
LEFT JOIN isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni = p.id AND status.id_krokvechodn = 171214
INNER JOIN isum.v_bi_UMVHodnSoubKritVyz skv ON skv.id_vyzva = v.id AND skv.id_krokvechodn = 171214 AND skv.PLATNOSTDO is null

WHERE p."Registrační číslo projektu" is not null
