SELECT count(p."Identifikace ¾ádosti (hash)"),
       -- s."Název subjektu" "®adatel" ,
       v."Èíslo výzvy"
       -- v."Název výzvy",


FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null -- AND s.id_typsubjektuedit IN (413462, 413467) -- ¾adatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 

WHERE v."Èíslo výzvy" IN ('01_24_059','01_24_073')

GROUP BY v."Èíslo výzvy" 
