-- Sestava program podpory podle proplaceno a certifikováno
SELECT 	p.SpecifCil,
	p.KodSpecifCil,
	p.PrioritniOsa,
	p.KodPrioritniOsa,
	count(p.id),
-- 	p.kompetencniutvar AS "Program podpory" ,
	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
        sum(castky.EuVyuctCelkem) AS "Proplaceno"



FROM 	isum.v_bi_UmzProjekt p
-- INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpCastkySchval castky ON platba.id_SchvaleneCastky=castky.id 

WHERE p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43') 

-- GROUP BY p.kompetencniutvar
AND  p.kompetencniutvar not like ('%konkurenceschopnost')

GROUP BY p.kompetencniutvar ,
        p.SpecifCil,		    
	p.KodSpecifCil,
	p.PrioritniOsa,
	p.KodPrioritniOsa
