SELECT  p."Registrační číslo projektu",
--	ki.*

	ci."Kód",
	ci."Název"
	-- LISTAGG(ci."Kód",'; ') WITHIN GROUP (ORDER BY ci."Kód") AS "Kód",
	-- LISTAGG(ci."Název",'; ') WITHIN GROUP (ORDER BY ci."Kód") AS "Název"


FROM		isum.v_bi_UmzProjekt p
INNER JOIN	isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN	isum.v_bi_UmzPrjKI ki ON p.id=ki.id_projekt AND ki."Typ kategorie intervencí" = 7
INNER JOIN 	isum.v_bi_UmsCisZakladni ci ON ki.id_ki=ci.id

WHERE p."Registrační číslo projektu" = 'CZ.01.1.02/0.0/0.0/17_107/0012450'
-- v."Číslo výzvy"='01_19_262'

-- AND   ki."Typ kategorie intervencí"=0

-- GROUP BY p."Registrační číslo projektu",p."Zaměřeno na probl vody sucha",p.kodwfstav , p."Název projektu CZ" 

ORDER BY p."Registrační číslo projektu" 
