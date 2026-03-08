SELECT
    -- "V_BI_UMZPROJEKT"."Registrační číslo projektu" AS "Registrační číslo projektu",
    -- "V_BI_UMZPROJEKT"."WFSTAV" AS "Stav Projektu",
    "V_BI_UMZVYZVA"."Číslo výzvy" AS "Číslo výzvy",
    -- "V_BI_UMPPLATBA"."Číslo žádosti o platbu" AS "Číslo žádosti o platbu",
    -- "V_BI_UMPPLATBA"."DATUMVYSTAVENI" AS "DATUMVYSTAVENI",
    -- "V_BI_UMPPLATBA"."Datum předložení" AS "Datum předložení",
    -- "V_BI_UMPPLATBA"."VYUCTPLAN#Vyúčtování plán" AS "VYUCTPLAN#Vyúčtování plán",
    -- "V_BI_UMPPLATBA"."WFSTAV" AS "WFSTAV",
    -- "V_BI_UMPPLATBA"."Vyúčtování Investice" AS "Vyúčtování Investice",
    -- "V_BI_UMPPLATBA"."Vyúčtování plán očištěné o p" AS "Vyúčtování plán očištěné o p",
    -- "V_BI_UMFPFCELKEM"."PROC_EU" AS "PROC_EU",
count(V_BI_UMPPLATBA".id),

sum(("V_BI_UMFPFCELKEM"."PROC_EU" / 100) * "V_BI_UMPPLATBA"."VYUCTPLAN#Vyúčtování plán") AS "Vypočtená částka"
FROM
    "ISUM"."V_BI_UMZPROJEKT" "V_BI_UMZPROJEKT"
INNER JOIN "ISUM"."V_BI_UMPPLATBA" "V_BI_UMPPLATBA"
    ON "V_BI_UMPPLATBA"."ID_NOSITELPLATBY" = "V_BI_UMZPROJEKT"."ID"
INNER JOIN "ISUM"."V_BI_UMZVYZVA" "V_BI_UMZVYZVA"
    ON "V_BI_UMZPROJEKT"."ID_VYZVA" = "V_BI_UMZVYZVA"."ID"
INNER JOIN "ISUM"."V_BI_UMFPFCELKEM" "V_BI_UMFPFCELKEM"
    ON "V_BI_UMFPFCELKEM"."ID_PROJEKT" = "V_BI_UMZPROJEKT"."ID"
WHERE
    "V_BI_UMZPROJEKT"."Registrační číslo projektu" IS NOT NULL
    AND "V_BI_UMFPFCELKEM"."ID_FAZE" = '99991000000000005'
    AND "V_BI_UMPPLATBA"."SOUCTOVYRADEK" IS NULL
    AND (
        "V_BI_UMZVYZVA"."Číslo výzvy" = '31_22_006' OR
        "V_BI_UMZVYZVA"."Číslo výzvy" = '31_23_116'
    )
    AND "V_BI_UMPPLATBA"."Datum předložení" <= TO_DATE('2025-07-01', 'YYYY-MM-DD')

    AND "V_BI_UMPPLATBA".kodwfstav not IN ('P10','P11','P6','P6T','P5T','P5') 



GROUP BY "Číslo výzvy"

