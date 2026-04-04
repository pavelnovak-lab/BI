SELECT DISTINCT 
       p."Registrační číslo projektu",
       p."Název projektu CZ" ,
       p.zadatel ,
       p.kodwfstav,
       p."IČ" "IČ žadatele",
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       s."Název Dodavatele",
       s."IČO Dodavatele",
       sum(s.VYDAJEPROKAZ) "Prokazované výdaje",
       sum(s.VYDAJESCHVAL) "Schválené výdaje" 
       -- vs.id_typsubjektu,
       -- vs."IČ",
       -- vs.jmenoanazev


FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.V_BI_UMFSOUPISKADOKLADPRJ s ON s.id_projekt = p.id
-- LEFT JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND (vs.id_typsubjektu = (300786) ) AND vs."IČ" IN ('28819896','28810911') 

WHERE p."Registrační číslo projektu" is not null 
-- AND s."IČO Dodavatele" is not null 
AND (s."IČO Dodavatele" IN ('28819896','28810911') or p."IČ" IN ('28819896','28810911') )
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND s."Součtový řádek" is null

GROUP BY p."Registrační číslo projektu",
      p."Název projektu CZ",
       p.zadatel ,
       p."IČ" ,
       s."Název Dodavatele",
       s."IČO Dodavatele" ,
       -- vs.id_typsubjektu,
       -- vs."IČ",
       -- vs.jmenoanazev ,
       p.kodwfstav,
       SUBSTR(p.kompetencniutvar, 6)

ORDER BY SUBSTR(p.kompetencniutvar, 6),substr(p."Registrační číslo projektu",-5,5) ASC 


----------------------------------------

SELECT DISTINCT  s."Název Dodavatele",
       s."IČO Dodavatele"

FROM isum.V_BI_UMFSOUPISKADOKLADPRJ s

WHERE s.id_projekt = 737195651
