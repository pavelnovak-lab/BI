-- CREATE or REPLACE view "RIS3_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 
SELECT v."Èíslo výzvy",
       v."Název výzvy",
       p."Registraèní èíslo projektu",
       p."Název projektu CZ" "Název projektu",
       w.kod "Kód stavu",
       
       GROUP_CONCAT(DISTINCT n."Kód") "Kód CZ NACE",
       GROUP_CONCAT(DISTINCT n."Název") "Název CZ NACE"


FROM projekt p
INNER JOIN v_rav_umscisstavwf w ON w.id = p.id_wfstav
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN programova_linie pl ON pl.id = v.id_program
INNER JOIN specificky_cil sc ON sc."Èíslo SC/opatøení ØO formát" = substr(p."Registraèní èíslo projektu",4,8)
INNER JOIN projekt_cznace pn ON pn.id_projekt = p.id
INNER JOIN ciselnik_cznace n ON n.id = pn.id_cznace

WHERE --  v."Èíslo výzvy" IN ('01_23_017', '01_24_044') -- Marketing I, II
p."Registraèní èíslo projektu" is not null
-- AND w.kod not like 'PN%'
-- AND w.kod not like 'PP3%'
-- AND w.kod not like 'PP4%'
-- AND NOT w.kod REGEXP_LIKE 'PP[34].*|PN.*'
-- AND --(n."Kód" like '12%' or
    -- n."Kód" like '45%' --  or
    -- n."Kód" like '46.35%' or
    --  n."Kód" like '47.26%' or
    --  n."Kód" like '01%' or
    --  n."Kód" like '02%' or
    --  n."Kód" like '03%')



GROUP BY v."Èíslo výzvy" ,
       v."Název výzvy",
       p."Registraèní èíslo projektu",
       p."Název projektu CZ" ,
       w.kod 

SELECT op."Název specifického cíle/opatøení" as "Opatøení", 
       p."Registraèní èíslo projektu",
       w."Kód" "Stav projektu"


FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil 



WHERE p."Registraèní èíslo projektu" IS NOT NULL
AND w."Kód" REGEXP_LIKE 'P[PU]2[0-6][ab]?|Z[1-4]' 
