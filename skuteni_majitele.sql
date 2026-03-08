SELECT	p."Registraèní èíslo projektu" ,
	p.zadatel ,
	LISTAGG( sz.jmenonazev, '; ') "Jméno statutára" ,
        LISTAGG( sz.adresa, '; ') "Adresa statutára"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel 
INNER JOIN isum.v_bi_UMSRSStatutZast sz ON sz.id_subjekt = vs.id

WHERE p."Registraèní èíslo projektu" = ('CZ.31.4.0/0.0/0.0/23_069/0007713','CZ.31.2.0/0.0/0.0/22_014/0002837')

GROUP BY p."Registraèní èíslo projektu",
      	 p.zadatel 
----------------------------------------
SELECT (p.kompetencniutvar) AS "Kompoonetna NPO, prioritní osa",
       p."Registraèní èíslo projektu" ,
       p.kodwfstav ,
       ci."Název" "Typ subjektu",
       vs."IÈ",
       vs.JMENOANAZEV,
       vs."IÈ zahranièní / REGON",
       vs."DATUMNAROZENI#Datum narození",
       esm.*
       

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null -- AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel 
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = vs.id_typsubjektu
INNER JOIN isum.v_bi_UMZPrjGGVSESM sm ON sm.id_prjggvs = vs.id 

-- WHERE p."Registraèní èíslo projektu" = 'CZ.31.2.0/0.0/0.0/22_014/0002837'

ORDER BY p.kompetencniutvar
