SELECT p."Registraèní èíslo projektu" ,
       p."Datum prvního podání" ,
       s."Název subjektu" "®adatel"


FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462 -- ¾adatel


WHERE v."Èíslo výzvy" = '01_22_006'
AND p."Datum prvního podání" is not null 


ORDER BY p."Datum prvního podání" DESC
