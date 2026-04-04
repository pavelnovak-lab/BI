SELECT tabulka.*

FROM (SELECT	p."Registrační číslo projektu",
	hs."STAVDO",
	p."Datum prvního podání",
	hs."STAVDONAZEV",	
	hs."STAVZ",
	hs."STAVZNAZEV",	
	p."KODWFSTAV",
	hs."CREATE_CAS",
	hs."CREATE_UZIVATEL",
	hs."CREATE_CAS"-p."Datum prvního podání",
 	(row_number() OVER (ORDER BY hs."CREATE_CAS" DESC)) as "Pořadí"

	FROM isum.v_bi_umzprojekt p 
	INNER JOIN   isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id
	INNER JOIN   isum.v_bi_umzvyzva v ON v.id=p.id_vyzva

	WHERE 	v."Číslo výzvy"='01_15_014'
	AND	hs."STAVZNAZEV" not like 'Předběžná%'
	AND 	p."KODWFSTAV" = 'PN20b') tabulka

WHERE "Pořadí" in ('1', '2','3')
