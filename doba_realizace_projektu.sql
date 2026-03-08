SELECT  substr(p.KodPrioritniOsa, 4) "PO",
	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	count(p.id) "Poèet projektù",
	avg(p."Datum ukonèení skut" - nvl(p."Datum zahájení skut", p."Datum zahájení pøedp")) "Prùmìr skuteèné doby realizace"
	
FROM isum.v_bi_UmzProjekt p

WHERE p."Datum ukonèení skut" is not null
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
-- AND p."Registraèní èíslo projektu" in ('CZ.01.2.07/0.0/0.0/15_004/0000972','CZ.01.1.02/0.0/0.0/15_014/0000194','CZ.01.1.02/0.0/0.0/15_002/0000260')
-- AND SUBSTR(p.kompetencniutvar, 6) = 'Vysokorychlostní internet'

GROUP BY SUBSTR(p.kompetencniutvar, 6), substr(p.KodPrioritniOsa, 4)

ORDER BY substr(p.KodPrioritniOsa, 4), SUBSTR(p.kompetencniutvar, 6)
