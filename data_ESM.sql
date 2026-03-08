SELECT * FROM (
SELECT DISTINCT p."Registraèní èíslo projektu" ,
       p."Zkrácený název projektu" AS "Zkrácený název projektu",       
       'Skuteèný majitel' AS  "Typ subjektu" ,
       p."IÈ" as "ICO",
       p."ZADATEL",
       adresa."Adresa uvedená textovì" AS  "Adresa ¾adatele/pøíjemce",
--- ovìøení, jestli existuje záznam v ESM, pokud ano, nehledám jiné subjekty skuteèných majitelù v subjektech
       COALESCE(esm."Jméno", subj."Jméno") AS "Jméno",
       COALESCE(esm."Pøíjmení", subj."Pøíjmení") AS "Pøíjmení",
       COALESCE(esm."DnESM", subj."DN") AS "Datum narození"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel
INNER JOIN "ISUM"."V_BI_UMSRSVERZEADRESY" adresa ON adresa."ID" = vs."ID_OFICIALNIADRESA"
LEFT JOIN ( SELECT ggvs.id_prjgg id_projekt,
		    ggvs.id id_subjekt,
		    ggvs.id_typsubjektuEdit,
		    ggvs."DATUMNAROZENI#Datum narození" AS "DN",
		    ggvs."ID_OFICIALNIADRESA" AS "ADRESAG",
		    ggvs."Jméno",
		    ggvs."Pøíjmení"

	    FROM "ISUM"."V_BI_UMZPRJGGVS" ggvs -- ON p."ID" = ggvs."ID_PRJGG" AND ggvs.neplatny is null

	    WHERE ggvs.id_typsubjektuEdit = 1469765679 -- skuteèný majitel ze subjektu
	    AND ggvs.neplatny is null
	    -- AND ggvs.id_prjgg = 1623269314
	    ) subj ON subj.id_projekt = p.id 
LEFT JOIN (SELECT   p."Registraèní èíslo projektu" ,
		    p.id AS id_projekt,
		    ggvsesm.id_prjggvs id_subjekt_z_esm,
		    ggvsesm."Datum narození" as "DnESM",
		    ggvsesm."Adresa" AS "AdresaESM" ,
		    ggvsesm."Jméno",
		    ggvsesm."Pøíjmení"

	    FROM isum.v_bi_UmzProjekt p 
	    LEFT JOIN "ISUM"."V_BI_UMZPRJGGVSESM" ggvsesm ON ggvsesm."ID_PRJGGVS" = p.id_zadatel

	    WHERE ggvsesm."Den zániku" is null
	    -- AND p.id = 1623269314
	    ) esm ON esm.id_projekt = p.id 
WHERE p.id_vyzva IN ('1591630825','1591648828')
AND p."KODWFSTAV" NOT LIKE 'PN%'

UNION ALL

SELECT p."Registraèní èíslo projektu" ,
       p."Zkrácený název projektu" AS "Zkrácený název projektu",       
       'Koneèný pøíjemce' AS "Typ subjektu" ,
       p."IÈ" as "ICO",
       p."ZADATEL",
       adresa."Adresa uvedená textovì" AS  "Adresa ¾adatele/pøíjemce",
       null AS "Jméno",
       null AS "Pøíjmení",
       null AS "Datum narození"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel
INNER JOIN "ISUM"."V_BI_UMSRSVERZEADRESY" adresa ON adresa."ID" = vs.ID_OFICIALNIADRESA

WHERE p.id_vyzva IN ('1591630825','1591648828')
AND p."KODWFSTAV" NOT LIKE 'PN%'
)
ORDER BY p."Registraèní èíslo projektu" , "Typ subjektu"
----------------------------------------


-- Optimalizovaná verze
WITH projekt_base AS (
    -- Základní data projektu s adresou - naèteme jen jednou
    SELECT DISTINCT 
        p.id,
        p."Registraèní èíslo projektu",
        p."Zkrácený název projektu",
        p."IÈ",
        p."ZADATEL",
        p.id_zadatel,
        adresa."Adresa uvedená textovì" AS "Adresa ¾adatele/pøíjemce"
    FROM isum.v_bi_UmzProjekt p 
    INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg = p.id 
        AND vs.neplatny IS NULL 
        AND vs.id_typsubjektu = 300784 
        AND vs.id_typsubjektuEdit = 300798
    INNER JOIN "ISUM"."V_BI_UMSRSVERZEADRESY" adresa ON adresa."ID" = vs."ID_OFICIALNIADRESA"
    WHERE p.id_vyzva IN ('1591630825','1591648828')
),
skutecny_majitel_data AS (
    -- Skuteèní majitelé ze subjektù
    SELECT 
        pb.id,
        pb."Registraèní èíslo projektu",
        pb."Zkrácený název projektu",
        'Skuteèný majitel' AS "Typ subjektu",
        pb."IÈ",
        pb."ZADATEL",
        pb."Adresa ¾adatele/pøíjemce",
        COALESCE(esm."Jméno", subj."Jméno") AS "Jméno",
        COALESCE(esm."Pøíjmení", subj."Pøíjmení") AS "Pøíjmení",
        COALESCE(esm."DnESM", subj."DN") AS "Datum narození"
    FROM projekt_base pb
    LEFT JOIN (
        SELECT DISTINCT
            ggvs.id_prjgg,
            ggvs."DATUMNAROZENI#Datum narození" AS "DN",
            ggvs."Jméno",
            ggvs."Pøíjmení"
        FROM "ISUM"."V_BI_UMZPRJGGVS" ggvs
        WHERE ggvs.id_typsubjektuEdit = 1469765679
          AND ggvs.neplatny IS NULL
          AND ggvs.id_prjgg IN (SELECT id FROM projekt_base) -- Omezení na relevantní projekty
    ) subj ON subj.id_prjgg = pb.id
    LEFT JOIN (
        SELECT DISTINCT
            p.id,
            ggvsesm."Datum narození" AS "DnESM",
            ggvsesm."Jméno",
            ggvsesm."Pøíjmení"
        FROM projekt_base p
        INNER JOIN "ISUM"."V_BI_UMZPRJGGVSESM" ggvsesm ON ggvsesm."ID_PRJGGVS" = p.id_zadatel
        WHERE ggvsesm."Den zániku" IS NULL
    ) esm ON esm.id = pb.id
),
konecny_prijemce_data AS (
    -- Koneèní pøíjemci
    SELECT 
        pb."Registraèní èíslo projektu",
        pb."Zkrácený název projektu",
        'Koneèný pøíjemce' AS "Typ subjektu",
        pb."IÈ",
        pb."ZADATEL",
        pb."Adresa ¾adatele/pøíjemce",
        NULL AS "Jméno",
        NULL AS "Pøíjmení",
        NULL AS "Datum narození"
    FROM projekt_base pb
    WHERE EXISTS (
        SELECT 1 FROM isum.v_bi_UmzProjekt p2 
        WHERE p2.id = pb.id 
          AND p2."KODWFSTAV" NOT LIKE 'PN%'
    )
)
-- Finální výsledek
SELECT * FROM skutecny_majitel_data
UNION ALL
SELECT * FROM konecny_prijemce_data
ORDER BY 
    "Registraèní èíslo projektu",
    "Typ subjektu"
