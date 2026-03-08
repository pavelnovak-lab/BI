SELECT 	bezpartn."Název partnerù",
	bezpartn."IÈ partnerù",
	bezpartn."IÈ zahranièních partnerù",
	bezpartn."Název" AS "Právní forma",
	zakl.*	
FROM 

(SELECT p."Registraèní èíslo projektu",
	p."Název projektu CZ",
        p."KODWFSTAV",
	p."ZADATEL",
	p."IÈ",
	p.id_zadatel,
	pgg.CZV,
	pgg.EU,
	pgg.EU/pgg.CZV AS "Procento EU",
	sum(castky.EuVyuctCelkem) AS "Proplaceno",
	p.id

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpCastkySchval castky ON platba.id_SchvaleneCastky=castky.id 
INNER JOIN isum.v_bi_UmzPrjGG pgg ON p.id=pgg.id

WHERE p."Registraèní èíslo projektu" is not null
AND platba.kodwfstav in ('P10','P11')
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND p."Registraèní èíslo projektu" = 'CZ.01.3.10/0.0/0.0/15_010/0000962'


GROUP BY p."Registraèní èíslo projektu", pgg.EU, pgg.CZV, p."Název projektu CZ", p."KODWFSTAV", p."ZADATEL", p.id_zadatel, p."IÈ", p.id) zakl

LEFT JOIN

(SELECT vs.id_prjgg,
	max(case when vs.id_typsubjektu = 300784 then ci."Název" end) AS "Název",
	LISTAGG((case when vs.id_typsubjektu <> 300784 then vs."IÈ" end), '; ') AS  "IÈ partnerù",
	LISTAGG((case when vs.id_typsubjektu <> 300784 then vs."IÈ zahranièní / REGON" end), '; ' )  AS  "IÈ zahranièních partnerù",
	LISTAGG(DISTINCT(case when vs.id_typsubjektu <> 300784 then vs."Název subjektu"end), '; ')  AS "Název partnerù"

FROM isum.v_bi_UmzPrjGGvs vs 
LEFT JOIN isum.v_bi_UmsCisZakladni cis ON vs.id_typsubjektu = cis.id AND vs.id_typsubjektu <> 300784 -- ¾adatel
LEFT JOIN isum.v_bi_UmsCisZakladni ci ON vs.id_hosppravforma = ci.id AND vs.id_typsubjektu = 300784 -- ¾adatel

WHERE vs.id_prjgg = 4436000

GROUP BY vs.id_prjgg

) bezpartn

ON zakl.id=bezpartn.id_prjgg

