SELECT	p."Registrační číslo projektu",
	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
	p.kodwfstav ,
	p.wfstavdatum,
	platba."Datum změny stavu" AS "Proplacení poslední ŽoP",
	ZoU."Sledované období od" AS "1. ZoU od",
 	hs.datumOd  AS "Datum přepnutí PP41",
	(select count(*)  
 	from isum.V_BI_UMSKALENDAR r 
 	where r.datum between platba."Datum změny stavu" and ZoU."Sledované období od" 
	-- and r.dentydne not in (6,7) 
	-- and r.SVATEK='N'
	) AS "Dni mezi posl ŽoP a 1. ZoU",
  	(select count(*)  
 	from isum.V_BI_UMSKALENDAR r 
 	where r.datum between platba."Datum změny stavu" and hs.datumOd 
	-- and r.dentydne not in (6,7) 
	-- and r.SVATEK='N'
	) AS "Dní mezi  ŽoP a PP41"

FROM	isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
LEFT JOIN isum.v_bi_UMZZIProjekt ZoU ON ZoU.id_zad = p.id
LEFT JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id

WHERE platba.kodwfstav in ('P10','P11')
AND   platba."Závěrečná platba" = 'A'
AND   p.kodwfstav in ( 'PP40', 'PP41', 'PP42' )
AND   ZoU.id_ZoU <> 0
AND   ZoU."Pořadové číslo ZoR/IoP" = 1
AND   hs.stavdo = 'PP41'
AND   (ZoU."Sledované období od" - platba."Datum změny stavu" ) > 30


ORDER BY "Dni mezi posl ŽoP a 1. ZoU" DESC

--  AND   p.id = 4701502

