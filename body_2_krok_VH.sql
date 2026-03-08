SELECT	v."Èíslo výzvy",
	v."Název výzvy" ,
	p."Registraèní èíslo projektu" ,
	p.kodwfstav,
	status.POCETBODU "Celkem bodù ve 2. kroku VH",
	CASE WHEN p.kodwfstav IN ('PN20a','PN20b','PN21','PN22','PN23a','PN27','PN28','PN29') THEN 'Ne'
 	     WHEN p.kodwfstav IN ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PN40a','PN40b') THEN 'Ano'
	     END  "Schválený",
	
	prj.eu "Po¾adovaná dotace",
	sum(rf.CASTKASCHVALENA) "Dosud proplacená dotace"
	
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.V_BI_UMVHODNSTATUSDH status ON status.id_noshodnoceni = p.id AND status.id_KROKVECHODN = 171214
INNER JOIN isum.v_bi_UmzPrjGG prj ON p.id = prj.id
LEFT JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.kodwfstav in ('P10','P11')
LEFT JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- øádky 10a   
 


WHERE p."Registraèní èíslo projektu" is not null 
-- 'CZ.01.1.02/0.0/0.0/21_374/0027374'
-- AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'
-- AND 	p.kodwfstav in ('PP23a','PP23b','PN23a','PP27a','PP27b','V5','PP29','PP30','PP36','PP37','PP40','PP41','PP42','PP43')
AND v."Èíslo výzvy" IN ('01_17_106','01_17_107','01_17_175','01_17_176')

GROUP BY v."Èíslo výzvy",
	v."Název výzvy" ,
	p."Registraèní èíslo projektu" ,
	p.kodwfstav,
	status.POCETBODU,
	prj.eu,  "Schválený" -- spí¹ ten case



