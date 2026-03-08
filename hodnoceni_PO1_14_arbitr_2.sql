SELECT v."Název výzvy" ,
       p."Registrační číslo projektu" ,
       p.kodWFStav,
       cst.nazev "Celkový status VH",
       st.pocetbodu "Celkem bodů",
       max(CASE WHEN hod.id = prvni."id_hodnoceni" THEN hod.pocetbodu END) "Body H1",       
       max(CASE WHEN hod.id = druhy."id_hodnoceni" THEN hod.pocetbodu END) "Body H2",
       max(CASE WHEN hod.id = arb."id_hodnoceni" THEN hod.pocetbodu END) "Body arbitr",       

       max(CASE WHEN hod.id = prvni."id_hodnoceni" THEN hod.vyhovel END) "Vyhověl H1",       
       max(CASE WHEN hod.id = druhy."id_hodnoceni" THEN hod.vyhovel END) "Vyhověl H2",
       max(CASE WHEN hod.id = arb."id_hodnoceni" THEN hod.vyhovel END) "Vyhověl arbitr",       

       listagg(DISTINCT cis."Název",'; ') "Odbornost projektu",
       LISTAGG(DISTINCT ci."Název",'; ' on overflow truncate) AS "Název CZ NACE",
       LISTAGG(DISTINCT ci."Kód",'; ' on overflow truncate) AS "Kód CZ NACE"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel AND n."Je součástí projektu?" = 'A'
INNER JOIN isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
INNER JOIN isum.v_bi_UMVHodnNosOdbornost odb ON odb.id_noshodnoceni = p.id
INNER JOIN isum.v_bi_UMSCisOdbornost cis ON cis.id = odb.id_odbornost

INNER JOIN
   (SELECT MIN(h.id) "id_hodnoceni",
	   h.id_noshodnoceni
    FROM isum.v_bi_UmvHodnoceni h
    WHERE  h.PLATNOST = 'A'
    AND h.FINALIZOVANO = 'A'
    AND h.SCHVALENOSCHVAL = 'A'
    AND h.OPRAVNEHODNOCENI = 'N'
    AND h.id_krokvechodn = 171214 /* 2. krok VH */
    AND h.arbiter  = 'N'
    /* Vyhodit dva projekty */
    -- AND id_noshodnoceni IN (913274785, 160062517)
    GROUP BY h.id_noshodnoceni) prvni ON prvni.id_noshodnoceni = p.id 

INNER JOIN 
  (SELECT MAX(h.id) "id_hodnoceni",
 	 h.id_noshodnoceni
  FROM isum.v_bi_UmvHodnoceni h
  WHERE  h.PLATNOST = 'A'
  AND h.FINALIZOVANO = 'A'
  AND h.SCHVALENOSCHVAL = 'A'
  AND h.OPRAVNEHODNOCENI = 'N'
  AND h.id_krokvechodn = 171214 /* 2. krok VH */
  AND h.arbiter  = 'N'
  /* Vyhodit dva projekty */
  -- AND id_noshodnoceni IN (913274785, 160062517)
  GROUP BY h.id_noshodnoceni) druhy ON druhy.id_noshodnoceni = p.id 

LEFT JOIN 
  (SELECT id "id_hodnoceni",
 	 id_noshodnoceni
  FROM isum.v_bi_UmvHodnoceni 
  WHERE Arbiter = 'A'
  AND platnost = 'A'
  AND finalizovano = 'A'
  AND schvalenoschval = 'A'
  AND id_krokvechodn = 171214
  /* Vyhodit dva projekty */
  -- AND id_noshodnoceni IN (913274785, 160062517)
  ) arb ON arb.id_noshodnoceni = p.id
  -- AND id_noshodnoceni = h.id_noshodnoceni

INNER JOIN isum.v_bi_UmvHodnoceni hod ON hod.id_noshodnoceni = p.id  
INNER JOIN isum.v_bi_UmvHodnStatusDH st ON st.id_noshodnoceni = p.id AND st.id_krokvechodn = 171214
INNER JOIN isum.v_bi_UmvHodnStatusCis cst ON cst.id = st.id_statushodn

WHERE p."Registrační číslo projektu" IN ('CZ.01.1.02/0.0/0.0/20_321/0025045','CZ.01.1.02/0.0/0.0/20_321/0025217','CZ.01.1.02/0.0/0.0/20_321/0025163','CZ.01.1.02/0.0/0.0/20_321/0024701','CZ.01.1.02/0.0/0.0/20_318/0025749','CZ.01.1.02/0.0/0.0/20_321/0025218','CZ.01.1.02/0.0/0.0/20_321/0025269','CZ.01.1.02/0.0/0.0/20_318/0024956','CZ.01.1.02/0.0/0.0/20_321/0025082','CZ.01.1.02/0.0/0.0/20_321/0024128','CZ.01.1.02/0.0/0.0/20_321/0024407','CZ.01.1.02/0.0/0.0/20_321/0024941','CZ.01.1.02/0.0/0.0/20_321/0025164')
 -- AND p.id_vyzva IN (1273732553, 848185252, 1273330784, 844865615) -- apl, ino - obě IX. a VIII.

GROUP BY v."Název výzvy" ,
       p."Registrační číslo projektu" ,
       p.kodWFStav
       , cst.nazev,
       st.pocetbodu
       
ORDER BY v."Název výzvy" 
