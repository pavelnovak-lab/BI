SELECT p."Registrační číslo projektu" ,
       p.kodwfstav ,
        ci."Název",
        ci."Kód",
	nam.id_kolohodnoceni,
	cis.nazev as "Druh hodnocení",

	
FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UMVHodnNamitka nam ON nam.id_noshodnoceni = p.id
INNER JOIN isum.v_bi_UMVHodnVyporadani vyp ON nam.id_vyporadani = vyp.id
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = vyp.id_vysledekprezkumu
INNER JOIN isum.V_BI_UMVHodnDruhCis cis ON cis.id = nam.id_druhhodn



WHERE p.id = 175914938



-- AND cis.nazev is not null 
-- vk.id = 268292106

-- WHERE (p.kodwfstav like 'PP%' OR p.kodwfstav like 'V5')
-- AND EXISTS
-- (SELECT *
--  FROM isum.v_bi_UmsWFHistorieStavu hs
--  WHERE hs.NositelId = p.id
--  AND hs.stavdo = 'PN23a')
 


-- INNER JOIN isum.v_bi_UMVHodnKriterium krit ON krit.id = vk.id_hodnkriterium
-- LEFT JOIN isum.v_bi_UMVHodnKrokVecne krok ON krok.id = vk.id_krok
-- id_vysledekprezkumu
-- INNER JOIN isum.v_bi_UMVHodnVyslPrezkumu vysl ON vysl.id = vk.id_vysledekprezkumu
-- INNER JOIN isum.v_bi_UMVHodnSouborKrit sk ON sk.id = krit.id_souborkrit
-- INNER JOIN isum.v_bi_UMVHodnDruhCis cis ON cis.id = sk.id_druhhodn




