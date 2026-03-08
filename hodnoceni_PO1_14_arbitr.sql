WITH posudky AS
(
SELECT  MIN(h.id) "id_hodnoceni_prvni",
 	MAX(h.id) "id_hodnoceni_druhy",
	arb."id_hodnoceni_arb",
	h.id_noshodnoceni,
	p."Registrační číslo projektu" 
 FROM isum.v_bi_UmzProjekt p 
 INNER JOIN isum.v_bi_UmvHodnoceni h ON h.id_noshodnoceni = p.id 
 LEFT JOIN 
 (SELECT id "id_hodnoceni_arb",
 	 id_noshodnoceni
  FROM isum.v_bi_UmvHodnoceni 
  WHERE Arbiter = 'A'
  AND platnost = 'A'
  AND finalizovano = 'A'
  AND schvalenoschval = 'A'
  AND id_krokvechodn = 171214) arb ON arb.id_noshodnoceni = h.id_noshodnoceni
  -- AND id_noshodnoceni = h.id_noshodnoceni
 
 WHERE h.PLATNOST = 'A'
 AND h.FINALIZOVANO = 'A'
 AND h.SCHVALENOSCHVAL = 'A'
 AND h.OPRAVNEHODNOCENI = 'N'
 AND h.id_krokvechodn = 171214 /* 2. krok VH */
 AND h.arbiter  = 'N'
 -- AND p."Registrační číslo projektu" in ('CZ.01.2.07/0.0/0.0/16_058/0007976','CZ.01.1.02/0.0/0.0/19_262/0020179')
 AND p.id_vyzva IN (1273732553, 848185252, 1273330784, 844865615) -- apl, ino - obě IX. a VIII.
 /* jen projekty s arbitrem */
 -- AND EXISTS
 -- (SELECT 0
 --  FROM isum.v_bi_UmvHodnoceni 
 --  WHERE Arbiter = 'A'
 --  AND platnost = 'A'
 --  AND finalizovano = 'A'
 --  AND schvalenoschval = 'A'
 --  AND id_krokvechodn = 171214
 --  AND id_noshodnoceni = h.id_noshodnoceni
 -- )
 GROUP BY h.id_noshodnoceni, p."Registrační číslo projektu", arb."id_hodnoceni_arb" 
)

-- status AS
-- (
 SELECT ps.*
	-- h.id_noshodnoceni,
        -- max(CASE WHEN h.id = ps.id_hodnoceni_prvni THEN h.pocetbodu END) "Body 1.",
	-- max(CASE WHEN h.id = ps.id_hodnoceni_prvni THEN h.vyhovel  END) "Vyhověl 1.",
	-- max(CASE WHEN h.id = ps.id_hodnoceni_druhy THEN h.pocetbodu END) "Body 2.",
	-- max(CASE WHEN h.id = ps.id_hodnoceni_druhy THEN h.vyhovel  END) "Vyhověl 2." ,
 	-- max(CASE WHEN h.arbiter = 'A' THEN h.pocetbodu END) "Body arbitr" ,
 	-- max(CASE WHEN h.arbiter = 'A' THEN h.vyhovel  END) "Vyhověl arbitr"
 FROM posudky ps
--   INNER JOIN isum.v_bi_UmvHodnoceni h ON h.id_noshodnoceni = ps.id_noshodnoceni 
--   -- INNER JOIN isum.v_bi_UmvHodnStatusCis sh on sh.id = h.id_statushodn
--  WHERE h.platnost = 'A'
--   AND h.finalizovano = 'A'
--   AND h.schvalenoschval = 'A'
--   AND h.id_krokvechodn = 171214
--  GROUP BY h.id_noshodnoceni
-- -- )
