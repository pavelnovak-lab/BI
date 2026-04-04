SELECT 	p."Registrační číslo projektu",
	p."Název projektu CZ",
	v."Číslo výzvy",
	v."Název výzvy",
	p.kodwfstav,
	gg.eu,
	gg.czv,
	p.velikostpodniku,
	hs.datumod AS "Datum přepnutí do PP30"


FROM 		isum.v_bi_Umzprojekt p
INNER JOIN	isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id 
INNER JOIN	isum.v_bi_umzvyzva v ON p.id_vyzva=v.id
INNER JOIN	isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id 
INNER JOIN 	isum.v_bi_umzprjgg gg ON gg.id=p.id 
-- INNER JOIN 	isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id 
-- INNER JOIN	isum.v_bi_UmsCisZakladni cis ON vs.id_velikostpodniku = cis.id

WHERE v."Číslo výzvy" in ('01_20_357')

AND hs.STAVDO = 'PP30'
