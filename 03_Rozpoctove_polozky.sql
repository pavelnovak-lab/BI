-- CREATE or REPLACE view "03_KnM_Rozpoctove_polozky_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Kontroly/Vzorkovani_pro_kontroly_na_miste' AS 

SELECT p."Registraèní èíslo projektu" ,
       pol."Název",
       pol."Èástka celkem"
       
FROM projekt p
INNER JOIN rozpocet_hlavicka hl ON hl.id_nrozpocet = p.id AND hl."Aktuální" = 'A'
INNER JOIN rozpocet_skupina sr ON sr.id = hl.id_skupina
INNER JOIN rozpocet_polozka pol ON pol.id_hlavicka = hl.id -- AND   pol."Název" = 'Celkové zpùsobilé výdaje' -- OR pol.LISTOVA = 'A'

WHERE p."Registraèní èíslo projektu" is not null
ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC , pol."Kód" ASC


-- ----------------------------------------

-- SELECT p."Registraèní èíslo projektu",
--        pol."Název",
--        pol."Èástka celkem"

-- FROM isum.v_bi_UmzProjekt p
-- INNER JOIN isum.v_bi_UMFROZHlavickaPrj hl ON p.id = hl.id_nrozpocet AND hl."Aktuální" = 'A'
-- INNER JOIN isum.V_BI_UMFROZSkupina sk ON sk.id = hl.id_skupina
-- INNER JOIN isum.V_BI_UMFROZPOLOZKYPRJ pol ON pol.id_hlavicka = hl.id AND (pol.LISTOVA = 'A' or pol."Název" = 'Celkové zpùsobilé výdaje')

-- WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
-- AND p."Registraèní èíslo projektu" is not null 

-- ORDER BY substr(p."Registraèní èíslo projektu",-5,5) asc, pol."Kód"
