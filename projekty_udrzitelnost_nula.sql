SELECT	p."Registraèní èíslo projektu",
	p."Poèet ZoU",
	v."Èíslo výzvy",
	v."Název výzvy",
	p.kodwfstav 
	
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON p.id_vyzva=v.id 

WHERE p."Registraèní èíslo projektu" is not null
AND v."Èíslo výzvy" in ('01_15_023','01_15_020','01_16_086','01_19_285','01_18_232','01_18_182','01_18_183','01_18_185','01_18_189','01_18_190','01_18_231','01_18_237','01_17_204','01_18_233','01_18_234','01_18_236','01_17_100','01_20_345','01_19_251','01_19_252','01_19_253','01_19_254','01_19_255','01_18_242','01_18_245','01_18_186','01_19_300','01_19_301','01_18_235','01_18_181','01_18_180','01_18_179','01_18_184','01_18_187','01_18_188','01_19_316','01_16_056')
AND (p."Poèet ZoU" is null OR p."Poèet ZoU" = 0)
AND p.kodwfstav not in ('PN%')

ORDER BY v."Èíslo výzvy"
