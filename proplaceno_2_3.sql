SELECT v."Èíslo výzvy",
	p."Registraèní èíslo projektu" ,
	p.kodwfstav,
	platba."Èíslo ¾ádosti o platbu" ,
	platba."Datum proplacení pøíjemci" "Datum propacení" ,
	platba.kodwfstav "Stav platby" 
	-- rf.CASTKASCHVALENA  "Proplaceno (EU podíl)",
	-- ind."Dosa¾ená hodnota" "Zvý¹ení el. výkonu v MW (ind 33902)" 
	-- ind.komentar "Komentáø k indikátoru"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
-- INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel 
INNER JOIN isum.v_bi_UmpPlatba platba ON p.id=platba.id_NositelPlatby  
-- INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- øádky cis.
-- INNER JOIN isum.v_bi_UmvIndiHodnotaPRJ ind ON ind.id_nositelindi=p.id AND ind.id_indikator = 667482 AND ind.id_speccil > 0 

WHERE v."Èíslo výzvy" IN ('31_22_001', '31_22_005')
AND platba.kodwfstav IN ('P4','P5','P5T','P6','P6T','P7')

-- AND platba."Datum zmìny stavu" <= to_date('2025-03-02','yyyy-mm-dd')
-- AND platba."Datum zmìny stavu" >= to_date('2025-01-01','yyyy-mm-dd')
-- AND p."Registraèní èíslo projektu"  = 'CZ.31.3.0/0.0/0.0/22_005/0003640'
