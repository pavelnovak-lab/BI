SELECT p."Registrační číslo projektu",
       p.kodwfstav,
       hs.datumOd

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId =p.id

WHERE p.kodwfstav = 'PN29'
AND hs.stavdo = 'PN29'

ORDER BY hs.DatumOd DESC
