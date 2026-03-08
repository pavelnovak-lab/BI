SELECT  p."Registraèní èíslo projektu"
 	p.kodwfstav,
	p."Název projektu CZ" ,
	p.czv,
	p.eu

FROM isum.v_bi_UmzPrjgg p


WHERE p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42')


ORDER BY substr(p."Registraèní èíslo projektu",-5,5) asc 
