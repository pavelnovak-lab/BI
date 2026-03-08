SELECT v."Èíslo výzvy",
           v."Název výzvy",
           fk."Kód",
           md."Platný"
FROM vyzva AS v
INNER JOIN vyzva_matricni_data AS md ON md.id_vyzva = v.id)
INNER JOIN ciselnik_podminky_prechodu_stavu_workflow AS fk ON fk.id = md.id_ciszakladni

WHERE (fk."Kód" = '930' AND md."Platný" = 'A'



----------------------------------------



SELECT v."Èíslo výzvy",
           v."Název výzvy"
           fk."Kód"
           md."Platný"
FROM vyzva AS v
INNER JOIN vyzva_matricni_data AS md ON md.id_vyzva = v.id
INNER JOIN ciselnik_podminky_prechodu_stavu_workflow AS fk ON fk.id = md.id_ciszakladni

WHERE not exists (SELECT 1
      	  	  FROM fk."Kód" = '109'




SELECT v."Èíslo výzvy",
       v."Název výzvy"
       -- fk."Kód",
       -- md."Platný"

FROM vyzva AS v
INNER JOIN vyzva_matricni_data AS md ON md.id_vyzva = v.id
INNER JOIN ciselnik_podminky_prechodu_stavu_workflow AS fk ON fk.id = md.id_ciszakladni

WHERE NOT EXISTS (
    SELECT 1
    FROM vyzva_matricni_data AS md2
    INNER JOIN ciselnik_podminky_prechodu_stavu_workflow AS fk2 ON fk2.id = md2.id_ciszakladni
    WHERE md2.id_vyzva = v.id
    AND fk2."Kód" = '109'
)
