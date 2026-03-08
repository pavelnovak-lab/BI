WITH IndikatoryRanked AS (
    
    SELECT 
        IH.id_nositelindi,
        ind."Kód NČI 2021+",
        ind."Název indikátoru CZ",
        IH."Cílová hodnota",
        IH."Čistá dosažená hodnota",
        ROW_NUMBER() OVER (PARTITION BY IH.id_nositelindi ORDER BY ind."Kód NČI 2021+", ind.id) as rn
 	FROM indikator_hodnota IH

'101022', '243010', '426101', '426201', '401601', '401701'




    INNER JOIN indikator ind ON IH.id_indikator = ind.id
)

SELECT 
    v."Číslo výzvy",
    p."Registrační číslo projektu",
    p."Název projektu CZ",
    s."Název subjektu" AS "Název příjemce",
    s."IČ/rodné číslo",
    csw."Kód" AS "Kód stavu projektu",

    -- FINANCOVÁNÍ
    pzf."Celkové zdroje připadající na způsobilé výdaje",
    pzf."Příspěvek Unie",
    pzf."Soukromé zdroje",
    PF."Doporučený poměr financování (%)" AS "Poměr financování z vlastních zdrojů",
    
    -- TERMÍNY
    p."Předpokládané datum zahájení",
    p."Předpokládané datum ukončení",
    p."Skutečné datum zahájení",
    p."Skutečné datum ukončení",
    MAX(CASE WHEN csw."Kód" = 'PP42' THEN p."Datum změny stavu" ELSE NULL END) AS "Datum schválení (PP42)",

    -- PLATBY A OBEC
    MAX(cisjednot."Název") AS "Místo realizace - Obec",
    MAX(cs."VyuctCZVCelk") AS "VyuctCZVCelk",

  
    
    -- INDIKÁTOR 1
    MAX(CASE WHEN ir.rn = 1 THEN ir."Kód NČI 2021+" END) AS "Ind1_Kód",
    MAX(CASE WHEN ir.rn = 1 THEN ir."Název indikátoru CZ" END) AS "Ind1_Název",
    MAX(CASE WHEN ir.rn = 1 THEN ir."Cílová hodnota" END) AS "Ind1_Cíl",
    MAX(CASE WHEN ir.rn = 1 THEN ir."Čistá dosažená hodnota" END) AS "Ind1_Dos",

    -- INDIKÁTOR 2
    MAX(CASE WHEN ir.rn = 2 THEN ir."Kód NČI 2021+" END) AS "Ind2_Kód",
    MAX(CASE WHEN ir.rn = 2 THEN ir."Název indikátoru CZ" END) AS "Ind2_Název",
    MAX(CASE WHEN ir.rn = 2 THEN ir."Cílová hodnota" END) AS "Ind2_Cíl",
    MAX(CASE WHEN ir.rn = 2 THEN ir."Čistá dosažená hodnota" END) AS "Ind2_Dos",

   MAX(CASE WHEN ir.rn = 3 THEN ir."Kód NČI 2021+" END) AS "Ind3_Kód",
    MAX(CASE WHEN ir.rn = 3 THEN ir."Název indikátoru CZ" END) AS "Ind3_Název",
    MAX(CASE WHEN ir.rn = 3 THEN ir."Cílová hodnota" END) AS "Ind3_Cíl",
    MAX(CASE WHEN ir.rn = 3 THEN ir."Čistá dosažená hodnota" END) AS "Ind3_Dos",
    
    MAX(CASE WHEN ir.rn = 4 THEN ir."Kód NČI 2021+" END) AS "Ind4_Kód",
    MAX(CASE WHEN ir.rn = 4 THEN ir."Název indikátoru CZ" END) AS "Ind4_Název",
    MAX(CASE WHEN ir.rn = 4 THEN ir."Cílová hodnota" END) AS "Ind4_Cíl",
    MAX(CASE WHEN ir.rn = 4 THEN ir."Čistá dosažená hodnota" END) AS "Ind4_Dos"

FROM projekt AS p
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" IS NULL
INNER JOIN ciselnik_typ_subjektu AS CTS ON s.id_typsubjektuedit = CTS.id
INNER JOIN vyzva AS v ON p.id_vyzva = v.id
INNER JOIN ciselnik_stav_workflow AS csw ON p.id_wfstav = csw.id
INNER JOIN prehled_zdroju_financovani_sckr AS pzf ON p.id = pzf.id_projekt AND pzf.id_faze = '99991000000010005'
INNER JOIN pomery_financovani AS PF ON pf.id_nositelpompf = p.id
INNER JOIN umisteni AS u ON p.id = u.id_projekt
INNER JOIN ciselnik_uzemni_jednotky AS cisjednot ON u.id_uzemnijednotky = cisjednot.id

-- Tady napojíme ty očísloné indikátory
LEFT JOIN IndikatoryRanked ir ON p.id = ir.id_nositelindi

-- Platby
LEFT JOIN platba AS platba ON p.id = platba.id_nositelplatby
LEFT JOIN castky_schvaleno AS cs ON platba.id_schvalenecastky = cs.id

WHERE v."Číslo výzvy" IN ('01_23_029','01_25_068','01_23_028')
  AND p."Registrační číslo projektu" IS NOT NULL
  AND csw."Kód" NOT LIKE 'PN%'
  AND CTS."Název" = 'Žadatel/příjemce'
  AND PF."Vlastní prostředky financování" = 'A'
--  AND platba."Číslo platby" IS NOT NULL

-- Tohle je klíčové pro sloučení do jednoho řádku:
GROUP BY 
    v."Číslo výzvy", p."Registrační číslo projektu", p."Název projektu CZ",
    s."Název subjektu", s."IČ/rodné číslo", csw."Kód",
    pzf."Celkové zdroje připadající na způsobilé výdaje", pzf."Příspěvek Unie", pzf."Soukromé zdroje",
    PF."Doporučený poměr financování (%)",
    p."Předpokládané datum zahájení", p."Předpokládané datum ukončení", 
    p."Skutečné datum zahájení", p."Skutečné datum ukončení"

ORDER BY p."Registrační číslo projektu" ASC


------------------------------

SELECT p.id,
       count(pl.id) pocetzop 

FROM projekt p
INNER JOIN platba pl ON pl.id_nositelplatby = p.id 
INNER JOIN vyzva v ON v.id = p.id_vyzva

WHERE v."Číslo výzvy" IN ('01_23_029','01_25_068','01_23_028')

ORDER BY pocetzop DESC 
