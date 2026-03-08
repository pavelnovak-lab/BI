SELECT 	p."Registraèní èíslo projektu" ,
-- SUBSTR Oøízne prvních 6 znakù (èíselný kód)
       SUBSTR( p.kompetencniutvar, 6 ) AS "Program podpory", 
       p.kodwfstav,
       h.pocetbodu,
       h.datum_finalizace,
       sch.DatumSchval,
       sch.Create_uzivatel AS Hodnotitel,
       h.Last_Modif_Uzivatel AS Schvlaovatel,
--       (sch.DatumSchval - h.datum_finalizace)*24 AS "Èas ke schválení" ,


--     gg."EU" AS "Po¾adovaná dotace",
       gg."CZV" AS "Celkové zpùsobilé výdaje"

--       krit.limitvyhovelbodu AS "Bodová hranice 1. krok VH",
--       vh2.limitvyhovelbodu AS "Bodová hranice 2. krok VH"


FROM isum.v_bi_UmzProjekt p 
-- INNER JOIN 	 isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
-- INNER JOIN 	 isum.v_bi_umvhodnotitelkompprj h ON h.id_noshodnoceni=p.id
INNER JOIN 	 isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
LEFT JOIN	 isum.v_bi_UmvHodnSchvaleni sch ON h.id=sch.id_hodnoceni

-- INNER JOIN	 isum.v_bi_umvhodnotitel hd on hd.id=h.id_hodnotitel
--INNER JOIN	 isum.v_bi_cuzivatel c on c.id=hd.id_cuzivatel
--INNER JOIN 	 isum.v_bi_UMVHodnSoubKritVyz krit ON krit.id_vyzva=v.id

INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id

-- LEFT JOIN
-- (SELECT v.id,
-- 	krit.limitvyhovelbodu 
--  FROM isum.v_bi_UmzVyzva v 
--  INNER JOIN isum.v_bi_UMVHodnSoubKritVyz krit ON krit.id_vyzva=v.id
--  WHERE krit.id_KrokVecHodn = 171214
--  AND krit.platnostdo is null) vh2 ON vh2.id=v.id

WHERE p."Registraèní èíslo projektu" is not null
-- p."Registraèní èíslo projektu" in ('CZ.01.1.02/0.0/0.0/15_031/0007136','CZ.01.1.02/0.0/0.0/19_262/0020241')
--p."Registraèní èíslo projektu" is not null
-- AND 	p.kodprioritniosa = '01.1'
AND	p.kodwfstav not in ('PP20','Z1','Z2','Z3','PP21','PP22','PN21','PN22')
-- AND 	status.kodpopisstatutu=32    /* celkový výsledek fáze vìcného hodnoení */
AND 	h.id_kolohodnoceni=171212   /* hodnocení "ostré" ¾ádosti projektu */
-- AND	krit.id_kolohodnoceni = 171212
-- AND 	(krit.id_KrokVecHodn = 171213 OR krit.id_KrokVecHodn = 171214)
AND 	h.id_KrokVecHodn = 171214 /* 2. krok VH */ 
-- AND	krit.platnostdo is null /* nìkdy se mìnil soubor kritérií konverzí kvùli "pøeklepùm" pøi nastavení výzvy */
AND 	h.arbiter = 'N'
AND	h.platnost = 'A'
-- AND	h.SchvalenoSchval = 'A' OR 
AND 	h.OpravneHodnoceni = 'N'
AND	h.finalizovano = 'A'



