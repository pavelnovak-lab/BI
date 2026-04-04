SELECT 	p."Registrační číslo projektu" ,
	-- SUBSTR Ořízne prvních 6 znaků (číselný kód)
 	SUBSTR( p.kompetencniutvar, 6 ) AS "Program podpory", 
	h.create_uzivatel "Hodnotitel OH",
	prvni.create_uzivatel "První hodnotitel",
	druhy.create_uzivatel "Druhý hodnotitel"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
INNER JOIN
( SELECT min(h.poradi) as poradi_1,
  	 max(h.poradi) as poradi_2,
  	 h.id_noshodnoceni
 FROM	isum.v_bi_UmvHodnoceniPrj h

  WHERE h.id_kolohodnoceni=171212   /* hodnocení "ostré" žádosti */
  AND 	h.id_KrokVecHodn = 171214 /* 2. krok VH */ 
  AND 	h.arbiter = 'N' 
  AND	h.platnost = 'A'
  AND	h.SchvalenoSchval = 'A' 
  AND 	h.OpravneHodnoceni = 'N'
  AND	h.finalizovano = 'A'
  GROUP BY  h.id_noshodnoceni 
   ) poradi ON poradi.id_noshodnoceni = p.id
INNER JOIN 
( SELECT h.create_uzivatel,
  	 h.id_noshodnoceni,
	 h.poradi
 FROM	isum.v_bi_UmvHodnoceniPrj h
  WHERE h.id_kolohodnoceni=171212   /* hodnocení "ostré" žádosti */
  AND 	h.id_KrokVecHodn = 171214 /* 2. krok VH */ 
-- AND 	(h.arbiter = 'N' OR h.arbiter = 'A')
   AND	h.platnost = 'A'
   AND	h.SchvalenoSchval = 'A' 
   AND 	h.OpravneHodnoceni = 'N'
   AND	h.finalizovano = 'A'
   ) prvni ON prvni.id_noshodnoceni = p.id AND poradi.poradi_1 = prvni.poradi
INNER JOIN 
( SELECT h.create_uzivatel,
  	 h.id_noshodnoceni,
	 h.poradi
 FROM	isum.v_bi_UmvHodnoceniPrj h
  WHERE h.id_kolohodnoceni=171212   /* hodnocení "ostré" žádosti */
  AND 	h.id_KrokVecHodn = 171214 /* 2. krok VH */ 
-- AND 	(h.arbiter = 'N' OR h.arbiter = 'A')
   AND	h.platnost = 'A'
   AND	h.SchvalenoSchval = 'A' 
   AND 	h.OpravneHodnoceni = 'N'
   AND	h.finalizovano = 'A'
   ) druhy ON druhy.id_noshodnoceni = p.id AND poradi.poradi_2 = druhy.poradi


WHERE
p."Registrační číslo projektu" is not null
-- in ('CZ.01.2.06/0.0/0.0/15_038/0006860')
AND	p.kodwfstav not in ('PP20','Z1','Z2','Z3','PN21','PN22')
AND 	h.id_kolohodnoceni=171212   /* hodnocení "ostré" žádosti */
AND 	h.id_KrokVecHodn = 171214 /* 2. krok VH */ 


-- AND 	(h.arbiter = 'N' OR h.arbiter = 'A')
AND	h.platnost = 'A'

AND	h.SchvalenoSchval = 'A' 
AND 	h.OpravneHodnoceni = 'A'
AND	h.finalizovano = 'A'
AND 	(h.create_uzivatel = prvni.create_uzivatel OR h.create_uzivatel = prvni.create_uzivatel )
