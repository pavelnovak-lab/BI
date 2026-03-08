SELECT p."Registraèní èíslo projektu" ,
       p.kodwfstav "Aktuální stav",
       hs.stavdo "Pøedchozí stav",
       p."Datum zahájení pøedp",
       p."Datum ukonèení pøedp",
       p."Doba trvání projektu (mìs)" "Plánovaná doba trvání (mìs)",
       p."Datum zahájení skut",
       p."Datum ukonèení skut" ,
       p."Doba trvání proj skut (mìs)" "Skuteèná doba trvání (mìs)",
       p.id
FROM isum.v_bi_UmzProjekt p
INNER JOIN (
   SELECT p.id ,
   	  max(hs.poradi) max_poradi
   FROM isum.v_bi_UmzProjekt p
   INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id
   WHERE p."Registraèní èíslo projektu" is not null
   AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 
   GROUP BY p.id 
   ) predposledni ON predposledni.id = p.id
-- INNER JOIN (
--    SELECT p.id ,
--    	  hs.datumdo
--    FROM isum.v_bi_UmzProjekt p
--    INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id
--    WHERE p."Registraèní èíslo projektu" is not null
--    AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4')
--    AND hs.stavdo = 'PP30'
--    GROUP BY p.id 
--    ) predposledni ON predposledni.id = p.id
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id 

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4')
AND p."Registraèní èíslo projektu" is not null
AND predposledni.max_poradi - 1 = hs.poradi

----------------------------------------
SELECT p.id,
       hs.datumod "Datum RoPD"

FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 
AND hs.stavdo = 'PP30'


-- INNER JOIN (SELECT hs."CREATE_CAS", p.id, (row_number() OVER (PARTITION BY p."Registraèní èíslo projektu" ORDER BY hs."CREATE_CAS" DESC)) as "Poøadí"
 
--  FROM isum.v_bi_umzprojekt p
--  INNER JOIN isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id
 
--  WHERE hs."STAVZNAZEV" not like 'Pøedbì¾ná%'
--  -- AND p."KODWFSTAV" = 'PN20b')
--  WHERE "Poøadí" = 2
--  ) predposledni ON p.id=predposledni.id


