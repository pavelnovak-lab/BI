
SELECT p."Registrační číslo projektu" ,
	  p.kodwfstav,
	  h.pocetbodu,
	  h.create_cas,
	  hd."Název"
	  
  FROM isum.v_bi_UmzProjekt p 
  INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
  INNER JOIN isum.v_bi_UmvHodnotitel hd ON hd.id = h.id_hodnotitel
  AND 	h.id_kolohodnoceni=171212   /* hodnocení "ostré" žádosti projektu */
  AND 	h.id_KrokVecHodn = 171214 /* 2. krok VH */ 
  AND 	h.arbiter = 'A'
  AND	h.platnost = 'A'
  AND	h.SchvalenoSchval = 'A'
  AND	h.finalizovano = 'A'
  AND 	hd."Externí hodnotitel" ='A'

ORDER BY h.create_cas
