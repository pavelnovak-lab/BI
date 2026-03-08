SELECT	count(p.id),
       	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
	v."Název výzvy" ,
	v."Èíslo výzvy" 

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN
(SELECT v."Název výzvy",
       v."Èíslo výzvy",
       v.id
FROM isum.v_bi_UmzVyzva v

MINUS 

SELECT	v."Název výzvy",
	v."Èíslo výzvy",
	v.id
	-- ci."Název",
	-- ci.id

FROM isum.v_bi_UmzVyzva v 
INNER JOIN  isum.v_bi_UMFPomeryHlavicka ph ON v.id=ph.id_nositelpompf
INNER JOIN isum.v_bi_UMSCisMiryVP cis ON cis.id = ph.id_verejnapodpora
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = cis.id_rezimpodpory

WHERE
-- ph.id in (1127589496, 179463381, )
-- v."Èíslo výzvy" = '01_19_255'
-- AND
EXISTS
(SELECT 1
 FROM isum.v_bi_UmsCisZakladni cz
 WHERE cz.id = 1196332
 AND ci.id = cz.id)
) bezgber ON bezgber.id = v.id


WHERE p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PN40a','PN40b') 
AND gg.czv < 5200000 

GROUP BY v."Název výzvy", v."Èíslo výzvy" , substr(p.kompetencniutvar, 6)


