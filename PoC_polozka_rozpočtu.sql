SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       v."Číslo výzvy",
       v."Název výzvy" ,
       p."Registrační číslo projektu",
       p.zadatel ,
       p."IČ",
       p.kodwfstav,
       pr."Název",
       pr."Částka celkem",
       pr."Procento"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UMFROZHlavicka hr ON hr.id_nrozpocet = p.id AND hr."Aktuální" = 'A'
INNER JOIN isum.v_bi_UMFROZPolozky pr ON pr.id_hlavicka = hr.id

WHERE upper(pr."Název") like '%ODPISY%'
AND SUBSTR(p.kompetencniutvar, 6) = 'Proof of concept'
-- AND hr.id = 1598486497
AND p.kodwfstav like 'PP%'

ORDER BY v."Číslo výzvy" 
