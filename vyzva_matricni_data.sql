SELECT v."Číslo výzvy",
       v."Název výzvy",
       ci."Název" ,
       ci."Kód" 

FROM isum.v_bi_UmzVyzva v
INNER JOIN isum.v_bi_UMZVyzvaMD md ON md.id_vyzva= v.id
INNER JOIN isum.v_bi_UmsCisZakladni ci ON md.ID_CISZAKLADNI = ci.id

WHERE ci."Kód" = '530625713'

ORDER BY v."Číslo výzvy" DESC
