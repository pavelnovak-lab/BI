SELECT p."Registrační číslo projektu",
       v."Název výzvy", 
       p.PRIJMY55,
       gg.eu

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
WHERE p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42')
AND   p.PRIJMY55 <> 'Projekt nevytváří příjmy dle článku 61'

GROUP BY p.PRIJMY55

ORDER BY v."Název výzvy" 
