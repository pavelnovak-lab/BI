SELECT 	p."Registrační číslo projektu",
	p."Název projektu CZ",
	v."Číslo výzvy",
	v."Název výzvy",
	p.kodwfstav,
	p.eu,
	p.czv,
	p.wfstav,
	p.wfstavdatum
--	hs.datumod,

FROM 		isum.v_bi_Umzprjgg p
-- INNER JOIN	isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id 
INNER JOIN	isum.v_bi_umzvyzva v ON p.id_vyzva=v.id

WHERE p.kodwfstav = 'PN23a'
-- v."Číslo výzvy" in ('01_17_106','01_17_107')

-- AND hs.STAVDO in ('PP21','PP22')
-- AND p.kodwfstav in ('PP21','PP22')


AND EXISTS
(SELECT p."Registrační číslo projektu" 
	FROM 		isum.v_bi_Umzprjggii pp
	INNER JOIN	isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id 
	WHERE hs.STAVDO = 'PP27b'
	AND pp.id=p.id)

-- ORDER BY "Počet dní po FNaP"
