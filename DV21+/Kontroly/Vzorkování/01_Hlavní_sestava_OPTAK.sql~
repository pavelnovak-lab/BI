-- CREATE or REPLACE view "01_Hlavní_sestva_OPTAK" FOLDER=AS 
SELECT p."Registraèní èíslo projektu" ,
       pl."Kód" AS "Prioritní osa" ,
       null AS KODINVESTPRIORITA ,
       sc.kodnovy "Kód SC",
       op.nazev as "Opatøení",
       w."Název" "Název stavu", 
       w."Kód" "Kód stavu" ,
       p."Datum zmìny stavu" ,
       s."Název subjektu" "®adatel",
       pf."Právní forma" ,
       s."IÈ" ,
       vp."Velikost kategorie podniku" "Velikost podniku" ,
       v."Èíslo výzvy",
       null "Výrok analytika",
       p."Pøedpokládané datum zahájení",
       p."Pøedpokládané datum ukonèení",
       p."Pøedpokládaná doba trvání (v mìsících)" ,
       s."Poèet zamìstnancù",
       s."Bilanèní suma roèní rozvahy (EUR)" ,
       zo."Poèet ®oZ",
       GROUP_CONCAT( ct."Název") "Rizikový tag"  -- bude tøeba výètem     


FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN programova_linie pl ON pl.id = p.id_prioritniosa
INNER JOIN v_rav_umshisc AS sc ON sc.id = op.id_hierarchie
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462 -- ¾adatel 
INNER JOIN ciselnik_pravni_forma pf ON pf.id = s.id_hosppravforma
LEFT JOIN ciselnik_velikost_podniku vp ON vp.id = s.id_velikostpodniku

LEFT JOIN tag t ON t.id_prjgg = p.id
LEFT JOIN ciselnik_tagy_projektu ct ON ct.id = t.id_tag
LEFT JOIN (SELECT max(z."Poøadí") AS "Poèet ®oZ", -- poèítám poèet podaných ®oZ (rozpracované nemají poøadové èíslo)
	z.id_zad
        FROM zmena z
	GROUP BY z.id_zad) zo ON zo.id_zad = p.id 

WHERE p."Registraèní èíslo projektu" is not null

GROUP BY p."Registraèní èíslo projektu" ,
       pl."Kód",
       KODINVESTPRIORITA ,
       sc.kodnovy ,
       op.nazev ,
       w."Název" ,
       w."Kód" ,
       p."Datum zmìny stavu" ,
       s."Název subjektu" ,
       pf."Právní forma" ,
       s."IÈ" ,
       vp."Velikost kategorie podniku"  ,
       v."Èíslo výzvy",
       "Výrok analityka",
       p."Pøedpokládané datum zahájení",
       p."Pøedpokládané datum ukonèení",
       p."Pøedpokládaná doba trvání (v mìsících)" ,
       s."Poèet zamìstnancù",
       s."Bilanèní suma roèní rozvahy (EUR)" ,
       zo."Poèet ®oZ"
       

