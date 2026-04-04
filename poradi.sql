SELECT tabulka.*

FROM (SELECT	p."Registrační číslo projektu",
	p."Datum prvního podání",
	p.KODWFSTAV,
 	(row_number() OVER (ORDER BY p."Datum prvního podání" DESC)) as "Pořadí"

	FROM isum.v_bi_umzprojekt p 
	INNER JOIN isum.v_bi_umzvyzva v ON v.id=p.id_vyzva

	WHERE 	v."Číslo výzvy"='01_17_095' 
	AND 	p."Registrační číslo projektu" is not null) tabulka

WHERE "Pořadí" = '2'
