SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory", 
       p."Registraèní èíslo projektu",
       p.kodwfstav ,
       v."Název výzvy" ,
       v."Èíslo výzvy" ,
       pol."Kód",
       pol."Název" "Název polo¾ky",
       pol."Èástka celkem" "Èástka na rozpoètu"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMFROZHlavickaPrj hl ON p.id = hl.id_nrozpocet AND hl."Aktuální" = 'A'
INNER JOIN isum.V_BI_UMFROZPOLOZKYPRJ pol ON pol.id_hlavicka = hl.id 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 

WHERE p."Registraèní èíslo projektu" is not null 
AND pol.LISTOVA = 'A'
AND v."Èíslo výzvy" in ('01_19_278','01_20_326','01_20_362','01_17_193','01_17_201','01_17_203','01_18_198','01_19_286','01_19_290','01_19_299','01_19_300','01_19_311','01_21_380','01_19_297', '01_20_338', '01_21_375', '01_19_266', '01_19_273', '01_20_339')
AND (pol."Název" like '%udov%' or pol."Název" like '%tavb%')
AND p.kodwfstav in ('PP27a','PP27b','PP29','PU27','PP30','PP36','PP37') 
ORDER BY substr(p.kompetencniutvar, 6), v."Èíslo výzvy", substr(p."Registraèní èíslo projektu",-5,5)
