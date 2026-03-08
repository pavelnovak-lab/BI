SELECT	p."Registraèní èíslo projektu",
	-- pl."Proplaceno",
	-- cis."Kód" AS "Kód intervence",
	-- gg.eu,
	-- gg.czv,
	LISTAGG(DISTINCT ciu."Název",';') WITHIN GROUP (ORDER BY ciu."Název") AS "Obec"
--	LISTAGG(DISTINCT adr.psc,'; ') WITHIN GROUP (ORDER BY adr.psc) AS "PSÈ",    
	-- LISTAGG(DISTINCT SUBSTR( ci."Kód", 1,2),'; ') AS "Kód CZ NACE"
	-- LISTAGG ( ci."Kód",'; ' on overflow truncate) AS "Kód CZ NACE" 


FROM isum.v_bi_umzprjgg p			
INNER JOIN isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel
LEFT JOIN  isum.v_bi_UmzPrjUmisteni um ON um.id_projekt = p.id
INNER JOIN isum.v_bi_UmsCisZakladni ciu ON um.id_uzemnijednotky = ciu.id

WHERE um.Typ = 1
AND   p.kodwfstav in ('PP41','PP42','PP43','PN40a','PN40b') 
-- AND   REGEXP_LIKE( ciu."Kód", '5[0-9]{5}' )
-- AND   p.id_kompetence  =  6542521 /* 0116 Úspory energie */

GROUP BY p."Registraèní èíslo projektu"
