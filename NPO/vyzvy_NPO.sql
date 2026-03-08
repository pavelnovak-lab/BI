SELECT distinct v."Číslo výzvy",
       v."Název výzvy" 


FROM isum.v_bi_UmzVyzva v
INNER JOIN isum.v_bi_UmzProjekt p ON p.id_vyzva = v.id



WHERE p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.4','31.5','31.9','31.14','31.22','31.26')
