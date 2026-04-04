SELECT	p."Identifikace žádosti (Hash)",
	p.CREATE_CAS "Založení žádosti",
	p."Datum finalizace",
	p."Datum podání",
	p."Datum podpisu",
	p."Datum registrace žádosti",
	p.DATUMPODPISUZAD

FROM 		isum.v_bi_umzprojekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva	
-- INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id

WHERE p."Identifikace žádosti (Hash)" = '1k0cWIP'
