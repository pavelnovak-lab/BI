SELECT 	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
	p."Registraèní èíslo projektu",
        p.kodwfstav Stav_prj,
	p.zadatel ,
	p."IÈ",
	p."Název projektu CZ",

	gg.eu,
	gg.czv,
	
	hist.VLASTNIK vlastnik_hist,
	hist.CTENARHODN ctenar_hist,
	hist.editor editor_hist,
 	hist.signatar signatar_hist,
	hist.zastupce zastupce_spravce_hist,
	uu.uzivatel AS uzivatel_hist,
	hist.platido ,
	hist.platiod
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
INNER JOIN isum.v_bi_UMZSdileniHistorie hist ON hist.id_nositelsdil = p.id
INNER JOIN isum.v_bi_CUzivatel uu ON uu.id = hist.id_uzivatel

WHERE p."Registraèní èíslo projektu" is not null
AND uu.username in ('SDSMETER')

