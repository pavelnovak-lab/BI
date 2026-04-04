SELECT p."Registrační číslo projektu",
       vs.id_velikostpodniku ,
       ci."Název" ,
       cis."Název" as pravni_forma ,
       p."IČ",
       -- SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
       -- p.kodwfstav,
       vs."Počet zaměstnanců"
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.id_typsubjektu = 300784 -- zadatel
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  vs.id_velikostpodniku
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id =  id_HospPravForma


WHERE p."Registrační číslo projektu" is not null 
AND (p.kodwfstav like ('PP%') or p.kodwfstav in ('V2','V5','Z1','Z2'))
AND vs.id_velikostpodniku in (0,181925135)
AND vs."Počet zaměstnanců" is null

-- GROUP BY vs.id_velikostpodniku, ci."Název" , vs."Počet zaměstnanců", cis."Název" 
