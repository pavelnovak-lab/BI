SELECT	p."Registrační číslo projektu",
	pr.zadatel,
	p."Název projektu CZ",
	p.kodwfstav,
	p.eu AS "Požadovaná dotace",
	naceprj."Název projektového CZ NACE",
	naceprj."Kód projektového CZ NACE",
	nepodp."Název nepodporovaný CZ NACE" ,
	nepodp."Kód nepodporovaný CZ NACE" ,
	LISTAGG(ci."Název",'; ' on overflow truncate) AS "Název CZ NACE", ,
	LISTAGG(ci."Kód",'; ' on overflow truncate) AS "Kód CZ NACE"


FROM isum.v_bi_umzprjgg p
INNER JOIN isum.v_bi_umzprojekt pr ON pr.id=p.id
INNER JOIN isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel
INNER JOIN isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
INNER JOIN (SELECT n.id_subjekt ,
 LISTAGG(ci."Název",'; ' on overflow truncate) AS "Název projektového CZ NACE",
 LISTAGG(ci."Kód",'; ' on overflow truncate) AS "Kód projektového CZ NACE"
FROM isum.v_bi_umsrscznace n
INNER JOIN isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
WHERE n."Je součástí projektu?" = 'A'
GROUP BY n.id_subjekt) naceprj ON naceprj.id_subjekt=p.id_zadatel

INNER JOIN (SELECT n.id_subjekt ,
 LISTAGG(ci."Název",'; ' on overflow truncate) AS "Název nepodporovaný CZ NACE",
 LISTAGG(ci."Kód",'; ' on overflow truncate) AS "Kód nepodporovaný CZ NACE"
FROM isum.v_bi_umsrscznace n
INNER JOIN isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
WHERE n."Je součástí projektu?" = 'A'
AND (ci."Kód" like '01%'
OR ci."Kód" like '02%'
OR ci."Kód" like '03%'
OR ci."Kód" like '05%'
OR ci."Kód" like '06%'
OR ci."Kód" like '07%'
OR ci."Kód" like '08%'
OR ci."Kód" like '09%'
OR ci."Kód" like '12%'
OR ci."Kód" like '55%'
OR ci."Kód" like '56%'
OR ci."Kód" like '64%'
OR ci."Kód" like '65%'
OR ci."Kód" like '66%'
OR ci."Kód" like '68%'
OR ci."Kód" like '69%'
OR ci."Kód" like '70%'
OR ci."Kód" like '77.1%'
OR ci."Kód" like '79%'
OR ci."Kód" like '84%'
OR ci."Kód" like '90%'
OR ci."Kód" like '91%'
OR ci."Kód" like '92%'
OR ci."Kód" like '93%'
OR ci."Kód" like '94%'
OR ci."Kód" like '96.04%'
OR ci."Kód" like '96.09%'
OR ci."Kód" like '97%'
OR ci."Kód" like '98%')

GROUP BY n.id_subjekt) nepodp ON nepodp.id_subjekt=p.id_zadatel





WHERE 	p."Registrační číslo projektu" is not null
AND p.id_vyzva = 575818983
AND p.kodwfstav like 'PP%'
-- AND 	n."Je součástí projektu?" = 'A'

GROUP BY p."Registrační číslo projektu",
	pr.zadatel,
	p."Název projektu CZ",
	p.kodwfstav,
	p.kodWFStav,
	naceprj."Název projektového CZ NACE",
	naceprj."Kód projektového CZ NACE",
	nepodp."Název nepodporovaný CZ NACE" ,
	nepodp."Kód nepodporovaný CZ NACE" ,
	p.eu


ORDER BY nepodp."Kód nepodporovaný CZ NACE"  DESC
