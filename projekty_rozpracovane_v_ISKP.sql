SELECT v."Číslo výzvy" ,	p.*
FROM 		isum.v_bi_UmzProjekt p 
INNER JOIN 	isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva

WHERE p."Název projektu CZ" like 'Autonomní robotická%'
AND v."Číslo výzvy" = '31_25_163'
