SELECT 	p."Registraèní èíslo projektu" ,
	p.kodwfstav,
	p.zadatel,
	-- p."Datum ukonèení pøedp" ,
	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,

	-- listagg(DISTINCT ci."Název", '; ' on overflow truncate) AS "Název CZ NACE",
	-- listagg(DISTINCT ci."Kód", '; ' on overflow truncate) AS "Kód CZ NACE"

	-- listagg(DISTINCT hodnotitel."Kód", '; ') "Kód hodnotitelù",
 	-- listagg(DISTINCT cis."Název",'; ') "Odbornost"
	prvni."Kód" "Kód",
	prvni.Pocetbodu,
	prvni.Vyhovel,
	prvni.Rating,
	sh."POCETBODU" "Celkem bodù 2. krok VH",
	hcis.nazev "Celkový status 2. krok VH"

FROM isum.v_bi_UmzProjekt p

-- LEFT JOIN isum.v_bi_UMVHodnNosOdbornost odb ON odb.id_noshodnoceni = p.id
-- LEFT JOIN isum.v_bi_UMSCisOdbornost cis ON cis.id = odb.id_odbornost

-- LEFT JOIN isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel AND n."Je souèástí projektu?" = 'A'
-- LEFT JOIN isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace

INNER JOIN (SELECT min(h.poradi),
		   h.POCETBODU ,
		   h.VYHOVEL ,
      	   	   h.RATINGHODNZNAMKA "Rating",
		   hodnotitel."Kód",
		   h.id_noshodnoceni		   

FROM  isum.v_bi_UmvHodnoceni h
INNER JOIN isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id = h.id_hodnotitel AND h.id_KrokVecHodn = 171214 /* 2. krok VH */ AND h.id_kolohodnoceni= 171212   /* hodnocení "ostré" ¾ádosti */

WHERE h.TYPHODNOTITELE = 'Øádný hodnotitel'
-- TYPHODNOTITELE (Arbitr)
-- TYPHODNOTITELE (Opravný hodnotitel)
AND h.platnost = 'A'
AND h.finalizovano = 'A'
AND hodnotitel."Externí hodnotitel" = 'A'

GROUP BY h.POCETBODU ,
      h.VYHOVEL ,
      h.RATINGHODNZNAMKA,
      hodnotitel."Kód",
      h.id_noshodnoceni		   

) prvni ON p.id=prvni.id_noshodnoceni 

INNER JOIN isum.v_bi_UMVHodnStatusDH sh ON sh.id_noshodnoceni = p.id AND sh.id_KrokVecHodn = 171214 AND h.id_kolohodnoceni= 171212
INNER JOIN isum.v_bi_UMVHodnStatusCis hcis ON hcis.id = sh.id_statushodn

WHERE
-- AND p.kodwfstav in ('PP30','PP36','PP37')
 p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 
-- AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'
AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/20_321/0024535'

-- GROUP BY p."Registraèní èíslo projektu" ,
-- 	p.kodwfstav,
-- 	p.zadatel,
-- 	v."Název výzvy",
-- 	p."Datum ukonèení pøedp",
-- 	SUBSTR(p.kompetencniutvar, 6)



----------------------------------------

SELECT * 

FROM 

WHERE id = 1248559705
