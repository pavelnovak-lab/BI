SELECT 	p."Registraèní èíslo projektu" ,
        p.kodwfstav,
--	oh.pocetbodu AS "OH bodù",
-- 	oh.arbiter AS "OH arbitr",
-- 	oh.OpravneHodnoceni AS "OH OH",
	oh.Datum_Finalizace AS "Datum finalizace OH",
	a.pocetbodu AS "Arbitr bodù",
-- 	a.arbiter AS "Arbitr arbitr",
-- 	a.OpravneHodnoceni AS "Arbitr OH",
	a.Datum_Finalizace AS "Datum finalizace arbitr"


FROM isum.v_bi_UmzProjekt p 
INNER JOIN 
  (SELECT h.id_noshodnoceni,
	  p."Registraèní èíslo projektu" ,
	  p.kodwfstav,
	  h.pocetbodu,
	  h.arbiter,
	  h.OpravneHodnoceni,
	  h.Datum_Finalizace
  FROM isum.v_bi_UmzProjekt p 
  INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
  AND 	h.id_kolohodnoceni=171212   /* hodnocení "ostré" ¾ádosti projektu */
  AND 	h.id_KrokVecHodn = 171214 /* 2. krok VH */ 
  AND 	h.arbiter = 'N'
  AND	h.platnost = 'A'
  AND	h.SchvalenoSchval = 'A'
  AND 	h.OpravneHodnoceni = 'A'
  AND	h.finalizovano = 'A'
  ) oh ON oh.id_noshodnoceni=p.id
INNER JOIN 
  (SELECT h.id_noshodnoceni,
	  p."Registraèní èíslo projektu" ,
	  p.kodwfstav,
	  h.pocetbodu,
	  h.arbiter,
	  h.OpravneHodnoceni,
	  h.Datum_Finalizace
  FROM isum.v_bi_UmzProjekt p 
  INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
  AND 	h.id_kolohodnoceni=171212   /* hodnocení "ostré" ¾ádosti projektu */
  AND 	h.id_KrokVecHodn = 171214 /* 2. krok VH */ 
  AND 	h.arbiter = 'A'
  AND	h.platnost = 'A'
  AND	h.SchvalenoSchval = 'A'
  AND 	h.OpravneHodnoceni = 'N'
  AND	h.finalizovano = 'A'
  ) a ON a.id_noshodnoceni=p.id

WHERE
p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/19_262/0020241'
AND	p.kodwfstav not in ('PP20','Z1','Z2','Z3')
AND 	oh.Datum_Finalizace > a.Datum_Finalizace

