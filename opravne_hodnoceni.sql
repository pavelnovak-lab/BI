SELECT 	p."Registrační číslo projektu",
	count(hkr.needitovatelne) AS pocet_edit
	

FROM 		isum.v_bi_umzprojekt p
inner join	isum.v_bi_umvhodnoceni h ON h.id_noshodnoceni=p.id
inner join	isum.V_bi_umvhodnotakrit hkr ON hkr.id_hodnoceni=h.id


-- inner join 	isum.v_bi_UMVHODNSTATUSDH hstat on hstat.id_noshodnoceni=p.id and hstat.id_krokvechodn=0

-- inner join 	isum.v_bi_umvhodnoceniprj hprj ON hprj.id_hodnoceni=h.id


--inner join	isum.V_BI_UMVHODNOTAKRITPRJ hkrprj hkrprj.id_hodnoceni=h.id


WHERE	p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/16_084/0009807')
AND	h.druhhodn = 'Věcné hodnocení' 
-- AND	h.id_krokvechodn = 171214
AND	h.opravnehodnoceni = 'A'
AND 	hkr.needitovatelne = 'N' 
AND	h.platnost = 'A'


GROUP BY p."Registrační číslo projektu"


-- SELECT *

-- FROM isum.v_bi_umvhodnotakrit 

-- WHERE id_hodnoceni = 443086728
