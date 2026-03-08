SELECT p."Registraèní èíslo projektu" ,
       p."Název projektu CZ",
       p."Anotace projektu CZ",
       cw."Kód",
       cw."Název",
       cn."Kód",
       cn."Název" 

FROM projekt p
INNER JOIN ciselnik_stav_workflow cw ON cw.id = p.id_wfstav
INNER JOIN projekt_cznace pn ON pn.id_projekt = p.id
INNER JOIN ciselnik_cznace cn ON pn.id_cznace = cn.id 


WHERE p."Registraèní èíslo projektu" is not null
AND p."Registraèní èíslo projektu" IN ('CZ.01.01.01/01/22_002/0000322','CZ.01.01.01/02/22_003/0000172')

----------------------------------------

SELECT * FROM vazby_all where "DO" like '%ris%'
----------------------------------------



-- CREATE OR replace VIEW "RIS3_OPTAK" FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/ris3' AS
SELECT p."Registraèní èíslo projektu",
       p."Název projektu CZ",
       w.kod,

       pl."Název" "Operaèní program",
       pl."Kód",
       -- plp."Kód" " Kód priority OP",



       v."Èíslo výzvy",
       v."Název výzvy",
       -- umpf.proc_eu,
       -- umpf.eu,
       -- umpf.czv,
       -- (umpf.eu/umpf.czv)
       -- pf."Doporuèený pomìr financování (%)",

       -- plp."Název" "Název priority OP",
       -- sc."Èíslo SC/opatøení EK formát",
       -- sc."Název specifického cíle"
       
       -- hk."Vyhovìl" "Vyhovìl A3",
       -- hk."Relevantní" "Relevantní A3",
       -- hk."Název kritéria A3",
       -- hkb."Poèet bodù" "Vyhovìl B1",
       -- hkb."Relevantní" "Relevantní B1",
       -- hkb."Název" "Název kritéria B1"
       
              
       
FROM projekt AS p
INNER JOIN vyzva AS v ON v.id = p.id_vyzva 
INNER JOIN v_rav_umscisstavwf AS w ON w.id = p.id_wfstav
INNER JOIN projekt_specificky_cil sc ON sc.id_prjgg = p.id
INNER JOIN programova_linie pl on pl.id = v.id_prg

-- INNER JOIN pomery_financovani AS pf ON pf.id_nositelpompf = p.id 
-- INNER JOIN v_rav_umfpfcelkem AS umpf ON (umpf.id_projekt = p.id AND umpf.id_faze = 99991000000000005 AND umpf.czv <> 0)

-- inner join programova_linie plp on plp.id = p.id_prioritniosa
-- INNER JOIN specificky_cil sc ON sc.id_osa = plp.id AND sc."Listová polo¾ka" = 'N' -- vybírá SC, A - znamená opatøení
-- -- lepe projekt_scpecifickycil (nebo jak pøesnì)
-- INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id AND h.id_krokvechodn = 488854 AND h."Platný" = 'A' AND h."Schváleno schvalovatelem" = 'A' -- 2. krok vh 
-- INNER JOIN hodnota_kriteria hk ON hk.id_hodnoceni = h.id AND hk."Kód" = 'A3.'
-- INNER JOIN hodnota_kriteria hkb ON hk.id_hodnoceni = h.id AND hk."Kód" = 'B1.'


WHERE -- p."Registraèní èíslo projektu" like 'CZ.01%'
p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000322'
-- AND pf."Vlastní prostøedky financování" = 'N'
-- AND (umpf.proc_eu/100) < (umpf.eu/umpf.czv)) -- aby nepadalo na dìlení u výpoètu procenta


