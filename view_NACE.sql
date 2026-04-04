SELECT 	LISTAGG(DISTINCT c."Název", '; ' on overflow truncate) AS "Název CZ NACE",
	LISTAGG(DISTINCT c."Kód", '; ' on overflow truncate) AS "Kód CZ NACE" ,
	n.id_subjekt

FROM isum.v_bi_umsrscznace n -- ON n.id_subjekt=p.id_zadatel 
LEFT JOIN isum.v_bi_umsciszakladni c ON c.id=n.id_cznace

WHERE n."Je součástí projektu?" = 'A'

GROUP BY n.id_subjekt
