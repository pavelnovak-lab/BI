SELECT  v."Èíslo výzvy",
	v."Název výzvy",
	pol."Kód" "Kód polo¾ky",
	pol."Název" "Název polo¾ky",
	cis."Název" "Èíselníkový název"

FROM isum.v_bi_UmzVyzva v 
INNER JOIN isum.v_bi_UmzVyzvaMD md ON md.id_vyzva = v.id
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = md.id_ciszakladni
INNER JOIN isum.v_bi_UmfRozSkupina sk ON sk."Kód" = ci."Kód" AND sk."Název skupiny rozpoètu" = ci."Název" 
INNER JOIN isum.v_bi_UmfRozSkupinaPol pol ON pol.id_predpis = sk.id
LEFT JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = pol.id_verejnapodpora  

WHERE
-- REGEXP_LIKE( v."Èíslo výzvy", '3[1-8][0-9]$')
   md."Platnost" = 'A'
AND   pol."Platnost" = 'A'
AND   pol."Listová" = 'A'
AND   (pol."Nezpùsobilé výdaje" = 'N' OR pol."Nezpùsobilé výdaje" is null)
AND   cis."Název" <> 'Mimo re¾im veøejné podpory'
AND   cis."Název" <> 'DE MINIMIS'
-- AND pol."Název" like '%69%'
-- AND v."Èíslo výzvy" = '01_19_248'

ORDER BY v."Èíslo výzvy" ASC, pol."Kód" ASC

----------------------
SELECT v."Èíslo výzvy",
       v."Název výzvy" ,

FROM isum.v_bi_UmzVyzva v
INNER JOIN isum.v_bi_UMFPomeryHlavicka pf




----------------------------------------------------------------------------------------
SELECT 	listagg (pf."Regionální podpora", '; ') "Check VPo",
	v."Èíslo výzvy",
	v."Název výzvy",
        listagg (pf."Název" , '; ' ) AS "Pomìry financování název"

FROM isum.v_bi_UmzVyzva v 
INNER JOIN isum.v_bi_UMFPomeryHlavicka pf ON pf.ID_NOSITELPOMPF = v.id 


WHERE v."Èíslo výzvy" in ('01_19_262','01_20_321','01_19_253','01_18_242','01_18_215','01_15_022','01_17_105','01_19_283','01_19_264','01_15_023','01_18_221','01_18_213','01_17_102','01_20_324','01_16_063','01_15_030','01_16_076','01_20_369','01_20_326','01_20_327','01_16_061','01_17_096','01_16_085','01_16_049','01_16_062','01_16_130','01_15_025','01_15_005','01_16_047','01_16_087','01_16_077','01_16_064','01_17_206','01_16_132')


GROUP BY pf."Regionální podpora",
	v."Èíslo výzvy",
	v."Název výzvy"

ORDER BY v."Èíslo výzvy"
