SELECT  p."Registraèní èíslo projektu",
	p.kodwfstav "Stav projektu",
	p.zadatel,
	platba.CISLOPLATBYZKR "Zkrácené èíslo ®oP",
	platba."Datum proplacení pøíjemci" ,
	platba."PORADI#Poøadí finanèního plánu" "Poøadí ®oP" ,
	rf.CASTKASCHVALENA "Èástka schválená" 
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356 -- øádky cis."Kód" = '10a' 	


WHERE platba.kodwfstav in ('P10','P11')
AND platba.souctovyradek is null
-- AND platba.vyuctskut = 0
AND p.id_vyzva = 969779032 -- výzva TECHNOLOGIE XII. - COVID-19, 01_20_357
AND p."Registraèní èíslo projektu" = 'CZ.01.2.06/0.0/0.0/20_357/0021649'

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC , platba."PORADI#Poøadí finanèního plánu" "Poøadí ®oP" 
