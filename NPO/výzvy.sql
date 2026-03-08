SELECT  v."Číslo výzvy" ,
	v."Název výzvy" ,
	sc."Číslo specifického cíle / oper",
 	sc.nazev
FROM isum.v_bi_UmzVyzva v
INNER JOIN isum.V_BI_UMZVyzvaHierarchie vh ON vh.id_vyzva = v.id
INNER JOIN isum.V_BI_UMSHISC sc ON sc.id=vh.id_speccil


WHERE v."Číslo výzvy" IN ('31_22_011', '31_22_013', '31_23_070', '31_23_076', '31_22_014', '31_22_015', '31_23_079', '31_23_080', '31_23_098', '31_23_100', '31_22_001', '31_22_005', '31_22_006', '31_22_017', '31_23_069', '31_22_008', '31_22_010', '31_25_157', '31_23_116')

ORDER BY sc."Číslo specifického cíle / oper"
