SELECT	p."Registrační číslo projektu",
	p."Název projektu CZ" ,
	p.kodwfstav, 
	p."Počet ZoU"

FROM 	isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva

WHERE v."Číslo výzvy" = '01_20_322'
AND p."Registrační číslo projektu" is not null


