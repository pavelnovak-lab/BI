SELECT p."Registraèní èíslo projektu" ,
       p.id,
       sc."Název specifického cíle/opatøení",
       s.id,
       sum(vpo.castkacelk_kc),
       sum(vpo.castka_kc)
       

FROM projekt p
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit IN (413462, 413467)
INNER JOIN v_rav_umsrdmpodpora vpo ON vpo.id_projekt = p.id  AND vpo.id_nositel = s.id
INNER JOIN projekt_specificky_cil psc ON p.id=psc.id_prjgg
INNER JOIN specificky_cil sc ON psc.id_sc = sc.id


WHERE sc."Název specifického cíle/opatøení" = 'Aplikace'
AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000880'

GROUP BY p."Registraèní èíslo projektu" , s.id, p.id
