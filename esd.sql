-- SELECT DISTINCT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
--        v."Číslo výzvy" ,
--        v."Název výzvy" ,
--        p."Bude se pořizovat EDSSMVS"

-- FROM isum.v_bi_UmzProjekt p
-- INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva

-- WHERE
-- SUBSTR(p.kompetencniutvar, 6) = 'Inovace'
-- -- SUBSTR(p.kompetencniutvar, 6) = 'Inovační vouchery'
-- AND p."Registrační číslo projektu" is not null 
-- AND v."Číslo výzvy" = '01_16_049'


-- ORDER BY v."Číslo výzvy" 


SELECT p."Bude se pořizovat EDSSMVS",
       p."Název projektu CZ",
       p.zadatel,
       p."Registrační číslo projektu" 

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva

WHERE p."Registrační číslo projektu" is not null 
AND v."Číslo výzvy" = '01_16_049'
AND p."Bude se pořizovat EDSSMVS" = 'A'


