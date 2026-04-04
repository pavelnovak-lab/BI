SELECT 	p."Registrační číslo projektu",
	hodn.pocetbodu,
	hodn.typhodnotitele,
	hodn.datum_finalizace,
	hodn.poradi,
	hodn.create_uzivatel

FROM		isum.v_bi_UmzProjekt p
INNER JOIN	isum.v_bi_UmzVyzva v ON p.id_vyzva=v.id 
INNER JOIN 	isum.v_bi_UmvHodnoceni hodn ON hodn.id_noshodnoceni=p.id


WHERE	 v.id = 575615219 /* 01_19_250, Technologie X. */
-- p.id = 914866751
AND	 hodn.id_krokvechodn = 171214 /* 2. krok VH */
AND	 hodn.platnost = 'A'
AND 	 hodn.finalizovano = 'A'
AND	 hodn.opravnehodnoceni = 'N'
AND	 hodn.pocetbodu <> 0
