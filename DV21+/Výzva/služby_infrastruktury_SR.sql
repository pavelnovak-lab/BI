-- CREATE OR REPLACE VIEW rozpracovane_iskp_rozpocet_vpo FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/projekty' AS
SELECT DISTINCT 
    v."Číslo výzvy",
    p."Registrační číslo projektu" ,
    s."Název subjektu" "Žadatel" ,
    w."Kód",
    p."Datum změny stavu"
    -- group_concat(DISTINCT '; ', s."Název subjektu") AS "Subjekt",
    -- group_concat(DISTINCT '; ', ts."Název") AS "Typy subjektů",
    -- s."Název subjektu" ,
    -- ts."Název" "Typ subjektu" , 
    -- sr."Název skupiny rozpočtu",
    
    -- psc."Méně rozvinutý region",
    -- kvpo."Kód" AS "Kód VPo",
    -- kvpo."Název" AS "Položka VPo",
    -- hs."Uživatel, který provedl přepnutí stavu",
    -- count (DISTINCT hr.id_skupina ) "Navázaných SR"

FROM projekt AS p
INNER JOIN historie_stavu hs ON hs.nositelid = p.id
INNER JOIN vyzva AS v ON v.id = p.id_vyzva
LEFT OUTER JOIN subjekt AS s ON s.id_prjgg = p.id AND s."Neplatný od" IS NULL
INNER JOIN ciselnik_stav_workflow AS w ON p.id_wfstav = w.id
INNER JOIN ciselnik_typ_subjektu AS ts ON ts.id = s.id_typsubjektuedit
LEFT OUTER JOIN rozpocet_hlavicka AS hr ON hr.id_nrozpocet = p.id
LEFT OUTER JOIN rozpocet_skupina AS sr ON hr.id_skupina = sr.id
INNER JOIN projekt_specificky_cil AS psc ON psc.id_prjgg = p.id
LEFT OUTER JOIN verejna_podpora AS vpo ON vpo.id_projekt = p.id
LEFT OUTER JOIN ciselnik_kombinace_verejne_podpory AS kvpo ON kvpo.id = vpo.id_verejnapodpora
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null -- AND s.id_typsubjektuedit IN (413462, 413467) -- žadatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 

WHERE v."Číslo výzvy" IN ('01_25_069', '01_25_076')
AND hs.id = (SELECT MAX(hs2.id) FROM historie_stavu hs2 WHERE hs2.nositelid = p.id)
-- AND hs."Uživatel, který provedl přepnutí stavu" not IN ('STRALZ1_EXT', 'SKOOND1_EXT', 'NOVPAV23_EXT')
-- AND p."Identifikace žádosti (hash)" = '0FaGXf'
AND p."Registrační číslo projektu" IS NOT NULL 
AND p."Registrační číslo projektu" IN ('CZ.01.01.01/04/25_069/0008870','CZ.01.01.01/04/25_076/0008873','CZ.01.01.01/04/25_069/0008875')



