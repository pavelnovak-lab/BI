

FROM isum.v_bi_UmzProjekt p 
INNER JOIN (
SELECT sum(p.id) "Ano"
	p.id
	from   isum.v_bi_UmzProjekt p
	where p."Registrační číslo projektu" is not null
	AND p."Zaměřeno na probl vody sucha" = 'A') ano ON ano.id = p.id
INNER JOIN (SELECT sum(p.id) "Ne"
	p.id
	from   isum.v_bi_UmzProjekt p
	where p."Registrační číslo projektu" is not null
	AND p."Zaměřeno na probl vody sucha" = 'A'
	GROUP BY ) ne ON ne.id = p.id
	
