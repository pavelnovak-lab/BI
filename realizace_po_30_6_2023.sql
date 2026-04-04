SELECT p."Registrační číslo projektu",
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
       p."Datum ukončení předp",
       p.kodwfstav 

FROM isum.v_bi_UmzProjekt p 

WHERE p."Registrační číslo projektu" is not null
-- AND p."Datum ukončení předp" > '06-30-2023'
AND (p."Datum ukončení předp" > (:P_DatumOD) or (:P_DatumOD) is null)
-- AND SUBSTR(p.kompetencniutvar, 6 ) is not 'Technická pomoc'

ORDER BY SUBSTR(p.kompetencniutvar, 6 )
