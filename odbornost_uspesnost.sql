SELECT	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	v."Číslo výzvy",
	v."Název výzvy", 
	p."Registrační číslo projektu" ,
       	p.kodwfstav ,
       	-- count(odb."Název") "Počet odborností",
	SUBSTR(LISTAGG( odb."Název", '; '), 0, 10) "CZ NACE",
	CASE WHEN p.kodwfstav like ('PN%') then 'Negativní'
	     ELSE 'Pozitivní'
	     END  AS "Podpořen",
 	status.pocetbodu "Bodů ve VH",
        ci."Název" "Vyhověl/Nevyhověl VH",
	CASE WHEN arb.id_noshodnoceni is not null THEN 'A' END "Arbitr"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMVHodnNosOdbornost o ON o.id_noshodnoceni = p.id
INNER JOIN isum.v_bi_UMSCisOdbornost odb ON o.id_odbornost = odb.id
INNER JOIN isum.v_bi_UMVHodnStatusDH status ON status.id_noshodnoceni = p.id AND status.id_krokvechodn = 171214
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = status.id_statushodn
LEFT JOIN (
     SELECT id_noshodnoceni
     FROM isum.v_bi_UMVHodnoceni
     WHERE id_krokvechodn = 171214
     AND arbiter = 'A') arb ON arb.id_noshodnoceni = p.id

WHERE p."Registrační číslo projektu" is not null 
AND v."Číslo výzvy" IN ('01_21_374','01_20_321', '01_21_373', '01_20_318')
-- Having count(odb."Název") = 1
GROUP BY SUBSTR(p.kompetencniutvar, 6)  ,
	v."Číslo výzvy",
	v."Název výzvy", 
	p."Registrační číslo projektu" ,
       	p.kodwfstav,
	CASE WHEN p.kodwfstav like ('PN%') then 'Negativní'
	     ELSE 'Pozitivní'
	     END  ,
 	status.pocetbodu,
        ci."Název",
	CASE WHEN arb.id_noshodnoceni is not null THEN 'A' END

