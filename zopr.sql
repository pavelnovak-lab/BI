SELECT p."Registraèní èíslo projektu",
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
       SUBSTR(p."Registraèní èíslo projektu", 7, 1) "Prioritní osa",
       -- vk.id_vysledekprezkumu "Proti VK Dùvodná/Nedùvodná",
       -- hodn.id_vysledekprezkumu "Proti hodn dùvodná/nedùvodná",
       ci."Název"
       
    
FROM isum.v_bi_UmzProjekt p 

-- INNER JOIN isum.v_bi_UMVHodnVyporadani hodn ON hodn.id_noshodnoceni = p.id
-- INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = hodn.id_vysledekprezkumu

-- WHERE hodn.id_vysledekprezkumu > 1
-- AND hodn.id_namitka > 1
-- AND p."Registraèní èíslo projektu" is not null 


INNER JOIN isum.v_bi_UMVHodnVyporadaniVK vyporadaniVK ON p.id = vyporadaniVK.id_noshodnoceni
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = vyporadaniVK.id_vysledekprezkumu

WHERE p."Registraèní èíslo projektu" is not null 
AND vyporadaniVK."Byla ¾ádost o pøezk vypoøádána" = 'A'


-- LEFT JOIN ( SELECT vyporadaniVK.id_noshodnoceni,
--      	    	   -- ci."Název"
-- 		   vyporadaniVK.id_vysledekprezkumu
-- FROM 
-- -- INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = vyporadaniVK.id_vysledekprezkumu
-- WHERE vyporadaniVK."Byla ¾ádost o pøezk vypoøádána" = 'A'
-- -- AND vyporadaniVK.id_noshodnoceni in (1263496684, 1250073568)
-- ) vk ON vk.id_noshodnoceni = p.id 

-- WHERE p."Registraèní èíslo projektu" is not null 
-- -- AND vyp.id = 1250855907
-- -- AND vysledek."Platný" = 'A'
-- AND p."Registraèní èíslo projektu" in ('CZ.01.1.02/0.0/0.0/20_321/0025223','CZ.01.2.06/0.0/0.0/20_322/0025458')



-- GROUP BY SUBSTR(p.kompetencniutvar, 6 ) ,
--        SUBSTR(p."Registraèní èíslo projektu", 7, 1) ,
--        vysledek."Název" "Výsledek PK"



