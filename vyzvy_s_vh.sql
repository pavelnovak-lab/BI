SELECT	"OP PIK",
	p.KODSPECIFCIL,
	p."Registraèní èíslo projektu",
	p.zadatel,
	p."IÈ"
	
FROM isum.v_bi_UmzProjekt p

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND p."Registraèní èíslo projektu" is not null
