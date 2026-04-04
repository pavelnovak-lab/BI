SELECT 	p."Registrační číslo projektu",
	p."Název projektu CZ",
	v."Číslo výzvy",
	v."Název výzvy",
	p.kodwfstav,
	hs.datumod,
	(select count(*) 
		from isum.V_BI_UMSKALENDAR r 
		where r.datum between trunc(hs.datumod) and trunc(sysdate) 
		and r.dentydne not in (6,7) 
		and r.SVATEK='N') AS "Počet dní po FNaP"

FROM 		isum.v_bi_Umzprjggii p
INNER JOIN	isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id 
INNER JOIN	isum.v_bi_umzvyzva v ON p.id_vyzva=v.id

WHERE 	
-- v."Číslo výzvy"='01_19_252'
-- AND	
p."Registrační číslo projektu" like ('CZ.01.3%')
AND hs.STAVDO in ('PP21','PP22')
AND p.kodwfstav in ('PP21','PP22')

AND NOT EXISTS
(SELECT h.id_druhhodn 
	FROM isum.v_bi_Umzprjggii pp 
	INNER JOIN isum.v_bi_umvhodnotitelkompprj h ON pp.id=h.id_noshodnoceni 
	WHERE h.id_krokvechodn=171214 -- 2. krok VH
-- 	AND h.id_druhhodn=171152  -- VH
	AND pp.id=p.id)

ORDER BY "Počet dní po FNaP"



