SELECT v."Èíslo výzvy",
       fk."Kód",
       fk."Název",
       md."Platný" 

FROM vyzva v
INNER JOIN vyzva_matricni_data md ON md.id_vyzva = v.id
INNER JOIN ciselnik_podminky_prechodu_stavu_workflow fk ON fk.id = md.id_ciszakladni


WHERE fk."Kód" = '872'
AND md."Platný" = 'A'
-- v."Èíslo výzvy" = '01_23_009'
