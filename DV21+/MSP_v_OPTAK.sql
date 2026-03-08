SELECT sc."Název specifického cíle/opatøení" "Opatøení",
       v."Èíslo výzvy",
       v."Název výzvy",
       p."Registraèní èíslo projektu",
       p."Název projektu CZ" "Název projektu",
       w.kod "Kód stavu",
       w.nazev "Název stavu",

       -- pzf."Celkové zdroje pøipadající na zpùsobilé výdaje" "CZV projektu celkem",
       -- pzf."Pøíspìvek Unie" "Pøíspìvek EU",

       s."Název subjektu" "®adatel",
       s."IÈ",

       vp."Velikost kategorie podniku",
       s."Poèet zamìstnancù",
       s."Roèní obrat (EUR)",
       s."Bilanèní suma roèní rozvahy (EUR)"

FROM projekt p
INNER JOIN v_rav_umscisstavwf w ON w.id = p.id_wfstav
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN projekt_specificky_cil psc ON p.id=psc.id_prjgg
INNER JOIN specificky_cil sc ON psc.id_sc = sc.id
-- INNER JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit IN (413462) -- , 413467)
INNER JOIN ciselnik_velikost_podniku vp ON vp.id = s.id_velikostpodniku

WHERE p."Registraèní èíslo projektu" is not null 


