SELECT p."Registrační číslo projektu",
       p.wfstavdatum,
       platba."Datum změny stavu" ,
       platba.kodwfstav as "Stav platby",
       p.kodwfstav as "Stav projektu" ,
       hs.create_uzivatel as "Do PP41 přepnul" ,
       hs.create_cas as "Čas přepnutí PP41"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id

WHERE p."Registrační číslo projektu" is not null 
AND platba."Závěrečná platba" = 'A'
AND platba.kodwfstav in ('P10','P11')
AND trunc(platba."Datum změny stavu") > to_date('2021-03-01','yyyy-mm-dd')
AND hs.stavdo = 'PP41'
AND p.kodwfstav in ('PP40','PP41')

ORDER BY p.wfstavdatum DESC
