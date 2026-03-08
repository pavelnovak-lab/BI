SELECT p."Registraèní èíslo projektu" ,
       p.kodwfstav , 
       SUBSTR(p."Registraèní èíslo projektu", 7, 1) AS "Èíslo komp",
       p."Datum ukonèení pøedp",
       p.wfstavdatum,
       p."Datum zahájení pøedp"        ,
       v."Název výzvy" ,
       v."Èíslo výzvy"
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 

WHERE p."Registraèní èíslo projektu" like 'CZ.31.%'
AND p.kodwfstav not like 'PN%'
AND v."Èíslo výzvy" IN ('31_22_011','31_22_013','31_23_070','31_22_014','31_22_015','31_22_001','31_22_006','31_22_005','31_22_017','31_23_069','31_22_008','31_22_010')
AND p.zadatel <> 'Ministerstvo prùmyslu a obchodu'
