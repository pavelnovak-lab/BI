-- CREATE or REPLACE view "RIS3_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 
SELECT p."Registraèní èíslo projektu" ,
       w."Kód" "Kód stavu" ,
       cs."Název" "Typ subjektu" ,
       s."IÈ",
       s."Jméno a pøíjmení / Název" "Název subjektu"

FROM  projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id 
INNER JOIN subjekt s ON s.id_prjgg = p.id
INNER JOIN ciselnik_typ_subjektu cs ON cs.id = s.id_typsubjektuedit

WHERE p."Registraèní èíslo projektu" is not null 
-- AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/05/22_004/0001174'
-- AND id_typsubjektuedit = 413437
-- AND s."Jméno a pøíjmení / Název" = 'Vysoká ¹kola báòská - Technická univerzita Ostrava'

AND s."IÈ" IN ('05848911','17479011','26004968','26769611','28684931','42756111','46900098','49612298')



ORDER BY s."IÈ" 
