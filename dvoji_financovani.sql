SELECT 	vs.jmenoanazev,
	p.zadatel, p."IÈ" AS "IÈ projektu",
	vs."RÈ",
	vs."IÈ",
	ci."Název" "Typ subjektu",
	p."Registraèní èíslo projektu" 
	 
FROM isum.v_bi_UmzProjekt p  
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id  
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = vs.ID_TYPSUBJEKTU


WHERE -- p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
-- AND
p."Registraèní èíslo projektu" is not null 
-- p."Registraèní èíslo projektu" = 'CZ.01.3.10/0.0/0.0/18_183/0015524'
AND ci."Název" like '%ma%'
