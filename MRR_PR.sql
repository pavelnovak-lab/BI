SELECT  p."Registrační číslo projektu",
	mrr."Kód" AS "Kód MRR",
	mrr."Název" "Název MRR",
	pr."Kód" "Kód PR",
	pr."Název" "Název PR"
	
-- 	LISTAGG(ci."Kód",'; ') WITHIN GROUP (ORDER BY ci."Kód") AS "Kód",
-- 	LISTAGG(ci."Název",'; ') WITHIN GROUP (ORDER BY ci."Kód") AS "Název"

FROM		isum.v_bi_UmzPrjGGII p
-- INNER JOIN	isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN (SELECT pp.id,
      	   ci."Kód",
	   ci."Název"
FROM  isum.v_bi_UmzPrjGGII pp 
INNER JOIN	isum.v_bi_UmzPrjKI ki ON pp.id=ki.id_projekt AND ki."Typ kategorie intervencí" = 7  
INNER JOIN 	isum.v_bi_UmsCisZakladni ci ON ki.id_ki=ci.id 

WHERE pp."Registrační číslo projektu" like ('CZ.01.1.02%')
AND ci."Kód" in ('CZ041','CZ042','CZ051','CZ052','CZ053','CZ071','CZ072','CZ080') ) mrr ON mrr.id = p.id


INNER JOIN (SELECT pp.id ,
      	   ci."Kód",
	   ci."Název"

FROM  isum.v_bi_UmzPrjGGII pp 

INNER JOIN	isum.v_bi_UmzPrjKI ki ON pp.id=ki.id_projekt AND ki."Typ kategorie intervencí" = 7  
INNER JOIN 	isum.v_bi_UmsCisZakladni ci ON ki.id_ki=ci.id 

WHERE pp."Registrační číslo projektu" like ('CZ.01.1.02%')
AND ci."Kód" in ('CZ031','CZ032','CZ063','CZ064','CZ010','CZ020') ) pr ON pr.id = p.id


-- GROUP BY  p."Registrační číslo projektu" 
