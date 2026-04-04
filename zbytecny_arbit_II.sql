SELECT	p."Registrační číslo projektu",
	p.kodwfstav,
	krit.limitvyhovelbodu AS "Bodová hranice 2. krok VH",
--	vh1.limitvyhovelbodu AS "Bodová hranice 1. krok VH",
	ih.MaxBodu as "1. IH bodů",
	ih.MinBodu as "2. IH bodů",
	a.pocetbodu as  "Arbitr bodů"


FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni=p.id
INNER JOIN isum.v_bi_UMVHodnSoubKritVyz krit ON krit.id_vyzva=v.id
LEFT JOIN 
  (SELECT h.id,
	  h.id_noshodnoceni,
	  max(h.pocetbodu) MaxBodu,
	  min(h.pocetbodu) MinBodu
  FROM isum.v_bi_UmzProjekt p 
  INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
  AND 	h.id_kolohodnoceni=171212   /* hodnocení "ostré" žádosti projektu */
  AND 	h.id_KrokVecHodn = 171214 /* 2. krok VH */ 
  AND 	h.arbiter = 'N'
  AND	h.platnost = 'A'
  AND	h.SchvalenoSchval = 'A'
  AND 	h.OpravneHodnoceni = 'N'
  AND	h.finalizovano = 'A'
  GROUP BY h.id_noshodnoceni, h.id
  ) ih ON ih.id_noshodnoceni=p.id
LEFT JOIN 
  (SELECT h.id_noshodnoceni,
	  h.pocetbodu
  FROM isum.v_bi_UmzProjekt p 
  INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
  AND 	h.id_kolohodnoceni=171212   /* hodnocení "ostré" žádosti projektu */
  AND 	h.id_KrokVecHodn = 171214 /* 2. krok VH */ 
  AND 	h.arbiter = 'A'
  AND	h.platnost = 'A'
  AND	h.SchvalenoSchval = 'A'
  AND	h.finalizovano = 'A'
  ) a ON a.id_noshodnoceni=p.id



WHERE  p."Registrační číslo projektu" is not null
 -- 'CZ.01.2.06/0.0/0.0/19_250/0019056'
AND    status.ARBITERPOVOLEN = 'A'

AND    status.id_kolohodn=171212   /*vybere jen hodnocení "ostré" žádosti projektu*/
AND 	status.id_KrokVecHodn = 171214 /* 2. krok VH */
AND	krit.id_kolohodnoceni = 171212
AND 	krit.id_KrokVecHodn = 171214 /* 2. krok VH */
AND	krit.platnostdo is null

AND	ih.maxbodu  >=  krit.limitvyhovelbodu
AND	ih.minbodu  <  krit.limitvyhovelbodu
AND EXISTS
(SELECT hprj.id
FROM isum.v_bi_UmvHodnoceniPrj hprj 
WHERE hprj.id = ih.id
AND   hprj.pocetbodu = ih.maxbodu
AND   hprj.vyhovel = 'N')
