SELECT	p."Registraèní èíslo projektu",
	pr.zadatel,
	pr."IÈ",
	p."Název projektu CZ",
	p.wfstav,
	p.kodWFStav,
	p.CZV,
	p.eu AS "Po¾adovaná dotace",
	LISTAGG(DISTINCT ci."Název",'; ' on overflow truncate) AS "Název CZ NACE",
	LISTAGG(ci."Kód",'; ' on overflow truncate) AS "Kód CZ NACE",
	kom."Název" AS "Program podpory"

FROM 		isum.v_bi_umzprjgg p
INNER JOIN	isum.v_bi_umzprojekt pr ON pr.id=p.id
INNER JOIN 	isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN	isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel
INNER JOIN 	isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
INNER JOIN 	isum.V_BI_UMZVYZVAUTVAR	utvar ON utvar.id_vyzva=v.id
INNER JOIN 	isum.V_BI_UMSHIUtvarKomp kom ON kom.id=utvar.id_utvarkomp

WHERE 	p."Registraèní èíslo projektu" like ('CZ.31.%')
AND 	kom."Název"<>'Operaèní program Podnikání a inovace pro konkurenceschopnost'
AND 	(ci."Kód" like (24.4%) OR ci."Kód" like (24.5%)) 
AND	p.kodWFstav like ('PP%')
-- AND 	n."Je souèástí projektu?" = 'A'

GROUP BY pr."IÈ",
	p."Registraèní èíslo projektu",
	pr.zadatel,
	p."Název projektu CZ",
	p.wfstav,
	p.kodWFStav,
	p.CZV,
	p.eu,
	kom."Název"
