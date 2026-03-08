SELECT p."Identifikace ¾ádosti (Hash)" 

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva

WHERE v."Èíslo výzvy" = '31_23_069'
AND p.create_uzivatel IN ('HQTREPAV', 'JHKRAIVA')

