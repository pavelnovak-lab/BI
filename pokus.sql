SELECT v."Název výzvy", v."Èíslo výzvy", kom."Název"

FROM isum.v_bi_UmzVyzva v 
INNER JOIN isum.V_BI_UmzVyzvaUtvar utvar ON utvar.id_vyzva=v.id
INNER JOIN isum.V_BI_UMSHIUtvarKomp kom ON kom.id=utvar.id_utvarkomp


WHERE v.id = 1105777871
AND kom."Název" <> 'Operaèní program Podnikání a inovace pro konkurenceschopnost' 
AND kom."Název" is not null 




SELECT v."Název výzvy" ,
       v."Èíslo výzvy",
	hi.*

FROM isum.v_bi_UmzVyzva v
INNER JOIN isum.v_bi_UMZVyzvaHierarchie hi ON v.id = hi.id_vyzva


WHERE v.id = 1105777871


SELECT *
FROM isum.v_bi_UMZVyzvaHierarchie hi

WHERE hi.id = 1126878565
