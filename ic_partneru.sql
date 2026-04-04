SELECT		p."Registrační číslo projektu",

		-- LISTAGG(vs."IČ", '; ' ) AS  "IČ partnerů",
--		count(vs.id) as "Počet partnerů"

		-- LISTAGG(DISTINCT vs."Název subjektu", '; ') AS "Název partnerů"
--		SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" 
		-- v."Název výzvy" ,
		count(vs.id) as "Počet partnerů", 
		-- cis."Název" ,
		kom."Název"
		
FROM		isum.v_bi_UmzPrjGGII p 
INNER JOIN	isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id
INNER JOIN 	isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
-- INNER JOIN	isum.v_bi_UmsCisZakladni cis ON vs.id_typsubjektu=cis.id
INNER JOIN isum.V_BI_UmzVyzvaUtvar utvar ON utvar.id_vyzva=v.id
INNER JOIN isum.V_BI_UMSHIUtvarKomp kom ON kom.id=utvar.id_utvarkomp 

WHERE
vs.id_typsubjektu = 300785
-- cis."Název" like 'Partner%' 
-- vs."IČ" = '68081766' 
-- AND p."Registrační číslo projektu" = 'CZ.01.1.02/0.0/0.0/17_107/0012450'
AND p."Registrační číslo projektu" is not null
AND kom."Název" <> 'Operační program Podnikání a inovace pro konkurenceschopnost' 


HAVING count(vs.id) > 1

GROUP BY p."Registrační číslo projektu", kom."Název"


