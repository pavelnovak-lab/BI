SELECT	p."Registraèní èíslo projektu",
	p."Název projektu CZ",
	p.zadatel "®adatel",
	p.kompetencniutvar "Kompetenèní útvar",
--	v."Název výzvy",
	pl.CISLOPLATBYZKR "Èíslo ®oP",
	pl.create_uzivatel "®oP vytvoøil",
	pl.stav_workflow,
	pl."Datum zmìny stavu",
	pl."DATUMVYTVORENI" "Datum vytvoøení",
	pl."Èástka CZK clk vyu nezkr I",
	pl."Èástka CZK dot 14f mimo MS I",
	pl.wfstav

FROM 	    isum.v_bi_UmzProjekt p
INNER JOIN  isum.v_bi_UmpPlatba pl ON pl.id_nositelplatby=p.id
-- INNER JOIN  isum.v_bi_UmpPlatba_v14f pl ON pl.id_nositelplatby=p.id
-- INNER JOIN  isum.v_bi_UmzVyzva v ON p.id_vyzva=v.id

WHERE p."Registraèní èíslo projektu" is not null 
-- in ('CZ.01.4.04/0.0/0.0/16_076/0009479','CZ.01.5.125/0.0/0.0/15_020/0005785')
-- AND pl.CISLOPLATBYZKR is not null
-- AND REGEXP_LIKE (pl.CISLOPLATBYZKR,  '/8[0-9][0-9]/')
AND pl."Èástka CZK clk vyu nezkr I" < 0 


ORDER BY pl.CISLOPLATBYZKR



