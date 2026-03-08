SELECT 	p."Registraèní èíslo projektu",
	p."Název projektu CZ",
	p."IÈ",
	p.zadatel,
	v."Èíslo výzvy",
	v."Název výzvy",
	p.kodwfstav,
	p.wfstavdatum,
	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
	gg.eu,
	gg.czv,
	hs.datumod AS "Datum pøepnutí do X",
	p."Poèet ZoU"


FROM 		isum.v_bi_UmzProjekt p
INNER JOIN	isum.v_bi_umzvyzva v ON p.id_vyzva=v.id
INNER JOIN	isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id 
INNER JOIN 	isum.v_bi_umzprjgg gg ON gg.id=p.id 


WHERE p.kodwfstav in ('PP41','PP42')
AND p.kodprioritniosa <> '01.5'
AND hs.STAVDO = :kod_stavu

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) asc 

