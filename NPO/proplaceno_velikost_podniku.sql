SELECT  CASE WHEN v."Èíslo výzvy" = '31_22_014' THEN 'Digitální podnik'
	     WHEN v."Èíslo výzvy" = '31_22_015' THEN 'Virtuální podnik'
	     END "Aktivita",
	v."Èíslo výzvy",
	p."Registraèní èíslo projektu" ,
	p.kodwfstav,
	p.zadatel ,
	p."IÈ" ,
	p.velikostpodniku,
	vs."Poèet zamìstnancù",
	LISTAGG( platba."Datum proplacení pøíjemci", '; ') "Datum propacení",
	sum(rf.CASTKASCHVALENA)  "Celkem proplaceno (EU podíl)"
	-- ind."Dosa¾ená hodnota" "Zvý¹ení el. výkonu v MW (ind 33902)" 
	-- ind.komentar "Komentáø k indikátoru"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.kodwfstav in ('P10','P11') 
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- øádky cis.
-- INNER JOIN isum.v_bi_UmvIndiHodnotaPRJ ind ON ind.id_nositelindi=p.id AND ind.id_indikator = 667482 AND ind.id_speccil > 0 

WHERE v."Èíslo výzvy" IN ('31_22_014', '31_22_015')
AND platba."Datum proplacení pøíjemci" <= to_date('2024-12-31','yyyy-mm-dd')
AND platba."Datum proplacení pøíjemci" >= to_date('2024-07-01','yyyy-mm-dd')



GROUP BY
        CASE WHEN v."Èíslo výzvy" = '31_22_014' THEN 'Digitální podnik'
	     WHEN v."Èíslo výzvy" = '31_22_015' THEN 'Virtuální podnik'
	     END ,
	v."Èíslo výzvy",
	p."Registraèní èíslo projektu" ,
	p.kodwfstav,
	p.zadatel ,
	p."IÈ" ,
	p.velikostpodniku,
	vs."Poèet zamìstnancù"

ORDER BY "Datum propacení"
