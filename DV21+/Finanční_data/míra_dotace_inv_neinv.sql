SELECT CASE WHEN c.nazev LIKE 'Podpora de minimis%' THEN 'De minimis'
            ELSE c.nazev END AS "Režim podpory",
       gber.nazev AS "Článek GBER",
       vpo.castkacelk_kc AS "Způsobilé výdaje", 
       SUM(CASE WHEN pf.id_kategorieregionu = 283463 THEN pf.pomerfin * kr.less  --MRR
                WHEN pf.id_kategorieregionu = 283468 THEN pf.pomerfin * kr.trans -- PR
           END) / 100 AS "EU podíl maximálně",
 	100-SUM(CASE WHEN pf.id_kategorieregionu = 283463 THEN pf.pomerfin * kr.less  --MRR
                WHEN pf.id_kategorieregionu = 283468 THEN pf.pomerfin * kr.trans -- PR
           END) / 100 AS "Vlastní podíl minimálně"
	   
FROM v_rav_umzprojekt p
INNER JOIN v_rav_umsrdmpodpora vpo ON vpo.id_projekt = p.id
INNER JOIN v_rav_umsciszakladni c ON c.id = vpo.id_rezimpodpory
LEFT JOIN v_rav_umsciszakladni gber ON gber.id = vpo.id_podkategorie
INNER JOIN v_rav_umzprjggsc kr ON kr.id_prjgg = p.id 
INNER JOIN v_rav_umfpomerfinancovani pf ON pf.id_nositelpompf = vpo.id 
WHERE vpo.platnost = 'A'
  AND pf.id_zdrojfin = 415432 -- EFRR
  AND p.kod IN ('CZ.01.01.01/08/23_036/0005283')
GROUP BY c.nazev, gber.nazev, vpo.castkacelk_kc



---------------------------------------- Tohle je ostré --------------------


SELECT op."Název specifického cíle/opatření" as "Opatření" ,
       v."Číslo výzvy" ,
       p."Registrační číslo projektu",
       -- kr."Méně rozvinutý region",
       -- kr."Přechodové",
       -- pf."Doporučený poměr financování (%)",
       -- pf.id_kategorieregionu,
       -- pol."Částka celkem"
       pol.*


       -- SUM(CASE WHEN pf.id_kategorieregionu = 283463 THEN pf."Doporučený poměr financování (%)" * kr."Méně rozvinutý region"  --MRR
       --          WHEN pf.id_kategorieregionu = 283468 THEN pf."Doporučený poměr financování (%)" * kr."Přechodové" -- PR
       --     END) / 100 AS "EU NEINV částka" ,

       -- SUM(CASE WHEN pf.id_kategorieregionu = 283463 THEN kr."Méně rozvinutý region"  --MRR
       --          WHEN pf.id_kategorieregionu = 283468 THEN kr."Přechodové" -- PR
       --     END) / 100 AS "EU NEINV ZV částka"
       
       
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil
INNER JOIN rozpocet_hlavicka hl ON hl.id_nrozpocet = p.id AND hl."Aktuální" = 'A'
INNER JOIN rozpocet_skupina sr ON sr.id = hl.id_skupina
      -- INNER JOIN verejna_podpora vpo ON sr = p.id




-- INNER JOIN v_rav_umsciszakladni c ON c.id = vpo.id_rezimpodpory
-- LEFT JOIN v_rav_umsciszakladni gber ON gber.id = vpo.id_podkategorie


-- INNER JOIN projekt_specificky_cil kr ON kr.id_prjgg = p.id 
-- INNER JOIN pomery_financovani pf ON pf.id_nositelpompf = vpo.id 

-- neinvestiční, listové, platné, položky SR, rozpadají se na partnery s FP
INNER JOIN (SELECT id,
      	   	   id_verejnapodpora,
     	     	   id_predpis,
		   id_verejnapodpora
      FROM rozpocet_skupina_polozka

      WHERE "Investice / Neinvestice" = 0
      AND "Rozpad položky pro partnery s finančním příspěvkem" = 'A'
      AND "Listová" = 'A'
      AND "Platnost" = 'A'
      ) neinv ON neinv.id_predpis = sr.id
      -- AND vpo.id_verejnapodpora = neinv.id_verejnapodpora 

INNER JOIN (SELECT pol.id,
      	   	   pol.id_hlavicka,
		   pol.id_rozpis
      	    FROM rozpocet_polozka pol) rozpadlici ON
	    	 rozpadlici.id_hlavicka = hl.id AND rozpadlici.id_rozpis = neinv.id
INNER JOIN rozpocet_polozka pol ON pol.id_hierarchie = rozpadlici.id



WHERE p."Registrační číslo projektu" = 'CZ.01.01.01/08/23_036/0005283'

-- GROUP BY op."Název specifického cíle/opatření" ,
--        v."Číslo výzvy" ,
--        p."Registrační číslo projektu"
ORDER BY pol."Kód" 


----------------------------------------

-- Bude třeba doplnit něco jako rozpadá se na partnery => něco
-- ze skupiny rozpočtu načtu informaci o VPo a rozpadu na partnery, na VPo najdu záznama o subjektu?
--- rozpocet_polozka.id_rozpis = 0 - párovat podle rozpocet_polozka.id_hierarchie = rozpocet_polozka.id 
select * from rozpocet_polozka where 
id in (403299545, 403299543)


----------------------------------------


select * from rozpocet_skupina_polozka 
where "Rozpad položky pro partnery s finančním příspěvkem" = 'A'
----------------------------------------

-- Pokud mám rozpočtovou položku která se rozpadá na partnery => musím rozpadat taky

SELECT rsp."Kód" ,
       rsp."Název",
       rsp."Rozpad položky pro partnery s finančním příspěvkem" ,
       rsp."Listová"

FROM rozpocet_skupina_polozka rsp  

WHERE rsp."Rozpad položky pro partnery s finančním příspěvkem" = 'A'
AND rsp.id = 264663465
AND rsp."Listová" = 'A'


----------------------------------------


SELECT rp.*
FROM rozpocet_polozka rp
INNER JOIN rozpocet_hlavicka hl ON rp.id_hlavicka = hl.id AND hl."Aktuální" = 'A'
INNER JOIN projekt p ON hl.id_nrozpocet = p.id
INNER JOIN rozpocet_skupina sr ON sr.id = hl.id_skupina 
INNER JOIN rozpocet_skupina_polozka psr ON psr.id_predpis = sr.id AND (psr.id = rp.id_rozpis OR rp.id_rozpis = 0)

WHERE rp.id_rozpis = 264663465 -- položka 1.1.1.4 na skupině rozpočtu OP TAK 29 | Rozpočet Proof of Concept - výzva II. b)
AND rp.id_hlavicka = 403299535  -- omezeni na aktuální (+ podm) rozpočet na projektu  
AND p."Registrační číslo projektu" = 'CZ.01.01.01/08/23_036/0005283'


----------------------------------------
-- Jak zacházet s položkou rozpočtu, která se rozpadá na parntery? 

SELECT pol.*


FROM projekt p
INNER JOIN rozpocet_hlavicka hl ON hl.id_nrozpocet = p.id AND hl."Aktuální" = 'A'
INNER JOIN rozpocet_skupina sr ON sr.id = hl.id_skupina
--- najdi rozpotove polozky na skupine rozpoctu, které se mohou rozpadat na partnery
INNER JOIN rozpocet_skupina_polozka rsp ON rsp.id_predpis = sr.id AND rsp."Rozpad položky pro partnery s finančním příspěvkem" = 'A' AND rsp."Listová" = 'A' AND rsp."Platnost" = 'A'
INNER JOIN (SELECT pol.id,
      	   	   pol.id_hlavicka,
		   pol.id_rozpis
      	    FROM rozpocet_polozka pol) rozpadlici ON
	    	 rozpadlici.id_hlavicka = hl.id AND rozpadlici.id_rozpis = rsp.id
INNER JOIN rozpocet_polozka pol ON pol.id_hierarchie = rozpadlici.id




----------------------------------------

SELECT p."Registrační číslo projektu" ,
       s."Název subjektu" ,
       pol."Kód" ,
       pol."Název" "Název položky rozpočtu", 
       pol."Částka celkem" ,
       inv.inv "Investice",
       (CASE WHEN pf.id_kategorieregionu = 283463 THEN pf."Doporučený poměr financování (%)"
       	    WHEN pf.id_kategorieregionu = 283468 THEN pf."Doporučený poměr financování (%)"
           END) / 100 AS "Procento podpory" ,
       (CASE WHEN pf.id_kategorieregionu = 283463 THEN pf."Doporučený poměr financování (%)" * pol."Částka celkem"
       	    WHEN pf.id_kategorieregionu = 283468 THEN pf."Doporučený poměr financování (%)" * pol."Částka celkem"
           END) / 100 AS "Částka EU"

FROM projekt p
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null AND s.id_typsubjektuedit IN (413462, 413467) -- žadatel, partner s FP
INNER JOIN rozpocet_hlavicka hl ON hl.id_nrozpocet = p.id AND hl."Aktuální" = 'A'
INNER JOIN rozpocet_skupina sr ON sr.id = hl.id_skupina
-- co chci vědět o položkách rozpočtu na SR?
LEFT JOIN (SELECT  id,
      	   	   id_verejnapodpora,
     	     	   id_predpis,
		   "Investice / Neinvestice" inv
      FROM rozpocet_skupina_polozka
      WHERE  "Rozpad položky pro partnery s finančním příspěvkem" = 'A'
      -- "Investice / Neinvestice" = 1
      AND "Listová" = 'A'
      AND "Platnost" = 'A'
      ) inv ON inv.id_predpis = sr.id

-- INNER JOIN rozpocet_skupina_polozka rsp ON rsp.id_predpis = sr.id AND rsp."Rozpad položky pro partnery s finančním příspěvkem" = 'A'
INNER JOIN (SELECT pol.id,
      	   	   pol.id_hlavicka,
		   pol.id_rozpis
      	    FROM rozpocet_polozka pol) rozpadlici ON
	    	 rozpadlici.id_hlavicka = hl.id AND rozpadlici.id_rozpis = inv.id
INNER JOIN rozpocet_polozka pol ON pol.id_hierarchie = rozpadlici.id AND pol."Název" = s."Název subjektu" 
INNER JOIN ciselnik_kombinace_verejne_podpory kvpo ON inv.id_verejnapodpora = kvpo.id
INNER JOIN verejna_podpora vpo ON vpo.id_verejnapodpora = kvpo.id AND vpo.id_projekt = p.id AND vpo.id_nositel = s.id 
INNER JOIN pomery_financovani pf ON pf.id_nositelpompf = vpo.id AND pf.id_zdrojfin = 415432
--- chybi kategorie_regionu resp. projekt_sc




WHERE p."Registrační číslo projektu" = 'CZ.01.01.01/08/23_036/0005283'
-- AND  rsp.id = 264663465 -- omezení se na položku SR 1.1.1.4 NEBO rp.id_rozpis
-- AND (pol.id_rozpis = 264663465 OR pol.id_rozpis = 0) -- jsou to všechny, které ... ?
-- AND pol.id_hierarchie = 
   

----------------------------------------
Optimalizace Claude
----------------------------------------

SELECT 
    pl."Číslo platby" ,
    s."Název subjektu" "Příjemce",
    rf."Aktuální zůstatek k proplacení za projekt",
    rf."Předložené vyúčtování v toto ŽoP",
    rf."Schválené vyúčtování ZS/ŘO v této ŽoP",
    rf."Schváleno a proplaceno za projekt včetně této ŽoP"


-- -- Součty pro Investice = 0
--     SUM(CASE WHEN inv.inv = 0 THEN pol."Částka celkem" ELSE 0 END) AS "CZV-INV",
--     SUM(CASE WHEN inv.inv = 0 THEN 
--         (CASE 
--             WHEN pf.id_kategorieregionu IN (283463, 283468) 
--             THEN pf."Doporučený poměr financování (%)" * pol."Částka celkem" / 100
--             ELSE 0 
--         END) 
--         ELSE 0 END) AS "EU-INV",
    
--     -- Procento podpory INV
--     CASE 
--         WHEN SUM(CASE WHEN inv.inv = 0 THEN pol."Částka celkem" ELSE 0 END) > 0
--         THEN SUM(CASE WHEN inv.inv = 0 THEN 
--                 (CASE 
--                     WHEN pf.id_kategorieregionu IN (283463, 283468) 
--                     THEN pf."Doporučený poměr financování (%)" * pol."Částka celkem" / 100
--                     ELSE 0 
--                 END) 
--                 ELSE 0 END) / 
--              SUM(CASE WHEN inv.inv = 0 THEN pol."Částka celkem" ELSE 0 END) * 100
--         ELSE 0 
--     END AS "Procento podpory INV",
    
--     -- Součty pro Investice = 1
--     SUM(CASE WHEN inv.inv = 1 THEN pol."Částka celkem" ELSE 0 END) AS "CZV-NEINV",
--     SUM(CASE WHEN inv.inv = 1 THEN 
--         (CASE 
--             WHEN pf.id_kategorieregionu IN (283463, 283468) 
--             THEN pf."Doporučený poměr financování (%)" * pol."Částka celkem" / 100
--             ELSE 0 
--         END) 
--         ELSE 0 END) AS "EU-NEINV",
    
--     -- Procento podpory NEINV
--     CASE 
--         WHEN SUM(CASE WHEN inv.inv = 1 THEN pol."Částka celkem" ELSE 0 END) > 0
--         THEN SUM(CASE WHEN inv.inv = 1 THEN 
--                 (CASE 
--                     WHEN pf.id_kategorieregionu IN (283463, 283468) 
--                     THEN pf."Doporučený poměr financování (%)" * pol."Částka celkem" / 100
--                     ELSE 0 
--                 END) 
--                 ELSE 0 END) / 
--              SUM(CASE WHEN inv.inv = 1 THEN pol."Částka celkem" ELSE 0 END) * 100
--         ELSE 0 
--     END AS "Procento podpory NEINV"

FROM projekt p
INNER JOIN subjekt s ON s.id_prjgg = p.id 
    AND s."Neplatný od" IS NULL 
    AND s.id_typsubjektuedit IN (413462, 413467)
INNER JOIN rozpocet_hlavicka hl ON hl.id_nrozpocet = p.id 
    AND hl."Aktuální" = 'A'
INNER JOIN rozpocet_skupina sr ON sr.id = hl.id_skupina
LEFT JOIN (
    SELECT id,
           id_verejnapodpora,
           id_predpis,
           "Investice / Neinvestice" AS inv
    FROM rozpocet_skupina_polozka
    WHERE "Rozpad položky pro partnery s finančním příspěvkem" = 'A'
        AND "Listová" = 'A'
        AND "Platnost" = 'A'
) inv ON inv.id_predpis = sr.id
INNER JOIN (
    SELECT pol.id,
           pol.id_hlavicka,
           pol.id_rozpis
    FROM rozpocet_polozka pol
) rozpadlici ON rozpadlici.id_hlavicka = hl.id 
    AND rozpadlici.id_rozpis = inv.id
INNER JOIN rozpocet_polozka pol ON pol.id_hierarchie = rozpadlici.id 
    AND pol."Název" = s."Název subjektu" 
INNER JOIN ciselnik_kombinace_verejne_podpory kvpo ON inv.id_verejnapodpora = kvpo.id
INNER JOIN verejna_podpora vpo ON vpo.id_verejnapodpora = kvpo.id 
    AND vpo.id_projekt = p.id 
    AND vpo.id_nositel = s.id 
INNER JOIN pomery_financovani pf ON pf.id_nositelpompf = vpo.id 
    AND pf.id_zdrojfin = 415432
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id 
INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel AND cuk."Kód" IN ('1','1a','1b','7','7a','7b','7c','13','13a','13b','13c')




WHERE p."Registrační číslo projektu" = 'CZ.01.01.01/08/23_036/0005283'

-- GROUP BY pl."Číslo platby" ,
--       	 s."Název subjektu" "Příjemce",



--------------------------------------------------

WITH agregace AS (
    SELECT 
        p."Registrační číslo projektu",
        
        -- Součty pro Investice = 0
        SUM(CASE WHEN inv.inv = 0 THEN 
            (CASE 
                WHEN pf.id_kategorieregionu IN (283463, 283468) 
                THEN pf."Doporučený poměr financování (%)" * pol."Částka celkem" / 100
                ELSE 0 
            END) 
            ELSE 0 END) AS "EU-INV",
        
        -- Součty pro Investice = 1
        SUM(CASE WHEN inv.inv = 1 THEN 
            (CASE 
                WHEN pf.id_kategorieregionu IN (283463, 283468) 
                THEN pf."Doporučený poměr financování (%)" * pol."Částka celkem" / 100
                ELSE 0 
            END) 
            ELSE 0 END) AS "EU-NEINV",
        
        -- Procento podpory INV
        CASE 
            WHEN SUM(CASE WHEN inv.inv = 0 THEN pol."Částka celkem" ELSE 0 END) > 0
            THEN SUM(CASE WHEN inv.inv = 0 THEN 
                    (CASE 
                        WHEN pf.id_kategorieregionu IN (283463, 283468) 
                        THEN pf."Doporučený poměr financování (%)" * pol."Částka celkem" / 100
                        ELSE 0 
                    END) 
                    ELSE 0 END) / 
                 SUM(CASE WHEN inv.inv = 0 THEN pol."Částka celkem" ELSE 0 END) * 100
            ELSE 0 
        END AS "Procento_INV",
        
        -- Procento podpory NEINV
        CASE 
            WHEN SUM(CASE WHEN inv.inv = 1 THEN pol."Částka celkem" ELSE 0 END) > 0
            THEN SUM(CASE WHEN inv.inv = 1 THEN 
                    (CASE 
                        WHEN pf.id_kategorieregionu IN (283463, 283468) 
                        THEN pf."Doporučený poměr financování (%)" * pol."Částka celkem" / 100
                        ELSE 0 
                    END) 
                    ELSE 0 END) / 
                 SUM(CASE WHEN inv.inv = 1 THEN pol."Částka celkem" ELSE 0 END) * 100
            ELSE 0 
        END AS "Procento_NEINV"

    FROM projekt p
    INNER JOIN subjekt s ON s.id_prjgg = p.id 
        AND s."Neplatný od" IS NULL 
        AND s.id_typsubjektuedit IN (413462, 413467)
    INNER JOIN rozpocet_hlavicka hl ON hl.id_nrozpocet = p.id 
        AND hl."Aktuální" = 'A'
    INNER JOIN rozpocet_skupina sr ON sr.id = hl.id_skupina
    LEFT JOIN (
        SELECT id,
               id_verejnapodpora,
               id_predpis,
               "Investice / Neinvestice" AS inv
        FROM rozpocet_skupina_polozka
        WHERE "Rozpad položky pro partnery s finančním příspěvkem" = 'A'
            AND "Listová" = 'A'
            AND "Platnost" = 'A'
    ) inv ON inv.id_predpis = sr.id
    INNER JOIN (
        SELECT pol.id,
               pol.id_hlavicka,
               pol.id_rozpis
        FROM rozpocet_polozka pol
    ) rozpadlici ON rozpadlici.id_hlavicka = hl.id 
        AND rozpadlici.id_rozpis = inv.id
    INNER JOIN rozpocet_polozka pol ON pol.id_hierarchie = rozpadlici.id 
        AND pol."Název" = s."Název subjektu" 
    INNER JOIN ciselnik_kombinace_verejne_podpory kvpo ON inv.id_verejnapodpora = kvpo.id
    INNER JOIN verejna_podpora vpo ON vpo.id_verejnapodpora = kvpo.id 
        AND vpo.id_projekt = p.id 
        AND vpo.id_nositel = s.id 
    INNER JOIN pomery_financovani pf ON pf.id_nositelpompf = vpo.id 
        AND pf.id_zdrojfin = 415432
    --- Chybí kategorie regionu
    
    WHERE p."Registrační číslo projektu" = 'CZ.01.01.01/08/23_036/0005283'

    GROUP BY p."Registrační číslo projektu"
)
SELECT 
    "Registrační číslo projektu",
    "Informace z projektu"
FROM (
    SELECT 
        "Registrační číslo projektu",
        CAST("EU-INV" + "EU-NEINV" AS VARCHAR) AS "Informace z projektu",
        1 AS poradi
    FROM agregace

    UNION ALL

    SELECT 
        "Registrační číslo projektu",
        CAST("EU-INV" AS VARCHAR) AS "Informace z projektu",
        2 AS poradi
    FROM agregace

    UNION ALL

    SELECT 
        "Registrační číslo projektu",
        CAST("EU-NEINV" AS VARCHAR) AS "Informace z projektu",
        3 AS poradi
    FROM agregace

    UNION ALL

    SELECT 
        "Registrační číslo projektu",
        CONCAT(CAST(ROUND("Procento_INV", 2) AS VARCHAR), '; ', CAST(ROUND("Procento_NEINV", 2) AS VARCHAR)) AS "Informace z projektu",
        4 AS poradi
    FROM agregace
) AS vysledky
ORDER BY "Registrační číslo projektu", poradi


----------------------------------------
-- prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 


SELECT	-- investice 		      
	max(CASE WHEN pzfinv.id_kategorieregionu in (283463, 283468)/* MRR, PR */ AND pzfinv."Investice (A)/Neinvestice (N)" = 'A' THEN pzfinv."Příspěvek Unie"
	     END) "EU-INV",
	-- neinvestice 		      
	max(CASE WHEN pzfinv.id_kategorieregionu in (283463, 283468)/* MRR, PR */ AND pzfinv."Investice (A)/Neinvestice (N)" = 'N' THEN pzfinv."Příspěvek Unie"
	     END) "EU-NEINV" ,
	pf."Příspěvek Unie" "EU" ,
	pf."Příspěvek společenství (% veřejných)" ,






FROM projekt p 
INNER JOIN prehled_zdroju_financovani_sckr_investice pzfinv ON pzfinv.id_projekt = p.id 
      AND id_faze = 99991000000050005
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id 
INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel AND cuk."Kód" IN ('7','7a','7b','7c')



WHERE p."Registrační číslo projektu" = 'CZ.01.01.01/08/23_036/0005283'



GROUP BY pf."Příspěvek Unie" ,
	pf."Příspěvek společenství (% veřejných)" 


---------------------------------------- Claude optimalizace ------------------------------


WITH data AS (
    SELECT p."Registrační číslo projektu" , 
        max(CASE WHEN pzfinv.id_kategorieregionu in (283463, 283468) AND pzfinv."Investice (A)/Neinvestice (N)" = 'A' 
                 THEN pzfinv."Příspěvek Unie" END) as "EU-INV",
        max(CASE WHEN pzfinv.id_kategorieregionu in (283463, 283468) AND pzfinv."Investice (A)/Neinvestice (N)" = 'N' 
                 THEN pzfinv."Příspěvek Unie" END) as "EU-NEINV",
        pf."Příspěvek Unie" as "EU",
        pf."Příspěvek společenství (% veřejných)" as "PROCENTO"
    FROM projekt p 
    INNER JOIN prehled_zdroju_financovani_sckr_investice pzfinv ON pzfinv.id_projekt = p.id 
          AND id_faze = 99991000000050005
    INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005
    WHERE p."Registrační číslo projektu" = 'CZ.01.01.01/08/23_036/0005283'
    GROUP BY p."Registrační číslo projektu" , pf."Příspěvek Unie", pf."Příspěvek společenství (% veřejných)"
)
SELECT "Registrační číslo projektu",
       '7' as "Ukazatel",
       "EU" as "Aktuální rozpis financování projektu"
FROM data

UNION ALL

SELECT "Registrační číslo projektu",
       '7a' as "Ukazatel",
       "EU-INV" as "Aktuální rozpis financování projektu"
FROM data  

UNION ALL

SELECT "Registrační číslo projektu" ,
       '7b' as "Ukazatel",
       "EU-NEINV" as "Aktuální rozpis financování projektu"
FROM data

UNION ALL

SELECT "Registrační číslo projektu" ,
       '7c' as "Ukazatel",
       "PROCENTO" as "Aktuální rozpis financování projektu"
FROM data


---------------------------------------- Doplnění ŽoP ------------------------------

SELECT p."Registrační číslo projektu" ,
       rf."Předložené vyúčtování v toto ŽoP",
       rf."Schválené vyúčtování ZS/ŘO v této ŽoP",
       rf."Schváleno a proplaceno za projekt včetně této ŽoP" ,
       rf."Aktuální zůstatek k proplacení za projekt" 

FROM projekt p 
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id 
INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel AND cuk."Kód" IN ('7','7a','7b','7c')

WHERE p."Registrační číslo projektu" in ('CZ.01.01.01/01/22_002/0000353','CZ.01.01.01/08/22_001/0000349','CZ.01.01.01/08/23_036/0005283')
-- sem doplň podminku že pl."Pořadí finančního plánu" =  base_data.posledni_zop



ORDER BY p."Registrační číslo projektu", propl."Kód"  




----------------------------- Starší ZoP - optimaizace Claude ----------------------------------------



WITH base_data AS (
    -- Základní agregace dat
    SELECT 
        SUM(rf."Schválené vyúčtování ZS/ŘO v této ŽoP") AS suma,
        cuk."Kód",
        p.id AS projekt_id,
        p."Registrační číslo projektu" ,
	max(pl."Pořadí finančního plánu") posledni_zop 
    FROM projekt p
    INNER JOIN platba pl ON pl.id_nositelplatby = p.id
    INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id
    INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk 
        ON cuk.id = rf.id_ukazatel 
        AND cuk."Kód" IN ('1','7','7a','7b')
    WHERE p."Registrační číslo projektu" IN (
        'CZ.01.01.01/01/22_002/0000353',
        'CZ.01.01.01/08/22_001/0000349',
        'CZ.01.01.01/08/23_036/0005283'
    )
    GROUP BY cuk."Kód", p.id, p."Registrační číslo projektu"
),
suma_kod_1 AS (
    -- Získání sumy pro kód 1 pro každý projekt
    SELECT projekt_id, suma AS suma_1
    FROM base_data
    WHERE "Kód" = '1'
),
suma_kod_7 AS (
    -- Získání sumy pro kód 7 pro každý projekt
    SELECT projekt_id, suma AS suma_7
    FROM base_data
    WHERE "Kód" = '7'
)
-- Finální výsledek
SELECT 
    suma,
    "Kód",
    projekt_id,
    "Registrační číslo projektu"
FROM base_data
WHERE "Kód" IN ('7','7a','7b')

UNION ALL

-- Přidání vypočítaného řádku 7c
SELECT 
    CASE 
        WHEN s1.suma_1 > 0 THEN ROUND(100*s7.suma_7 / s1.suma_1, 2)
        ELSE NULL
    END AS suma,
    '7c' AS "Kód",
    s7.projekt_id,  -- Opraveno: musí být s7.projekt_id
    bd."Registrační číslo projektu"
FROM suma_kod_7 s7
INNER JOIN suma_kod_1 s1 ON s7.projekt_id = s1.projekt_id
INNER JOIN (SELECT DISTINCT projekt_id, "Registrační číslo projektu" FROM base_data) bd 
    ON bd.projekt_id = s7.projekt_id
ORDER BY projekt_id, "Kód";






------------------------------ Údaje z ŽoP přepsáno Claude - jde o výzvu bez podané 2. ŽoP ------------------------------


WITH data AS (
    SELECT p."Registrační číslo projektu" , 
        max(CASE WHEN pzfinv.id_kategorieregionu in (283463, 283468) AND pzfinv."Investice (A)/Neinvestice (N)" = 'A' 
                 THEN pzfinv."Příspěvek Unie" END) as "EU-INV",
        max(CASE WHEN pzfinv.id_kategorieregionu in (283463, 283468) AND pzfinv."Investice (A)/Neinvestice (N)" = 'N' 
                 THEN pzfinv."Příspěvek Unie" END) as "EU-NEINV",
        pf."Příspěvek Unie" as "EU",
        pf."Příspěvek společenství (% veřejných)" as "PROCENTO"
    FROM projekt p 
    INNER JOIN prehled_zdroju_financovani_sckr_investice pzfinv ON pzfinv.id_projekt = p.id 
          AND id_faze = 99991000000050005
    INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005
    WHERE p."Registrační číslo projektu" IN (
                'CZ.01.01.01/01/22_002/0000353',
                'CZ.01.01.01/08/22_001/0000349'
	        'CZ.01.01.01/08/23_036/0005283')

    GROUP BY p."Registrační číslo projektu" , pf."Příspěvek Unie", pf."Příspěvek společenství (% veřejných)"
),
ukazatele AS (
    SELECT "Registrační číslo projektu",
           'EU' as "Ukazatel",
           "EU" as "Aktuální rozpis financování projektu",
           '7' as kod,
           1 as poradi
    FROM data
    UNION ALL
    SELECT "Registrační číslo projektu",
           'EU-INV' as "Ukazatel",
           "EU-INV" as "Aktuální rozpis financování projektu",
           '7a' as kod,
           2 as poradi
    FROM data  
    UNION ALL
    SELECT "Registrační číslo projektu",
           'EU-NEINV' as "Ukazatel",
           "EU-NEINV" as "Aktuální rozpis financování projektu",
           '7b' as kod,
           3 as poradi
    FROM data
    UNION ALL
    SELECT "Registrační číslo projektu",
           '%' as "Ukazatel",
           "PROCENTO" as "Aktuální rozpis financování projektu",
           '7c' as kod,
           4 as poradi
    FROM data
),
zop_data AS (
    SELECT 
        cuk."Kód",
        rf."Předložené vyúčtování v toto ŽoP",
        rf."Schválené vyúčtování ZS/ŘO v této ŽoP",
        rf."Schváleno a proplaceno za projekt včetně této ŽoP",
        rf."Aktuální zůstatek k proplacení za projekt",
        ROW_NUMBER() OVER (ORDER BY cuk."Kód") as poradi
    FROM projekt p 
    INNER JOIN platba pl ON pl.id_nositelplatby = p.id
    INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id 
    INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel AND cuk."Kód" IN ('7','7a','7b','7c')
    WHERE p."Registrační číslo projektu" IN (
            'CZ.01.01.01/01/22_002/0000353',
            'CZ.01.01.01/08/22_001/0000349'
	    'CZ.01.01.01/08/23_036/0005283')

)
SELECT 
    u."Registrační číslo projektu",
    u."Ukazatel",
    u."Aktuální rozpis financování projektu",
    z."Předložené vyúčtování v toto ŽoP" "Požadováno příjemcem v této ŽoP",
    z."Schválené vyúčtování ZS/ŘO v této ŽoP",
    z."Aktuální zůstatek k proplacení za projekt" "Aktuální disponibilní alokace projektu včetně této ŽoP",
    z."Schváleno a proplaceno za projekt včetně této ŽoP" ,
    0 "Aktuální zůstatek k proplacení za projekt"
FROM ukazatele u
INNER JOIN zop_data z ON u.kod = z."Kód"
ORDER BY u.poradi




---------------------------------------- Optimalizace Claude - info z posledení ZoP + soucet předchozích ----------




WITH base_data AS (
    -- Základní agregace dat
    SELECT 
        SUM(rf."Schválené vyúčtování ZS/ŘO v této ŽoP") AS suma,
        cuk."Kód",
        p.id AS projekt_id,
        p."Registrační číslo projektu",
        MAX(pl."Pořadí finančního plánu") AS posledni_zop 
    FROM projekt p
    INNER JOIN platba pl ON pl.id_nositelplatby = p.id
    INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id
    INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk 
        ON cuk.id = rf.id_ukazatel 
        AND cuk."Kód" IN ('1','7','7a','7b')
    WHERE p."Registrační číslo projektu" IN (
        'CZ.01.01.01/01/22_002/0000353',
        'CZ.01.01.01/08/22_001/0000349',
        'CZ.01.01.01/08/23_036/0005283'
    )
    GROUP BY cuk."Kód", p.id, p."Registrační číslo projektu"
),
suma_kod_1 AS (
    -- Získání sumy pro kód 1 pro každý projekt
    SELECT projekt_id, suma AS suma_1
    FROM base_data
    WHERE "Kód" = '1'
),
suma_kod_7 AS (
    -- Získání sumy pro kód 7 pro každý projekt
    SELECT projekt_id, suma AS suma_7
    FROM base_data
    WHERE "Kód" = '7'
),
starsi_zop AS (
    -- Finální výsledek ze starších ŽoP
    SELECT 
        suma AS "Schváleno a proplaceno v této ŽoP",
        "Kód",
        projekt_id,
        "Registrační číslo projektu",
        posledni_zop
    FROM base_data
    WHERE "Kód" IN ('7','7a','7b')
    
    UNION ALL
    
    -- Přidání vypočítaného řádku 7c
    SELECT 
        CASE 
            WHEN s1.suma_1 > 0 THEN ROUND(100*s7.suma_7 / s1.suma_1, 2)
            ELSE NULL
        END AS "Schváleno a proplaceno v této ŽoP",
        '7c' AS "Kód",
        s7.projekt_id,
        bd."Registrační číslo projektu",
        bd.posledni_zop
    FROM suma_kod_7 s7
    INNER JOIN suma_kod_1 s1 ON s7.projekt_id = s1.projekt_id
    INNER JOIN (SELECT DISTINCT projekt_id, "Registrační číslo projektu", posledni_zop FROM base_data) bd 
        ON bd.projekt_id = s7.projekt_id
),
posledni_zop_cislo AS (
    -- Získání čísla poslední ŽoP pro každý projekt
    SELECT DISTINCT projekt_id, posledni_zop
    FROM base_data
)
-- Finální spojení
SELECT 
    p."Registrační číslo projektu",
    pz.posledni_zop AS "Pořadí ŽoP",
    cuk."Kód" AS "Ukazatel",



    rf."Předložené vyúčtování v toto ŽoP" "Požadováno příjemcem v této ŽoP",
    rf."Schválené vyúčtování ZS/ŘO v této ŽoP",
    0 "Aktuální disponibilní alokace projektu včetně této ŽoP",
    sz."Schváleno a proplaceno v této ŽoP" "Schváleno a proplaceno za projekt včetně této ŽoP" ,
    rf."Aktuální zůstatek k proplacení za projekt"

FROM projekt p 
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id 
INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk 
    ON cuk.id = rf.id_ukazatel 
    AND cuk."Kód" IN ('7','7a','7b','7c')
INNER JOIN posledni_zop_cislo pz 
    ON pz.projekt_id = p.id 
    AND pl."Pořadí finančního plánu" = pz.posledni_zop  -- Podmínka pro poslední ŽoP
LEFT JOIN starsi_zop sz 
    ON sz."Registrační číslo projektu" = p."Registrační číslo projektu" 
    AND sz."Kód" = cuk."Kód"
WHERE p."Registrační číslo projektu" IN (
    'CZ.01.01.01/01/22_002/0000353',
    'CZ.01.01.01/08/22_001/0000349',
    'CZ.01.01.01/08/23_036/0005283'
)
ORDER BY 
    p."Registrační číslo projektu", 
    CASE cuk."Kód"
        WHEN '7' THEN 1
        WHEN '7a' THEN 2
        WHEN '7b' THEN 3
        WHEN '7c' THEN 4
    END;
