SELECT  p."Registrační číslo projektu",
	LISTAGG(ci."Kód",'; ') WITHIN GROUP (ORDER BY ci."Kód") AS "Kód",
	LISTAGG(ci."Název",'; ') WITHIN GROUP (ORDER BY ci."Kód") AS "Název"


FROM		isum.v_bi_UmzProjekt p
INNER JOIN	isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN	isum.v_bi_UmzPrjKI ki ON p.id=ki.id_projekt
INNER JOIN 	isum.v_bi_UmsCisZakladni ci ON ki.id_ki=ci.id

WHERE v."Číslo výzvy"='01_19_262'
AND   p."Registrační číslo projektu" is not null
AND   ki."Typ kategorie intervencí"=0

GROUP BY p."Registrační číslo projektu" 



-- SELECT  count(p."Registrační číslo projektu")

-- FROM		isum.v_bi_UmzProjekt p
-- INNER JOIN	isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 

-- WHERE v."Číslo výzvy"='01_19_262'
-- AND   p."Registrační číslo projektu" is not null

