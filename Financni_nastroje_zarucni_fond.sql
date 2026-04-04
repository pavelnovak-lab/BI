SELECT 	fn."Registrační číslo fondu fondů",
	fn."Název fondu fondů",
	kp."Jméno nebo Název",
	typ."Název" AS "Typ konečného příjemce",
	kp."Identifikační údaj smlouvy",
	kp."Datum podpisu smlouvy",
	datpln."Datum plnění ze záruky",
	dpr."Datum předp uk pl záruky",
	vyszuv."Sjednaná výše zar úvěru",
	vyszar."Výše sk poskytnuté záruky",
	urp."Úroky z prodlení",
	plnz."Výše plnění ze záruky",
	vyszarsm."Výše záruky ze smlouvy",
	cu."Výše čerp zar uveru"
	-- tp."Vyplaceno na TP",
	-- uhu."Na úhradu úroků k záruce",
	-- vc."Výše čerpání úvěru"
	
FROM 		isum.v_bi_UMPFinNastroj fn 
INNER JOIN	isum.v_bi_UMPFNPrehledKP kp ON kp.id_finnastroj=fn.id
INNER JOIN	isum.v_bi_UmsCisZakladni typ ON typ.id=kp.id_typprijemce
-- INNER JOIN
-- (SELECT		rzfin."Datum" AS "Datum předp splacení úvěru",
-- 		rzfin.ID_PREHLEDKP
--  FROM		isum.V_BI_UmpFNRozpisFin rzfin 
--  INNER JOIN 	isum.v_BI_UmsCISZakladni nazev ON nazev.id=rzfin.id_typ
--  WHERE nazev."Kód" = 'PKP0401' /* Datum předpokládaného splacení úvěru */) datspl ON datspl.ID_PREHLEDKP=kp.id
INNER JOIN 
(SELECT		rzfin."Celkové způsobilé výdaje" AS "Datum plnění ze záruky",
		rzfin.ID_PREHLEDKP
 FROM		isum.V_BI_UmpFNRozpisFin rzfin 
 INNER JOIN 	isum.v_BI_UmsCISZakladni nazev ON nazev.id=rzfin.id_typ
 WHERE nazev."Název" = 'Datum plnění ze záruky') datpln ON datpln.ID_PREHLEDKP=kp.id
INNER JOIN 
(SELECT		rzfin."Celkové způsobilé výdaje" AS "Výše sk poskytnuté záruky",
		rzfin.ID_PREHLEDKP
 FROM		isum.V_BI_UmpFNRozpisFin rzfin 
 INNER JOIN 	isum.v_BI_UmsCISZakladni nazev ON nazev.id=rzfin.id_typ
 WHERE nazev."Název" = 'Výše skutečně poskytnuté záruky') vyszar ON vyszar.ID_PREHLEDKP=kp.id

INNER JOIN 
(SELECT		rzfin."Celkové způsobilé výdaje" AS "Výše záruky ze smlouvy",
		rzfin.ID_PREHLEDKP
 FROM		isum.V_BI_UmpFNRozpisFin rzfin 
 INNER JOIN 	isum.v_BI_UmsCISZakladni nazev ON nazev.id=rzfin.id_typ
 WHERE nazev."Název" = 'Výše záruky ze smlouvy') vyszarsm ON vyszarsm.ID_PREHLEDKP=kp.id

INNER JOIN 
(SELECT		rzfin."Datum" AS "Datum předp uk pl záruky",
		rzfin.ID_PREHLEDKP
 FROM		isum.V_BI_UmpFNRozpisFin rzfin 
 INNER JOIN 	isum.v_BI_UmsCISZakladni nazev ON nazev.id=rzfin.id_typ
 WHERE nazev."Název" = 'Datum předpokládaného ukončení platnosti záruky') dpr ON dpr.ID_PREHLEDKP=kp.id

INNER JOIN 
(SELECT		rzfin."Celková částka pro odměny" AS "Sjednaná výše zar úvěru",
		rzfin.ID_PREHLEDKP
 FROM		isum.V_BI_UmpFNRozpisFin rzfin 
 INNER JOIN 	isum.v_BI_UmsCISZakladni nazev ON nazev.id=rzfin.id_typ
 WHERE nazev."Název" = 'Sjednaná výše zaručeného úvěru' ) vyszuv ON vyszuv.ID_PREHLEDKP=kp.id

INNER JOIN 
(SELECT		rzfin."Celková částka pro odměny" AS "Úroky z prodlení",
		rzfin.ID_PREHLEDKP
 FROM		isum.V_BI_UmpFNRozpisFin rzfin 
 INNER JOIN 	isum.v_BI_UmsCISZakladni nazev ON nazev.id=rzfin.id_typ
 WHERE nazev."Název" = 'Výše uhrazených úroků z prodlení, sankcí a vymožených nákladů soudních řízení' ) urp ON urp.ID_PREHLEDKP=kp.id

INNER JOIN 
(SELECT		rzfin."Celková částka pro odměny" AS "Výše plnění ze záruky",
		rzfin.ID_PREHLEDKP
 FROM		isum.V_BI_UmpFNRozpisFin rzfin 
 INNER JOIN 	isum.v_BI_UmsCISZakladni nazev ON nazev.id=rzfin.id_typ
 WHERE nazev."Název" = 'Výše vymoženého plnění ze záruky' ) plnz ON plnz.ID_PREHLEDKP=kp.id

INNER JOIN 
(SELECT		rzfin."Celková částka pro odměny" AS "Výše čerp zar uveru",
		rzfin.ID_PREHLEDKP
 FROM		isum.V_BI_UmpFNRozpisFin rzfin 
 INNER JOIN 	isum.v_BI_UmsCISZakladni nazev ON nazev.id=rzfin.id_typ
 WHERE nazev."Název" = 'Výše čerpaní zaručeného úvěru' ) cu ON cu.ID_PREHLEDKP=kp.id

WHERE fn."Registrační číslo fondu fondů" = 'FN_2018_005'
-- in ('FN_2018_005','FN_2017_001','FN_2017_002')
