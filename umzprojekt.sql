SELECT p."Registraèní èíslo projektu" ,
       p.zed,
       p.akcezed,
       ci."Název",
       ci."Kód" 

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  p.ID_AGRAKCEZED

WHERE p."Registraèní èíslo projektu" like 'CZ.01.1%'
AND p.zed in ('A','N')
