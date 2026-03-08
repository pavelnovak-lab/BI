SELECT v."Název výzvy",
       v."Èíslo výzvy",
       fk."Kód",
       md."Platný"

FROM vyzva AS v
INNER JOIN vyzva_matricni_data AS md ON md.id_vyzva = v.id
INNER JOIN ciselnik_podminky_prechodu_stavu_workflow AS fk ON fk.id = md.id_ciszakladni


WHERE fk."Kód" IN  (887,886)
AND v."Èíslo výzvy" like '01_2%'
-- AND md."Platný" = 'A');
