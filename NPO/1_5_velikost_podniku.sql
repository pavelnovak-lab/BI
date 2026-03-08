SELECT  v."Název výzvy" ,
	p."Registrační číslo projektu" ,
	p.kodwfstav, 
	p.zadatel "Příjemce",
	vs."IČ",
	vs."Počet zaměstnanců" "Počet zaměstnanců příjemce",
	vp."Název" "Velikost podniku příjemce",
	
	pzf."Celkové způsobilé výdaje" "CZV",
	pzf.PROC_EU "% podpory"
	
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel 
LEFT JOIN isum.v_bi_UmsCisZakladni vp ON vp.id = vs.id_velikostpodniku


WHERE p."Registrační číslo projektu" is not null
AND v."Číslo výzvy" in ('31_22_014', '31_22_015')
AND p.kodwfstav not like 'PN%'

ORDER BY v."Číslo výzvy" , substr(p."Registrační číslo projektu",-5,5) ASC 
