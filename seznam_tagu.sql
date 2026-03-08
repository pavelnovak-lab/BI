SELECT DISTINCT
       ci."Název"  "Tag"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UMZPrjGGTag tag ON p.id = tag.id_prjgg
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = tag.id_tag

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 




