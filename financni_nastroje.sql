SELECT 	fn."Registraèní èíslo fondu fondù",
	fn."Název fondu fondù",
	kp."Jméno nebo Název",
	typ."Název" AS "Typ koneèného pøíjemce",
	kp."Identifikaèní údaj smlouvy",
	kp."Datum podpisu smlouvy",
	datspl."Datum pøedp splacení úvìru",
	datselh."Datum selhání úvìru",
	datspl."Datum splacení úvìru",
	vysuv."Sjednaná vý¹e úvìru"
	-- rzfin.,
	-- rzfin."Celková èástka pro odmìny",

	-- nazev."Název" AS "Výbìr typu"
	
FROM 		isum.v_bi_UMPFinNastroj fn 
INNER JOIN	isum.v_bi_UMPFNPrehledKP kp ON kp.id_finnastroj=fn.id
INNER JOIN	isum.v_bi_UmsCisZakladni typ ON typ.id=kp.id_typprijemce
INNER JOIN
(SELECT		rzfin."Datum" AS "Datum pøedp splacení úvìru",
		rzfin.ID_PREHLEDKP
 FROM		isum.V_BI_UmpFNRozpisFin rzfin 
 INNER JOIN 	isum.v_BI_UmsCISZakladni nazev ON nazev.id=rzfin.id_typ
 WHERE nazev."Kód" = 'PKP0401' /* Datum pøedpokládaného splacení úvìru */) datspl ON datspl.ID_PREHLEDKP=kp.id
INNER JOIN 
(SELECT		rzfin."Celkové zpùsobilé výdaje" AS "Datum selhání úvìru",
		rzfin.ID_PREHLEDKP
 FROM		isum.V_BI_UmpFNRozpisFin rzfin 
 INNER JOIN 	isum.v_BI_UmsCISZakladni nazev ON nazev.id=rzfin.id_typ
 WHERE nazev."Název" = 'Datum selhání úvìru' /* Datum selhání úvìru */) datselh ON datselh.ID_PREHLEDKP=kp.id
INNER JOIN 
(SELECT		rzfin."Celkové zpùsobilé výdaje" AS "Datum splacení úvìru",
		rzfin.ID_PREHLEDKP
 FROM		isum.V_BI_UmpFNRozpisFin rzfin 
 INNER JOIN 	isum.v_BI_UmsCISZakladni nazev ON nazev.id=rzfin.id_typ
 WHERE nazev."Název" = 'Datum splacení úvìru' /* Datum splacení úvìru */) datspl ON datspl.ID_PREHLEDKP=kp.id
INNER JOIN 
(SELECT		rzfin."Celkové zpùsobilé výdaje" AS "Sjednaná vý¹e úvìru",
		rzfin.ID_PREHLEDKP
 FROM		isum.V_BI_UmpFNRozpisFin rzfin 
 INNER JOIN 	isum.v_BI_UmsCISZakladni nazev ON nazev.id=rzfin.id_typ
 WHERE nazev."Název" = 'Datum splacení úvìru' /* Sjednaná vý¹e úvìru */) vysuv ON vysuv.ID_PREHLEDKP=kp.id


WHERE fn."Registraèní èíslo fondu fondù" = 'FN_2017_001'
-- in ('FN_2018_005','FN_2017_001','FN_2017_002')

AND kp."Identifikaèní údaj smlouvy" = '2017-1460-E2'

-- SELECT * FROM isum.v_bi_umpfnrozpisfin 
-- ORDER BY fn."Kód", kp."Jméno nebo Název", nazev."Název"
