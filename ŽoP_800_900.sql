SELECT	p."Registraèní èíslo projektu",
	p."Název projektu CZ",
	p.zadatel "®adatel",
	p.kompetencniutvar "Kompetenèní útvar",
	v."Název výzvy",
	pl.CISLOPLATBYZKR "Èíslo ®oP",
	pl.create_uzivatel "®oP vytvoøil",
	pl.stav_workflow,
	pl."Datum zmìny stavu",
	pl."DATUMVYTVORENI" "Datum vytvoøení",
	pl."Èástka CZK clk vyu nezkr I",
	pl."Èástka CZK dot 14f mimo MS I",
	pl.wfstav

FROM 	    isum.v_bi_UmzProjekt p
INNER JOIN  isum.v_bi_UmpPlatba_v14f pl ON pl.id_nositelplatby=p.id
INNER JOIN  isum.v_bi_UmzVyzva v ON p.id_vyzva=v.id

WHERE p."Registraèní èíslo projektu" is not null
-- 'CZ.01.4.04/0.0/0.0/16_076/0009479'
-- WHERE pl.id = 813850091


