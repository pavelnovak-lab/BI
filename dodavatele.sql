SELECT		p."Registraèní èíslo projektu",
		p.kodwfstav,
		pp.zadatel,
 		pp."IÈ" as "IÈ ¾adatele",
		p.eu as "Po¾adovaná dotace",
		vs."IÈ" as "IÈ dodavatele",
		vs.jmenoanazev,
		SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory"


FROM isum.v_bi_UmzPrjGG p
INNER JOIN isum.v_bi_UmzProjekt pp ON pp.id = p.id
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.id_typsubjektu = 300786


WHERE p."Registraèní èíslo projektu" is not null 
AND vs.neplatny is null

ORDER BY p."Registraèní èíslo projektu" 


