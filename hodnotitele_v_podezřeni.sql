SELECT  SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	p."Registraèní èíslo projektu",
	p."Název projektu CZ",
	p.zadatel ,
	p."IÈ",
	-- TO_CHAR(hod.DATUM_FINALIZACE, 'dd. MM. yyyy'),
        -- TO_CHAR(hod.DATUMHODNOCENI, 'dd. MM. yyyy'),
	hodnotitel."Název" "Jméno hodnotitele",
	hodnotitel."Kód" "Kód hodnotitele",
	hod.DATUM_FINALIZACE,
	hod.DATUMHODNOCENI,
 	hod.pocetbodu "Celkem bodù",
	hod.popis "Popis posudku",
	REPLACE(REPLACE(hod.komentar,CHR(10),' $ '),CHR(13),' $ ') as  "Komentáø",
	hod.stavposudku,
	hod.PORADI "Poøádí posudku"
	REPLACE(REPLACE(hod.ratinghodnpopis,CHR(10),' $ '),CHR(13),' $ ') as RATINGHODNPOPIS,
	hod.RATINGHODNZNAMKA ,
	hod.DRUHHODN
	


FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmvHodnoceni hod ON hod.id_noshodnoceni = p.id -- AND hod.id_krokvechodn = 171213 -- 1. krok vh 
-- INNER JOIN isum.v_bi_UMVHodnotaKrit krit ON krit.id_hodnoceni = hod.id
INNER JOIN isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id = hod.id_hodnotitel
-- INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  hod.id_krokvechodn


WHERE hod.platnost = 'A'
-- AND p."Registraèní èíslo projektu" in ('CZ.31.4.0/0.0/0.0/22_017/0002313','CZ.31.4.0/0.0/0.0/22_017/0003341','CZ.31.4.0/0.0/0.0/22_017/0003265')
AND hod.AGREGAT = 'N'
-- AND p.id_vyzva = 1607294465 -- vyzva 31_22_017
AND hodnotitel."Kód" in ('3366','2207','2504')

ORDER BY hod.DATUM_finalizace ASC
