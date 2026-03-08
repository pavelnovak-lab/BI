SELECT	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	p."Registraèní èíslo projektu" ,
	p.kodwfstav,
	sch.lmt "Datum schválení (ze scvhálení)" ,
	hod.arbiter,
	hod.opravnehodnoceni,
	tel.ciskod "Kód hodnotitele",
	hod.id_kolohodnoceni,
	kolo.popis "Kolo hodnoceni"
	-- tel."Datum schválení"
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmvHodnoceni hod ON hod.id_noshodnoceni = p.id 
INNER JOIN isum.v_bi_UMVHodnSchvaleniPrj sch ON sch.id_hodnoceni = hod.id
INNER JOIN isum.v_bi_UmvHodnotitel tel ON tel.id = id_hodnotitel
-- INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = id_kolohodnoceni
INNER JOIN isum.v_bi_UMVHodnKolo kolo ON kolo.id = hod.id_kolohodnoceni

WHERE

-- AND h.Arbiter = 'A'
-- AND hod.platnost = 'A'
hod.finalizovano = 'A'
-- AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_014/0004364'
AND hod.schvalenoschval = 'A'
AND sch.finschval = 'A'
AND sch.LAST_MODIF_UZIVATEL = 'PORPET'
-- AND hod.ID_VARDRUHHODN = 178017 -- snad plná ¾ádost
AND trunc(sch.lmt) < to_date('2017-01-01','yyyy-mm-dd')


ORDER BY p."Registraèní èíslo projektu" , sch.lmt
