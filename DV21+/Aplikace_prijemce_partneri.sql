SELECT p."Název projektu CZ" "Název projektu",
       p."Registraèní èíslo projektu",
       w.kod "Kód stavu",
       s."Název subjektu",
       s."IÈ",
       cts."Název" "Typ subjektu",
       vp."Velikost kategorie podniku",
       pocet."Poèet projektù",
       pocet."Na projektech",
       pocet."Ve stavech"


FROM projekt p
INNER JOIN v_rav_umscisstavwf w ON w.id = p.id_wfstav
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit IN (413462, 413467) -- omezit na ¾adatele nebo i patrnera s FP?
INNER JOIN ciselnik_typ_subjektu cts ON s.id_typsubjektuedit = cts.id
LEFT JOIN ciselnik_velikost_podniku vp ON vp.id = s.id_velikostpodniku
INNER JOIN (
      SELECT count(s.id_prjgg) "Poèet projektù",
      	     GROUP_CONCAT( substring(p."Registraèní èíslo projektu",24,29) ) "Na projektech",
 	     GROUP_CONCAT( w.kod ) "Ve stavech",
      	     s."IÈ"
      FROM projekt p
      INNER JOIN v_rav_umscisstavwf w ON w.id = p.id_wfstav
      INNER JOIN vyzva v ON v.id = p.id_vyzva
      INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit IN (413462, 413467) -- omezit na ¾adatele nebo i patrnera s FP?

      WHERE v."Èíslo výzvy" =  '01_22_002'
      AND p."Registraèní èíslo projektu" is not null
      -- AND AND s."Název subjektu" = 'ALTRON, a.s.'
      GROUP BY  s."IÈ") pocet ON pocet."IÈ" = s."IÈ"

WHERE v."Èíslo výzvy" = '01_22_002'
AND p."Registraèní èíslo projektu" is not null
-- AND s."Název subjektu" = 'ALTRON, a.s.'
-- AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0001096'

