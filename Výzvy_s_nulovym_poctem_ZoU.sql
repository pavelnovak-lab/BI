SELECT	v."Název výzvy",
	v."Číslo výzvy",
--	v."Počet ZoU" "Počet ZoU výzva",
--	v.wfstav,
	p."Registrační číslo projektu" ,
	p."Počet ZoU" "Počet ZoU projekt",
	p.kodwfstav,
	kom."Název" AS "Program podpory" 
--	p.velikostpodniku 

FROM isum.v_bi_UmzProjekt p  
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.V_BI_UmzVyzvaUtvar utvar ON utvar.id_vyzva=v.id
INNER JOIN isum.V_BI_UMSHIUtvarKomp kom ON kom.id=utvar.id_utvarkomp 

WHERE v."Číslo výzvy" is not null
AND v.wfstav <> 'Zrušená'
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42')
AND v."Počet ZoU" is null
AND p."Počet ZoU" = 0
AND kom."Název" <> 'Operační program Podnikání a inovace pro konkurenceschopnost'

ORDER BY v."Číslo výzvy" 
