SELECT p."Registraèní èíslo projektu" ,
       v."Èíslo výzvy",
       zou."Poøadové èíslo ZoR/IoP",
       -- zou.wfstav ,
       typ."Poznámka",
       pril.*

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UMZZIProjekt zou ON zou.id_zad = p.id AND zou.id_cistypzi IN (361331, 361330) -- ZoU, ZZoU
-- INNER JOIN isum.v_bi_UMSPrilohyZI pril ON pril.id_nositelpril = zou.id
INNER JOIN isum.v_bi_UMSPrilohyProjekt pril ON pril.id_nositelpril = p.id
INNER JOIN isum.V_BI_UMZCisTypZI typ ON typ.id = zou.id_cistypzi


WHERE p.kodwfstav like 'PP4%'
AND v."Èíslo výzvy" = '01_18_244'
AND p."Registraèní èíslo projektu" = 'CZ.01.2.111/0.0/0.0/18_244/0016413'


ORDER BY p."Registraèní èíslo projektu" , zou."Poøadové èíslo ZoR/IoP"
----------------------------------------

SELECT *

FROM isum.v_bi_UMSPrilohyProjekt

WHERE id = 2007582651
