SELECT v."Název výzvy", v."Èíslo výzvy", c.nazev, c.kod

FROM (vyzva AS v
INNER JOIN v_rav_umzvyzvamd AS md ON md.id_vyzva = v.id )
INNER JOIN v_rav_umsciszakladni AS c ON c.id = md.id_ciszakladni

-- WHERE (md.id_cisseznam = 278174
-- AND md.id_ciszakladni = 12675643);

WHERE
-- md.id = 100386918
c.kod IN ('OP TAK 20','OP TAK 22','OP TAK 21')
