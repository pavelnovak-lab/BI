SELECT 	p."Registrační číslo projektu" ,
	-- SUBSTR Ořízne prvních 6 znaků (číselný kód)
 	SUBSTR( p.kompetencniutvar, 6 ) AS "Program podpory", 
	p.kodwfstav,
	h.pocetbodu,
	h.arbiter,
	h.schvalenoschval, /* Pozor, h.schvalenoschval se všude nerovná sch.schvalenoschval */
	NVL(h.datum_finalizace,h.datumhodnoceni) AS "Datum hodnocení", /* Existují prj, kde není h.datum_finalizace vyplněno, tam přiřazuji h.datumhodnoceni */
	sch.Last_Modif_Uzivatel AS Schvalovatel, /* Bohužel nevím odkud jinud */
	h.Create_uzivatel AS Hodnotitel,
-- 	sch.DatumSchval, /* Existují schválené posudky, kde není DatumSchval vyplněno, proto následující podmínka. */
	(CASE WHEN (sch.schvalenoschval = 'A' AND sch.DatumSchval is null)
	 THEN sch.Last_Modif_cas
	 ELSE sch.DatumSchval  END) AS "Datum schválení" /* Tam, kde není schváleno bude prázdné pole */

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
INNER JOIN isum.v_bi_UmvHodnSchvaleni sch ON h.id=sch.id_hodnoceni
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 

WHERE v."Číslo výzvy" = '01_19_275'
-- p."Registrační číslo projektu" is not null
-- ('CZ.01.3.14/0.0/0.0/19_253/0020892','CZ.01.1.02/0.0/0.0/19_262/0020241','CZ.01.1.02/0.0/0.0/15_031/0007136','CZ.01.1.02/0.0/0.0/19_262/0020241','CZ.01.2.111/0.0/0.0/15_016/0000226', 'CZ.01.2.06/0.0/0.0/19_250/0019192')
AND	p.kodwfstav not in ('PP20','Z1','Z2','Z3','PN21','PN22')
AND 	h.id_kolohodnoceni=171212   /* hodnocení "ostré" žádosti */
AND 	h.id_KrokVecHodn = 171214 /* 2. krok VH */ 
-- Po konzultaci je povolen i arbitr, check má hodnotu buď A nebo N, OR je tu zbytečné
-- AND 	(h.arbiter = 'N' OR h.arbiter = 'A')
AND	h.platnost = 'A'
AND	h.SchvalenoSchval = 'A'
AND 	h.OpravneHodnoceni = 'N'
AND	h.finalizovano = 'A'
 	
