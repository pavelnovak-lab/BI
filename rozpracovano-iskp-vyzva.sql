SELECT	p."Identifikace žádosti (Hash)",
	p."Registrační číslo projektu",
	p.ZADATEL,
--	p."Unikátní kód stavu",
	p.wfstav as "Unikátní kód stavu",
   	p."Název projektu CZ",
	p.velikostpodniku,
	p.wfstav,
	p.kodwfstav,
	p.WFStavDatum,
	p.KodPrioritniOsa,
	v."Číslo výzvy",
	v."Název výzvy",
	gg."EU" AS "Požadovaná dotace",
	gg."CZV" AS "Celkové způsobilé výdaje",
	decode(gg."CZV",0,0,gg."EU"/gg."CZV") AS "Procento EU"

FROM 		isum.v_bi_umzprojekt p
INNER JOIN	isum.v_bi_umzvyzva v ON p.id_vyzva=v.id
INNER JOIN	isum.v_bi_umzprjgg gg ON gg.id=p.id

WHERE v."Číslo výzvy" in ('01_20_362','01_20_363','01_20_364','01_20_365','01_20_366','01_20_367','01_20_368')

-- p."Registrační číslo projektu" is null
-- AND	p."Unikátní kód stavu"<>'PRJ_PN28a'


-- AND gg.eu > 0
AND p."Registrační číslo projektu" is null


