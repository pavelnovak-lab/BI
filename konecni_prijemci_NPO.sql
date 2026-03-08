SELECT	p.zadatel "Název koneèného pøíjemce fin. prostøedkù",
	p."IÈ" "IÈO",
	p."Registraèní èíslo projektu" "Unikátní ID projektu",
	p."Název projektu CZ" "Název projektu" ,
	sum(rf.CASTKASCHVALENA) "Vý¹e fin. prostøedkù na projekt v Kè" ,
	p.kodspecifcil ,

	SUBSTR(ci."Kód", -3) "Identifikace Milníku/Cíle" ,
	ci."Název",
	p.specifcil
	
FROM isum.v_bi_UmzProjekt p
LEFT JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.kodwfstav in ('P10','P11')
LEFT JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 )
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = p.id_micil
-- INNER JOIN isum.v_bi_UMSCisDUMilCil mc ON mc.id = p.id_micil

WHERE p."Registraèní èíslo projektu" like 'CZ.31%'
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PU30') 
AND p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.4','31.5','31.9','31.14','31.22','31.28') -- komponenty MPO
-- AND p."Registraèní èíslo projektu" = 'CZ.31.3.0/0.0/0.0/22_001/0000040'
-- AND p.kodspecifcil <> '31.14.0.1'

GROUP BY p.zadatel ,
	p."IÈ" ,
	p."Registraèní èíslo projektu",
	p."Název projektu CZ" ,
	p.id_micil,
	p.kodspecifcil ,
	p.specifcil ,
	ci."Kód" ,
	ci."Název"

ORDER BY p.kodspecifcil
