SELECT p.kodwfstav,  -- platba."Èíslo ¾ádosti o platbu" ,
       count(p."Registraèní èíslo projektu") ,
       
       max(platba."PORADI#Poøadí finanèního plánu") 
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby

WHERE v."Èíslo výzvy" = '31_23_100'
-- p."Registraèní èíslo projektu" = 'CZ.31.2.0/0.0/0.0/23_100/0010609'
AND p.kodwfstav not like 'PN%'

GROUP BY p.kodwfstav

ORDER BY p.kodwfstav 
