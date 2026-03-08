SELECT	cis."Název" AS "Právní forma",
	-- cis_2."Název" AS "Kraj realizace",
	p."Registraèní èíslo projektu",
	p.KODWFSTAV,
	p.wfstav ,
	p.ZADATEL,
	REPLACE(p.KodPrioritniOsa,'01.','') AS "Prioriní osa",
	p.prioritniosa ,
	p.kodspecifcil,
	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	p.specifcil,
	p.velikostpodniku,
	p."Datum ukonèení pøedp",
	p."Datum ukonèení skut",
	p."Datum zahájení pøedp",
	p."Datum zahájení skut",
   	p."Název projektu CZ",

        v."Název výzvy",
	v."Èíslo výzvy",
	pggvs."IÈ",
 	pggvs."Poèet zamìstnancù",
	gg."EU" AS "Po¾adovaná dotace",
	gg."CZV" AS "Celkové zpùsobilé výdaje",
	LISTAGG(DISTINCT uk."Název" , '; ') "Kraj realizace"

FROM isum.v_bi_umzprojekt p
INNER JOIN isum.v_bi_umzprjggvs pggvs ON pggvs.id=p.id_zadatel  
INNER JOIN isum.v_bi_umzvyzva v ON p.id_vyzva=v.id
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id
INNER JOIN isum.v_bi_UmsCisZakladni cis ON pggvs.id_HOSPPRAVFORMA=cis.id
INNER JOIN isum.v_bi_UmzPrjUmisteniKraj uk ON uk.id_projekt = p.id AND uk.typ = 'Realizace'

WHERE p."Registraèní èíslo projektu" is not null 
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')

GROUP BY cis."Název",
	p."Registraèní èíslo projektu",
	p.KODWFSTAV,
	p.wfstav ,
	p.ZADATEL,
	p.KodPrioritniOsa,
	p.prioritniosa ,
	p.kodspecifcil,
	p.kompetencniutvar,
	p.specifcil,
	p.velikostpodniku,
	p."Datum ukonèení pøedp",
	p."Datum ukonèení skut",
	p."Datum zahájení pøedp",
	p."Datum zahájení skut",
   	p."Název projektu CZ",

        v."Název výzvy",
	v."Èíslo výzvy",
	pggvs."IÈ",
 	pggvs."Poèet zamìstnancù",
	gg."EU" ,
	gg."CZV" 



ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC 
