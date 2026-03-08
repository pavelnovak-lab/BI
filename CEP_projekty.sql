SELECT	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	p."Registraèní èíslo projektu" ,
       p."Název projektu CZ" ,
       p.zadatel ,
       -- platba."Èíslo ¾ádosti o platbu" 
       platba.*
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UMFSmlouva sml ON sml.id_nositelsml = p.id
INNER JOIN isum.v_bi_UMSPrilohyPA pril ON pril.id_nositelpril = sml.id


WHERE v."Èíslo výzvy" IN ('01_17_106','01_17_107','01_17_175','01_17_176','01_19_262','01_20_321')
AND p.KodPrioritniOsa in ('01.1', '01.2')
AND p."Registraèní èíslo projektu" IN ('CZ.01.1.02/0.0/0.0/17_106/0012285')



--------------------------------------------

SELECT sml.id_nositelsml,
       pril.NAZEVPRIL,
       pril."Link DMS"
       
FROM isum.v_bi_UMFSmlouva sml
INNER JOIN isum.v_bi_UMSPrilohyPA pril ON pril.id_nositelpril = sml.id

WHERE upper(pril.NAZEVPRIL) like upper('%Rozpoèet%')
AND sml."Poøadí" = 1

--------------------------------------------
SELECT count(vs.id),
       vs.id_prjgg 
FROM isum.v_bi_UmzPrjGGvs vs -- ON p.id = vs.id_prjgg 

WHERE vs.id_typsubjektu = 300785 -- partner
AND vs.neplatny is null

GROUP BY vs.id_typsubjektu



