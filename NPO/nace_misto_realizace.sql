SELECT	p.kompetencniutvar,
	p."Registrační číslo projektu" ,
	v."Číslo výzvy" ,
	v."Název výzvy",
	p."Název projektu CZ",
	p.zadatel,
	p.wfstav,
	p.kodWFStav,
	LISTAGG(DISTINCT ci."Název", '; ' on overflow truncate) AS "Název CZ NACE",
	LISTAGG(DISTINCT ci."Kód", '; ' on overflow truncate) AS "Kód CZ NACE" ,
        LISTAGG(DISTINCT uk."Název", '; ')  "Kraj realizace", 
        LISTAGG(DISTINCT ciu."Název",';') WITHIN GROUP (ORDER BY ciu."Název") AS "Obec"

FROM isum.v_bi_umzprojekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
LEFT JOIN isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel
LEFT JOIN isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
LEFT JOIN isum.v_bi_UmzPrjUmisteniKraj uk ON uk.id_projekt = p.id AND uk.typ = 'Realizace'
LEFT JOIN Isum.v_bi_UMZPrjUmisteni um ON um.id_projekt = p.id AND um.Typ = 1 -- místo realizace
LEFT JOIN isum.v_bi_UmsCisZakladni ciu ON um.id_uzemnijednotky = ciu.id

WHERE p."Registrační číslo projektu" is not null 
AND   p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.4','31.5','31.9','31.14','31.22') 
AND   n."Je součástí projektu?" = 'A'
-- AND   p."Registrační číslo projektu" = 'CZ.31.1.0/0.0/0.0/22_011/0002588'

GROUP BY p.kompetencniutvar ,
	v."Číslo výzvy" ,
	v."Název výzvy",
        p."Registrační číslo projektu" ,
	p.zadatel,
	p."Název projektu CZ",
	p.wfstav,
	p.kodWFStav

ORDER BY p.kompetencniutvar, v."Číslo výzvy", substr(p."Registrační číslo projektu",-5,5) ASC 
