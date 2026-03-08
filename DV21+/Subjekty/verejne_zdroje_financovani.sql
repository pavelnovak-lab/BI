-- CREATE OR replace VIEW tak-mpo-novak-subjekt_pravni_forma_verejne_zdroje FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/subjekty' AS

SELECT op.nazev AS "Opatření",
       p."Registrační číslo projektu",
       w."Kód" AS "Kód stavu",
       s."Název subjektu",
       ts."Název" AS "Typ subjektu",
       pforma."Právní forma",
       -- vpo."Částka poskytnuté veřejné podpory celkem v Kč",
       -- vpo."Částka veřejné podpory\n (CZK, dotační zdroje)" ,
       -- vpo."Částka poskytnuté veřejné podpory celkem - Příspěvek Unie v Kč",
       -- rp."Režim podpory",
       pf."Příspěvek Unie" "EU" ,
       pf."Národní veřejné zdroje",
       pf."Jiné národní veřejné finanční prostředky",
       pf."Finanční prostředky z rozpočtu obcí/obce",
       pf."Finanční prostředky z rozpočtu krajů/kraje",
       pf."Finanční prostředky \n ze státních fondů",
       pf."Finanční prostředky \n ze státního rozpočtu"

FROM projekt AS p INNER JOIN vyzva AS v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie AS vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc AS op ON op.id = vh.id_speccil
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null  AND s.id_typsubjektuedit IN (413462) -- žadatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 
INNER JOIN ciselnik_pravni_forma AS pforma ON pforma.id = s.id_hosppravforma
INNER JOIN ciselnik_stav_workflow AS w ON p.id_wfstav = w.id
-- INNER JOIN verejna_podpora vpo ON vpo.id_projekt = p.id AND vpo."Platnost" = 'A'
-- INNER JOIN ciselnik_rezim_podpory rp ON rp.id = vpo.id_rezimpodpory
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 

WHERE p."Registrační číslo projektu" IS NOT NULL
AND NOT w."Kód" REGEXP_LIKE 'PN.*'
-- AND   (
--       pf."Národní veřejné zdroje" > 0
--       OR pf."Finanční prostředky \n ze státních fondů" > 0
--       OR pf."Finanční prostředky z rozpočtu obcí/obce" > 0
--       OR pf."Finanční prostředky z rozpočtu krajů/kraje" > 0
--       OR pf."Finanční prostředky \n ze státního rozpočtu" > 0
--       )

ORDER BY pforma."Právní forma", "Opatření",  SUBSTR(p."Registrační číslo projektu",24)

----------------------------------------
-- Opačný přístup


SELECT op.nazev AS "Opatření",
       p."Registrační číslo projektu",
       w."Kód" AS "Kód stavu",
       s."Název subjektu",
       ts."Název" AS "Typ subjektu",
       pforma."Právní forma",
       -- vpo."Částka poskytnuté veřejné podpory celkem v Kč",
       -- vpo."Částka veřejné podpory\n (CZK, dotační zdroje)" ,
       -- vpo."Částka poskytnuté veřejné podpory celkem - Příspěvek Unie v Kč",
       -- rp."Režim podpory",
       pf."Příspěvek Unie" "EU" ,
       pf."Národní veřejné zdroje",
       pf."Jiné národní veřejné finanční prostředky",
       pf."Finanční prostředky z rozpočtu obcí/obce",
       pf."Finanční prostředky z rozpočtu krajů/kraje",
       pf."Finanční prostředky \n ze státních fondů",
       pf."Finanční prostředky \n ze státního rozpočtu"

FROM projekt AS p INNER JOIN vyzva AS v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie AS vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc AS op ON op.id = vh.id_speccil
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null  AND s.id_typsubjektuedit IN (413462) -- žadatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 
INNER JOIN ciselnik_pravni_forma AS pforma ON pforma.id = s.id_hosppravforma
INNER JOIN ciselnik_stav_workflow AS w ON p.id_wfstav = w.id
-- INNER JOIN verejna_podpora vpo ON vpo.id_projekt = p.id AND vpo."Platnost" = 'A'
-- INNER JOIN ciselnik_rezim_podpory rp ON rp.id = vpo.id_rezimpodpory
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 

WHERE p."Registrační číslo projektu" IS NOT NULL
AND NOT w."Kód" REGEXP_LIKE 'PN.*'
AND pf."Soukromé zdroje" > 0
AND pforma."Kód" IN ('706','751','745','161','601','736','661','708','301','141')
-- AND   (
--       pf."Národní veřejné zdroje" > 0
--       OR pf."Finanční prostředky \n ze státních fondů" > 0
--       OR pf."Finanční prostředky z rozpočtu obcí/obce" > 0
--       OR pf."Finanční prostředky z rozpočtu krajů/kraje" > 0
--       OR pf."Finanční prostředky \n ze státního rozpočtu" > 0
--       )

ORDER BY pforma."Právní forma", "Opatření",  SUBSTR(p."Registrační číslo projektu",24)






------------------------------
--- Přehled všech PF v optak 
SELECT distinct pforma.*
       -- vpo."Částka poskytnuté veřejné podpory celkem v Kč",
       -- vpo."Částka veřejné podpory\n (CZK, dotační zdroje)" ,
       -- vpo."Částka poskytnuté veřejné podpory celkem - Příspěvek Unie v Kč",
       -- rp."Režim podpory",

FROM projekt AS p INNER JOIN vyzva AS v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie AS vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc AS op ON op.id = vh.id_speccil
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null  AND s.id_typsubjektuedit IN (413462) -- žadatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 
INNER JOIN ciselnik_pravni_forma AS pforma ON pforma.id = s.id_hosppravforma
INNER JOIN ciselnik_stav_workflow AS w ON p.id_wfstav = w.id
-- INNER JOIN verejna_podpora vpo ON vpo.id_projekt = p.id AND vpo."Platnost" = 'A'
-- INNER JOIN ciselnik_rezim_podpory rp ON rp.id = vpo.id_rezimpodpory
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 

WHERE p."Registrační číslo projektu" IS NOT NULL
AND NOT w."Kód" REGEXP_LIKE 'PN.*'
-- AND pf."Soukromé zdroje" > 0
-- AND pforma."Kód" IN ('706','751','745','161','601','736','100','661','708','301','141')
-- AND   (
--       pf."Národní veřejné zdroje" > 0
--       OR pf."Finanční prostředky \n ze státních fondů" > 0
--       OR pf."Finanční prostředky z rozpočtu obcí/obce" > 0
--       OR pf."Finanční prostředky z rozpočtu krajů/kraje" > 0
--       OR pf."Finanční prostředky \n ze státního rozpočtu" > 0
--       )




