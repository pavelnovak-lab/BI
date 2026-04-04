SELECT 	p."Registraèní èíslo projektu",
	p."Název projektu CZ",
	v."Èíslo výzvy",
	v."Název výzvy",
	-- p.kodwfstav,
	-- p.eu,
	-- p.czv,
	-- p.wfstav,
	-- p.wfstavdatum,
	hs.datumod AS "Datum pøepnutí do PP30"
--	hs.datumod,

FROM 		isum.v_bi_Umzprjgg p
-- INNER JOIN	isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id 
INNER JOIN	isum.v_bi_umzvyzva v ON p.id_vyzva=v.id
INNER JOIN	isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id 

WHERE v."Èíslo výzvy" in ('01_19_250', '01_19_248', '01_20_357')

AND hs.STAVDO = 'PP30'


-- AND EXISTS
-- (SELECT p."Registraèní èíslo projektu" 
-- 	FROM 		isum.v_bi_Umzprjggii pp

-- 	WHERE hs.STAVDO = 'PU27'
-- 	AND pp.id=p.id)

-- ORDER BY "Poèet dní po FNaP"
