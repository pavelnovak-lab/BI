SELECT	v."Èíslo výzvy" ,
	v."Název výzvy",
	v.wfstav,
	-- f.nazev,
	form."1 kolo",
	form."2 kolo",
	form."Pøed PA",
	form."Poøadí obrazovky v rámci úlohy"
--	cf.*

FROM isum.v_bi_UmzVyzva v 
INNER JOIN isum.v_bi_UMZVyzvaForm form ON form.id_vyzva = v.id
INNER JOIN isum.v_bi_UMSFormular f ON form.id_formular = f.id 
-- INNER JOIN isum.v_bi_CFormular cf ON f.id_formular = cf.id
-- isum.v_bi_UmsCisSeznam

WHERE -- v."Èíslo výzvy" = '31_22_001'
-- "Název" like '%ISKP%'
