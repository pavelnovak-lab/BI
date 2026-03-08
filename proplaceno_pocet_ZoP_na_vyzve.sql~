SELECT  p."Registraèní èíslo projektu",
	p.kodwfstav,
	p.zadatel,
--	platba.VYUCTSKUT ,
	p."Poèet ZoU",
	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
	etapy.e "Poèet ®oP",
	hs.datumod "Datum PP41"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND hs.stavdo = 'PP41'

INNER JOIN
(SELECT max(platba."PORADI#Poøadí finanèního plánu") e,
	platba.id_NositelPlatby
FROM isum.v_bi_UmpPlatbaPrj platba
-- AND platba.id_NositelPlatby = 51243423
GROUP BY platba.id_NositelPlatby) etapy ON etapy.id_NositelPlatby = p.id





WHERE p.kodwfstav in ('PP41','PP42','PP43')
-- AND p."Registraèní èíslo projektu" = 'CZ.01.2.06/0.0/0.0/15_038/0006525'
-- AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/16_045/0010626'
AND platba.souctovyradek = 'A'
AND platba.vyuctskut = 0





