SELECT 	krit.kod,
	krit.Nazev,
	krit.vyhovel,
       	krit.pocetbodu,
	krit.popis

FROM isum.v_bi_UmvHodnoceni hod
INNER JOIN isum.v_bi_UMVHodnotaKrit krit ON krit.id_hodnoceni = hod.id

-- id = 1139453338

-- isum.v_bi_UmvHodnoceni hod
WHERE hod.id = :id_hodnoceni
--  998801083

ORDER BY krit.kod
