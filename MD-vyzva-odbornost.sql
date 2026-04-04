SELECT distinct  v."Èíslo výzvy",
	v."Název výzvy",
	cs."Název" , 
	kom."Název" as "Program podpory"	

FROM isum.v_bi_UmzVyzva v 
INNER JOIN isum.v_bi_UmzVyzvaMD md ON md.id_vyzva = v.id
INNER JOIN isum.v_bi_UmsCisSeznam cs ON cs.id = md.id_cisseznam
INNER JOIN isum.V_BI_UmzVyzvaUtvar utvar ON utvar.id_vyzva=v.id
INNER JOIN isum.V_BI_UMSHIUtvarKomp kom ON kom.id=utvar.id_utvarkomp 

WHERE cs."Název" = 'Odbornost'

-----------------------


select listagg (co."Název", '; ') as Odbornost,
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
       p."Registraèní èíslo projektu" 
       

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UMVHodnNosOdbornost odb ON odb.id_noshodnoceni = p.id
INNER JOIN isum.V_BI_UMSCisOdbornost co ON co.id = odb.id_odbornost

WHERE p."Registraèní èíslo projektu" is not null

GROUP BY p."Registraèní èíslo projektu", SUBSTR(p.kompetencniutvar, 6 ) 

