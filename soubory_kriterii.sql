SELECT	count(v.id),
--        v."Název výzvy" ,
        sk.nazev "Název souboru kritérií",
        cis.nazev "Fáze hodnocení"
       
       
FROM  isum.v_bi_UmzVyzva v   
INNER JOIN isum.v_bi_UMVHodnSoubKritVyz skv ON skv.id_vyzva = v.id
INNER JOIN isum.v_bi_UMVHodnSouborKrit sk  ON sk.id = skv.id_souborkrit
INNER JOIN isum.v_bi_UMVHodnDruhCis cis ON cis.id = skv.id_druhhodn

WHERE skv.pocethodnotitelu > 0
--AND v.id = 1047819161


GROUP BY sk.nazev, cis.nazev


ORDER BY count(v.id) DESC
