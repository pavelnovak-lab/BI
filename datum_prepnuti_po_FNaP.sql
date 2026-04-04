SELECT p."Registrační číslo projektu" ,
       p.zadatel,
       p."Název projektu CZ" ,
       p.kodwfstav ,
       p.wfstavdatum 

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva


WHERE v."Číslo výzvy" = '01_20_370'
AND p.kodwfstav in ('PP21','PP22')
AND AND trunc(p.wfstavdatum) > to_date('2021-03-07','yyyy-mm-dd')

ORDER BY p.wfstavdatum DESC
