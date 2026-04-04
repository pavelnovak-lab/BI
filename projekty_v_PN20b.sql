SELECT p."Registrační číslo projektu",
       hs.stavz,
       p.kodwfstav
       

FROM   	   isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id

WHERE hs.stavz IN ('PP20','PP21','PP22','PP23a','PP23b')
AND   p.kodwfstav = 'PN20b'
