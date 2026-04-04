SELECT	p."Registrační číslo projektu",
	p."Název projektu CZ",
	p.zadatel,
	pl."Proplaceno",
	cis."Kód" AS "Kód intervence",
	gg.eu,
	gg.czv,
	LISTAGG(DISTINCT adr.psc,'; ') WITHIN GROUP (ORDER BY adr.psc) AS "PSČ", 
	LISTAGG(DISTINCT SUBSTR( ci."Kód", 1,2),'; ') AS "Kód CZ NACE"
	-- LISTAGG ( ci."Kód",'; ' on overflow truncate) AS "Kód CZ NACE" 
--	ki.*

FROM		isum.v_bi_UmzProjekt p			
LEFT JOIN 
(SELECT		platba.id_NositelPlatby,
		sum(castky.EuVyuctCelkem) AS "Proplaceno"
 FROM 		isum.v_bi_UmpPlatbaPrj platba 
 INNER JOIN  	isum.v_bi_UmpCastkySchval castky ON platba.id_SchvaleneCastky=castky.id 
 WHERE platba.kodwfstav  in ('P10','P11')
 AND   platba.DatumCertifikace is not null       
 -- AND   p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42') 
 -- AND   p.id_kompetence  =  6542521 /* 0116 Úspory energie */
 GROUP BY platba.id_NositelPlatby) pl ON pl.id_NositelPlatby = p.id

INNER JOIN	isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel
INNER JOIN 	isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
INNER JOIN 	isum.v_bi_UmsRsVerzeAdresy adr on p.id_zadatel=adr.id_verzesubjektu
INNER JOIN	isum.v_bi_UmzPrjKI ki ON ki.id_projekt=p.id AND ki."Typ kategorie intervencí" = 0
INNER JOIN	isum.v_bi_UmsCisZakladni cis ON ki.id_ki=cis.id 
INNER JOIN	isum.v_bi_umzprjgg gg ON gg.id=p.id 

WHERE	p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42') 
AND	p.id_kompetence  =  6542521 /* 0116 Úspory energie */
-- AND	cis."Kód" in ('IV.2.068','IV.2.066')
-- AND 	p."Registrační číslo projektu" in ('CZ.01.3.10/0.0/0.0/15_010/0000107','CZ.01.3.10/0.0/0.0/15_010/0000029')
-- and p."Registrační číslo projektu" = 'CZ.01.3.10/0.0/0.0/15_010/0000107'

GROUP BY p."Registrační číslo projektu",
 	p."Název projektu CZ",
 	p.zadatel,
	pl."Proplaceno",
 	cis."Kód" ,
 	gg.eu,
 	gg.czv



