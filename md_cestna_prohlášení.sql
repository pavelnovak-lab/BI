SELECT count(v.id) "Poèet výzev"
       ci."Název" "Název ÈP",
       ci."Kód" "Kód ÈP",
       md.id_POVINVYBERSKUP "ID skupiny ÈP"
       
FROM isum.v_bi_UmzVyzva v
INNER JOIN isum.v_bi_UMZVyzvaMD md ON md.id_vyzva= v.id AND md.id_cisseznam = 198430 AND md."Platnost" = 'A'
INNER JOIN isum.v_bi_UmsCisZakladni ci ON md.ID_CISZAKLADNI = ci.id
-- INNER JOIN isum.V_BI_UMSCisMDSkupina ps ON md.id_POVINVYBERSKUP = ps.id

-- INNER JOIN isum.v_bi_umscisseznam cs ON cs.id = md.id_cisseznam

WHERE v."Èíslo výzvy" like '01%'

GROUP BY ci."Název",
       ci."Kód" ,
       md.id_POVINVYBERSKUP 

-- AND md.id = 1288220624
-- ci."Kód" = '287435851'

ORDER BY count(v.id) DESC
