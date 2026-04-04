SELECT	p."Registrační číslo projektu",
	pr.zadatel,
	pr."IČ",
	p."Název projektu CZ",
	p.wfstav,
	p.kodWFStav,
	p.CZV,
	p.eu AS "Požadovaná dotace",
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

WHERE 	p."Registrační číslo projektu" is not null
AND 	kom."Název"<>'Operační program Podnikání a inovace pro konkurenceschopnost'
AND 	ci."Kód" like ('13%')
AND 	ci."Kód" not like ('31%')
AND 	ci."Kód" not like ('32.2%')
AND 	ci."Kód" not like ('43.32%')
AND	p.kodWFstav like ('PP%')
AND 	n."Je součástí projektu?" = 'A'

GROUP BY pr."IČ",
	p."Registrační číslo projektu",
	pr.zadatel,
	p."Název projektu CZ",
	p.wfstav,
	p.kodWFStav,
	p.CZV,
	p.eu,
	kom."Název"
