SELECT p."Registrační číslo projektu",
       hs.*

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id

WHERE p."Registrační číslo projektu" = 'CZ.31.3.0/0.0/0.0/22_001/0007062'
