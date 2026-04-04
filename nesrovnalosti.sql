SELECT 	bezpartn."Název partnerů",
	bezpartn."IČ partnerů",
	bezpartn."IČ zahraničních partnerů",
	zakl.*	

FROM 

(SELECT pgg."Registrační číslo projektu",
	pgg."Název projektu CZ",
        pgg."KODWFSTAV",
	vs."Název subjektu" AS "ZADATEL",
	vs."IČ",
--	pgg.id_zadatel,
	pgg.CZV,
	pgg.EU,
	pgg.EU/pgg.CZV AS "Procento EU",
 	ci."Název" AS "Právní forma",
	pgg.id

 FROM   	isum.v_bi_UmzPrjGG pgg
 INNER JOIN	isum.v_bi_UmzPrjGGvs vs ON vs.id=pgg.id_zadatel 
 INNER JOIN 	isum.v_bi_UmsCisZakladni ci ON vs.id_hosppravforma = ci.id
 
WHERE pgg."Registrační číslo projektu" is not null ) zakl



INNER JOIN 

(SELECT		p.id, 
 		LISTAGG(vs."IČ", '; ' ) AS  "IČ partnerů",
		LISTAGG(vs."IČ zahraniční / REGON", '; ' ) AS  "IČ zahraničních partnerů",
		LISTAGG(DISTINCT vs."Název subjektu", '; ') AS "Název partnerů",
 		sum(castky.EuVyuctCelkem) AS "Proplaceno"
 FROM		isum.v_bi_UmzProjekt p 
 INNER JOIN	isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id
 INNER JOIN 	isum.v_bi_UmsCisZakladni cis ON vs.id_typsubjektu=cis.id AND (cis."Název" <> 'Žadatel/příjemce')
 INNER JOIN 	isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
 INNER JOIN	isum.v_bi_UmpCastkySchval castky ON platba.id_SchvaleneCastky=castky.id 

 WHERE p."Registrační číslo projektu" is not null 
 AND platba.kodwfstav in ('P10','P11')	

 GROUP BY p.id ) bezpartn

ON zakl.id=bezpartn.id


-- SELECT vs.*
-- FROM 	isum.v_bi_UmzProjGG p
-- INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg = p.id
-- -- INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
-- WHERE p.id = 1616687
