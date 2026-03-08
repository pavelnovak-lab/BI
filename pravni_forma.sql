SELECT	v."Èíslo výzvy" ,
	count(p."Registraèní èíslo projektu" ) "Poèet projektù",
	LISTAGG( DISTINCT p.kodwfstav, '; ') "Kód stavù",
	-- count(vs.id) as "Poèet výskytù" ,
 	cis."Název" "Právní forma" 
	-- SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
      	-- DECODE (id_typsubjektu, 300784, '®adatel', 
 	--        			300785, 'Partner') AS "Typ subjektu"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 

INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null 
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vs.id_hosppravforma 


WHERE p."Registraèní èíslo projektu" is not null
AND v."Èíslo výzvy" in ('31_25_157','31_22_008','31_22_010')
-- AND SUBSTR(p.kompetencniutvar, 6) in ('Aplikace','Inovace')
AND vs.id_typsubjektu = 300784 -- OR vs.id_typsubjektu = 300785 
-- AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 
-- GROUP BY cis."Název" , id_typsubjektu, p.kompetencniutvar 
-- AND (cis."Název" = 'Organizaèní slo¾ka státu' OR UPPER(cis."Název"( like '%PØÍSPÌVKOVÁ ORGANIZACE%')
AND p.kodwfstav not like 'PN%'
-- ORDER BY SUBSTR(p.kompetencniutvar, 6), "Typ subjektu", "Poèet výskytù" DESC




GROUP BY v."Èíslo výzvy", cis."Název"

ORDER BY v."Èíslo výzvy" , "Poèet projektù" DESC 
