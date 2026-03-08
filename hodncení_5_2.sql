SELECT	p."Registraèní èíslo projektu",
	hod.pocetbodu "Celkem bodù",
	hod.popis "Popis posudku",
	hod.komentar "Komentáø",
	hod.stavposudku,
	TO_CHAR(hod.DATUM_FINALIZACE, 'dd. MM. yyyy'),
        TO_CHAR(hod.DATUMHODNOCENI, 'dd. MM. yyyy'),
	hodnotitel."Název" "Jméno hodnotitele",
	hodnotitel."Kód" "Kód hodnotitele",
	bin1.vyhovel "BIN1 A/N" ,
	bin1.popis "Popis BIN1",
	bin2.vyhovel "BIN2 A/N" ,
	bin2.popis "Popis BIN2",
	bin3.vyhovel "BIN3 A/N" ,
	bin3.popis "Popis BIN3",
	bin4.vyhovel "BIN4 A/N" ,
	bin4.popis "Popis BIN4",
	bin5.vyhovel "BIN5 A/N" ,
	bin5.popis "Popis BIN5",
	bin7.vyhovel "BIN7 A/N" ,
	bin7.popis "Popis BIN7",
	bod1.pocetbodu "Poèet bodù B1",
	bod1.popis "Popis B1",
	-- bod11.pocetbodu+bod12.pocetbodu "Bodù v souètovém B1",

	bod11.pocetbodu "Poèet bodù B1.1",
	bod11.popis "Popis B1.1",
	bod12.pocetbodu "Poèet bodù B1.2",
 	bod12.popis "Popis B1.2",

	-- bod21.pocetbodu+bod22.pocetbodu+bod23.pocetbodu "Bodù v souètovém B2",
	bod2.pocetbodu "Poèet bodù B2",
	bod2.popis "Popis B2",


	bod21.pocetbodu "Poèet bodù B2.1",
	bod21.popis "Popis B2.1",
	bod22.pocetbodu "Poèet bodù B2.2",
 	bod22.popis "Popis B2.2",
	bod23.pocetbodu "Poèet bodù B2.3",
	bod23.popis "Popis B2.3",

	bod3.pocetbodu "Poèet bodù B3",
 	bod3.popis "Popis B3",

	bod4.pocetbodu "Poèet bodù B4",
 	bod4.popis "Popis B4"


FROM isum.v_bi_UmzPrjGGII p 
INNER JOIN isum.v_bi_UmvHodnoceni hod ON hod.id_noshodnoceni = p.id AND hod.id_krokvechodn = 171213 -- 1. krok vh 
-- INNER JOIN isum.v_bi_UMVHodnotaKrit krit ON krit.id_hodnoceni = hod.id
INNER JOIN isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id = hod.id_hodnotitel

INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.vyhovel,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BIN1'
) bin1 ON bin1.id_hodnoceni = hod.id

INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.vyhovel,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BIN2'
) bin2 ON bin2.id_hodnoceni = hod.id

INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.vyhovel,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BIN3'
) bin3 ON bin3.id_hodnoceni = hod.id

INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.vyhovel,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BIN4'
) bin4 ON bin4.id_hodnoceni = hod.id

INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.vyhovel,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BIN5'
) bin5 ON bin5.id_hodnoceni = hod.id

INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.vyhovel,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BIN7'
) bin7 ON bin7.id_hodnoceni = hod.id

INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.POCETBODU,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BOD1'
) bod1 ON bod1.id_hodnoceni = hod.id


INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.POCETBODU,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BOD1.1'
) bod11 ON bod11.id_hodnoceni = hod.id

INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.POCETBODU,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BOD1.2'
) bod12 ON bod12.id_hodnoceni = hod.id

INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.POCETBODU,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BOD2'
) bod2 ON bod2.id_hodnoceni = hod.id


INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.POCETBODU,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BOD2.1'
) bod21 ON bod21.id_hodnoceni = hod.id

INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.POCETBODU,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BOD2.2'
) bod22 ON bod22.id_hodnoceni = hod.id

INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.POCETBODU,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BOD2.3'
) bod23 ON bod23.id_hodnoceni = hod.id

INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.POCETBODU,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BOD3'
) bod3 ON bod3.id_hodnoceni = hod.id

INNER JOIN (
SELECT krit.NAZEVCELK,
       krit.id_hodnoceni,
       krit.POCETBODU,
       krit.popis
FROM isum.v_bi_UMVHodnotaKrit krit
WHERE krit.Kod = 'BOD4'
) bod4 ON bod4.id_hodnoceni = hod.id

WHERE hod.platnost = 'A'
-- AND p."Registraèní èíslo projektu" in ('CZ.31.4.0/0.0/0.0/22_017/0002313','CZ.31.4.0/0.0/0.0/22_017/0003341','CZ.31.4.0/0.0/0.0/22_017/0003265')
AND hod.AGREGAT = 'N'
AND p.id_vyzva = 1607294465 -- vyzva 31_22_017

ORDER hod.DATUMHODNOCENI ASC 


