SELECT	p."Registrační číslo projektu" ,
	p."Název projektu CZ",
	s."Název subjektu" "Žadatel" ,
	p.id_isg
       -- 	isg."Číslo integrované strategie",
       -- isg."Název integrované strategie"

	

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null -- AND s.id_typsubjektuedit IN (413462, 413467) -- žadatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 
/* Proč nefunguje LEFT JOIN? */
LEFT JOIN integrovane_strategie isg on isg.id = p.id_isg


WHERE v."Číslo výzvy" = '01_25_069'
AND p."Registrační číslo projektu" is not null
AND s."Název subjektu" "Žadatel" = 'Univerzita Tomáše Bati ve Zlíně'
