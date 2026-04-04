SELECT 	bezpartn."Název partnerů",
	bezpartn."IČ partnerů",
	bezpartn."IČ zahraničních partnerů",
	zakl.*	

FROM 

(SELECT p."Registrační číslo projektu",
	p."Název projektu CZ",
        p."KODWFSTAV",
	p."ZADATEL",
	p."IČ",
	pgg.CZV,
	pgg.EU,
	pgg.EU/pgg.CZV AS "Procento EU",
	sum(castky.EuVyuctCelkem) AS "Proplaceno",
	p.id

FROM	isum.v_bi_UmpPlatbaPrj platba 
 inner join	isum.v_bi_UmpCastkySchval castky ON platba.id_SchvaleneCastky=castky.id 
 inner join  	isum.v_bi_UmzProjekt p ON p.id=platba.id_NositelPlatby
 inner join	isum.v_bi_UmzPrjGG pgg ON p.id=pgg.id

WHERE p."Registrační číslo projektu" is not null
AND platba.kodwfstav in ('P10','P11')

GROUP BY p."Registrační číslo projektu", pgg.EU, pgg.CZV, p."Název projektu CZ", p."KODWFSTAV", p."ZADATEL", p."IČ", p.id) zakl

LEFT JOIN

(SELECT		p.id,
		LISTAGG(vs."IČ", '; ' ) AS  "IČ partnerů",
		LISTAGG(vs."IČ zahraniční / REGON", '; ' ) AS  "IČ zahraničních partnerů",
		LISTAGG(DISTINCT vs."Název subjektu", '; ') AS "Název partnerů"

FROM		isum.v_bi_UmzProjekt p 
 inner join	isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id
 inner join	isum.v_bi_UmsCisZakladni cis ON vs.id_typsubjektu=cis.id


WHERE cis."Název" <> 'Žadatel/příjemce'

GROUP BY p.id 

) bezpartn

ON zakl.id=bezpartn.id
