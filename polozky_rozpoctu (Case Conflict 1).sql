SELECT  v."Číslo výzvy",
	v."Název výzvy",
	pol."Kód" "Kód položky",
	pol."Název" "Název položky",
	cis."Název"

FROM isum.v_bi_UmzVyzva v 
INNER JOIN isum.v_bi_UmzVyzvaMD md ON md.id_vyzva = v.id
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = md.id_ciszakladni
INNER JOIN isum.v_bi_UmfRozSkupina sk ON sk."Kód" = ci."Kód" AND sk."Název skupiny rozpočtu" = ci."Název" 
INNER JOIN isum.v_bi_UmfRozSkupinaPol pol ON pol.id_predpis = sk.id
LEFT JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = pol.id_verejnapodpora  

WHERE REGEXP_LIKE( v."Číslo výzvy", '3[1-8][0-9]$')
AND   md."Platnost" = 'A'
AND   pol."Platnost" = 'A'
AND   pol."Listová" = 'A'
AND   (pol."Nezpůsobilé výdaje" = 'N' OR pol."Nezpůsobilé výdaje" is null)
AND   cis."Název" <> 'Mimo režim veřejné podpory'
AND   cis."Název" <> 'DE MINIMIS'

ORDER BY v."Číslo výzvy" ASC, pol."Kód" ASC




