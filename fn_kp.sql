SELECT 	fn."Registraèní èíslo fondu fondù",
	fn."Název fondu fondù",
	kp."Jméno nebo Název",
	typ."Název" AS "Typ koneèného pøíjemce",
	kp."Identifikaèní údaj smlouvy",
	kp."Datum podpisu smlouvy",
	vki."Vý¹e investice ze smlouvy",
	skut."Vý¹e skuteèné investice"


FROM isum.v_bi_UMPFinNastroj fn 
INNER JOIN isum.v_bi_UMPFNPrehledKP kp ON kp.id_finnastroj=fn.id
INNER JOIN isum.v_bi_UmsCisZakladni typ ON typ.id=kp.id_typprijemce
INNER JOIN
( SELECT rf."Celkové zpùsobilé výdaje" AS "Vý¹e investice ze smlouvy",
  	 rf.id_prehledKP
  FROM isum.v_bi_UMPFNRozpisFin rf
  WHERE rf.id_typ = 52925219) vki ON vki.id_prehledKP = kp.id
INNER JOIN 
( SELECT rf."Celkové zpùsobilé výdaje" "Vý¹e skuteèné investice",
  	 rf.id_prehledKP
  FROM isum.v_bi_UMPFNRozpisFin rf
  WHERE rf.id_typ = 52925220) skut ON skut.id_prehledKP = kp.id


WHERE fn."Název fondu fondù" = 'Lighthouse Seed Fund' 
or fn."Název fondu fondù" = 'Nation 1 SCSP'

ORDER BY fn."Název fondu fondù"
