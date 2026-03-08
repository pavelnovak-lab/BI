SELECT 	-- DISTINCT p."Registraèní èíslo projektu",
	p."Registraèní èíslo projektu" ,
	-- ind."Kód NÈI 2014+" "Kód indikátoru",
	-- ind."Název indikátoru" ,
	
	max(indprj."Cílová hodnota") 
	-- indprj."Dosa¾ená hodnota" ,
	
	-- cis."Název" "Mìrná jednotka",
	-- indprj."Datum cílové hodnoty" 
	-- indprj.*




FROM 		isum.v_bi_UmzProjekt p
INNER JOIN	isum.v_bi_umzvyzva v ON p.id_vyzva=v.id
INNER JOIN	isum.v_bi_UmvIndiHodnotaPRJ indprj ON indprj.id_nositelindi=p.id
-- INNER JOIN 	isum.v_bi_UmvIndikator ind ON ind.id=indprj.id_indikator
-- INNER JOIN	isum.v_bi_umsciszakladni cis ON cis.id=ind.id_mernajednotka

WHERE p."Registraèní èíslo projektu" is not null
AND v."Èíslo výzvy" = '31_22_001'
-- AND p."Registraèní èíslo projektu" = 'CZ.31.3.0/0.0/0.0/22_005/0000082'
-- and ind."Kód NÈI 2014+" in ('33902')
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PU30') 

GROUP BY p."Registraèní èíslo projektu"

ORDER BY p."Registraèní èíslo projektu" 

