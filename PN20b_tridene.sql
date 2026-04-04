SELECT	p."Registrační číslo projektu",
	-- hs."STAVDO",
	-- hs."STAVDONAZEV",	
	-- hs."STAVZ",
	-- hs."STAVZNAZEV",	
	-- p."KODWFSTAV",
--	max(hs."CREATE_CAS") as "Maximální čas"
--	hs."CREATE_CAS"-p."Datum prvního podání"
 	(row_number() OVER (PARTITION BY p."Registrační číslo projektu"  ORDER BY hs."CREATE_CAS" DESC)) as "Pořadí"

	FROM isum.v_bi_umzprojekt p 
	INNER JOIN   isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id
	INNER JOIN   isum.v_bi_umzvyzva v ON v.id=p.id_vyzva

	WHERE p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/15_014/0005890','CZ.01.1.02/0.0/0.0/15_014/0000318')
--	v."Číslo výzvy"='01_15_014'
	AND	hs."STAVZNAZEV" not like 'Předběžná%'
--	AND 	p."KODWFSTAV" = 'PN20b'
	

-- WHERE "Pořadí" in ('1', '2','3')

-- group by p."Registrační číslo projektu"
