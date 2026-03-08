SELECT p."Registraèní èíslo projektu" ,
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
       p.kodwfstav 

FROM isum.v_bi_UmzProjekt p

WHERE p."Registraèní èíslo projektu" is not null 

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) asc
