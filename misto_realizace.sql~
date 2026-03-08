SELECT	p."Registraèní èíslo projektu",
	p."Název projektu CZ",
	p.zadatel,
	pl."Proplaceno",
	cis."Kód" AS "Kód intervence",
	gg.eu,
	gg.czv,
	LISTAGG(DISTINCT ciu."Název",';') WITHIN GROUP (ORDER BY ciu."Název") AS "Obec",
--	LISTAGG(DISTINCT adr.psc,'; ') WITHIN GROUP (ORDER BY adr.psc) AS "PSÈ",    
	LISTAGG(DISTINCT SUBSTR( ci."Kód", 1,2),'; ') AS "Kód CZ NACE"
	-- LISTAGG ( ci."Kód",'; ' on overflow truncate) AS "Kód CZ NACE" 


FROM		isum.v_bi_UmzProjekt p			
LEFT JOIN 
(SELECT		platba.id_NositelPlatby,
		sum(castky.EuVyuctCelkem) AS "Proplaceno"
 FROM 		isum.v_bi_UmpPlatbaPrj platba 
 INNER JOIN  	isum.v_bi_UmpCastkySchval castky ON platba.id_SchvaleneCastky=castky.id 
 WHERE platba.kodwfstav  in ('P10','P11')
 AND   platba.DatumCertifikace is not null       
 GROUP BY platba.id_NositelPlatby) pl ON pl.id_NositelPlatby = p.id

INNER JOIN	isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel
INNER JOIN 	isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
-- INNER JOIN 	isum.v_bi_UmsRsVerzeAdresy adr on p.id_zadatel=adr.id_verzesubjektu
LEFT JOIN isum.v_bi_UmzPrjUmisteni um ON um.id_projekt = p.id
INNER JOIN isum.v_bi_UmsCisZakladni ciu ON um.id_uzemnijednotky = ciu.id
-- INNER JOIN isum.v_bi_UmsRsVerzeAdresy adr on p.id_zadatel=adr.id_verzesubjektu


INNER JOIN	isum.v_bi_UmzPrjKI ki ON ki.id_projekt=p.id AND ki."Typ kategorie intervencí" = 0
INNER JOIN	isum.v_bi_UmsCisZakladni cis ON ki.id_ki=cis.id 
INNER JOIN	isum.v_bi_umzprjgg gg ON gg.id=p.id 

WHERE p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42') 
AND   um.Typ = 1
AND   REGEXP_LIKE( ciu."Kód", '5[0-9]{5}' )
AND   p.id_kompetence  =  6542521 /* 0116 Úspory energie */

GROUP BY p."Registraèní èíslo projektu",
 	p."Název projektu CZ",
 	p.zadatel,
	pl."Proplaceno",
 	cis."Kód" ,
 	gg.eu,
 	gg.czv






-- SELECT	p."Registraèní èíslo projektu",


-- FROM isum.v_bi_UmzProjekt p			
-- LEFT JOIN isum.v_bi_UmzPrjUmisteni um ON um.id_projekt = p.id
-- INNER JOIN isum.v_bi_UmsCisZakladni ci ON um.id_uzemnijednotky = ci.id
-- -- INNER JOIN isum.v_bi_UmsRsVerzeAdresy adr on p.id_zadatel=adr.id_verzesubjektu

-- WHERE um.Typ = 1
-- AND   REGEXP_LIKE( ci."Kód", '5[0-9]{5}' )
-- AND   p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42') 
-- AND   p.id_kompetence  =  6542521 /* 0116 Úspory energie */

-- -- AND EXISTS  
-- -- (SELECT		pp.id
-- -- FROM		isum.v_bi_UmzProjekt pp			
-- -- INNER JOIN 	isum.v_bi_UmsRsVerzeAdresy adr on p.id_zadatel=adr.id_verzesubjektu
-- -- WHERE REGEXP_LIKE( adr.psc, '1[0-9]{4}' )
-- -- AND pp.id = p.id)

-- -- AND NOT EXISTS  
-- -- (SELECT	    pp.id
-- -- FROM		isum.v_bi_UmzProjekt pp			
-- -- INNER JOIN 	isum.v_bi_UmsRsVerzeAdresy adr on p.id_zadatel=adr.id_verzesubjektu
-- -- WHERE REGEXP_LIKE( adr.psc, '[2-9][0-9]{4}' )
-- -- AND pp.id = p.id)

-- GROUP BY p."Registraèní èíslo projektu"




