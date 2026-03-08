SELECT p."Registraèní èíslo projektu" ,
       psc."Ménì rozvinutý region" "% MRR",
       psc."Pøechodové" "%PR"

FROM projekt p
INNER JOIN projekt_specificky_cil psc ON psc.id_prjgg = p.id


-- INNER JOIN pomery_financovani pf ON pf.id_nositelpompf = p.id
-- INNER JOIN ciselnik_kategorie_regionu kr ON pf.id_kategorieregionu = kr.id

WHERE p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000423'
