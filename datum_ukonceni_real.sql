SELECT p."Registraèní èíslo projektu",
       p."Datum ukonèení pøedp",
       p."Datum ukonèení skut",
       p.kodwfstav ,
       v."Nejzaz¹í datum pro ukonèení fy",
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" 


FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva

WHERE p."Registraèní èíslo projektu" is not null
-- AND p."Datum ukonèení pøedp" > '06-30-2023'
-- AND (p."Datum ukonèení pøedp" > (:P_DatumOD) or (:P_DatumOD) is null)
-- AND SUBSTR(p.kompetencniutvar, 6 ) is not 'Technická pomoc'
AND    p."Datum ukonèení pøedp" > v."Nejzaz¹í datum pro ukonèení fy"
    
AND SUBSTR(p.kompetencniutvar, 6 ) in ('Aplikace','Inovace','Technologie','Potenciál')
