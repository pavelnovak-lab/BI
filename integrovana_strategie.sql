
SELECT vs.*

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmzVyzvaStrategie vs ON  v.id=vs.id_vyzva 

WHERE p.id = 397798382
