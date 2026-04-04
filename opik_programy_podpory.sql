SELECT	sum(castky.EuVyuctCelkem) AS "Proplaceno",	
	count(p."Registrační číslo projektu") "Počet prj s RoPD do PP40",
	sum(gg.eu) AS "Dotace pod RoPD",
	kom."Název" AS "Program podpory" 
	

FROM isum.v_bi_UmzProjekt p  
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.V_BI_UmzVyzvaUtvar utvar ON utvar.id_vyzva=v.id
INNER JOIN isum.V_BI_UMSHIUtvarKomp kom ON kom.id=utvar.id_utvarkomp 
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpCastkySchval castky ON platba.id_SchvaleneCastky=castky.id 


WHERE
p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42')
AND kom."Název" <> 'Operační program Podnikání a inovace pro konkurenceschopnost'
AND platba.kodwfstav in ('P10','P11')

GROUP BY kom."Název" 

ORDER BY gg.eu DESC
