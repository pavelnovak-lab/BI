SELECT  p."Registraèní èíslo projektu",
	p.kodwfstav,
	sum(platba.VYUCTSKUT)
		
FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby

WHERE p.kodwfstav in ('PP37','PP40','PP41','PP42','PP43') 
AND EXISTS
(SELECT 0
 FROM isum.v_bi_UmpPlatbaPrj pla
 WHERE pla.KODWFSTAV in ('P10','P11','N1')
 AND pla."Závìreèná platba" = 'A'
 AND pla.id = platba.id)

HAVING sum(platba.VYUCTSKUT) = 0

GROUP BY p."Registraèní èíslo projektu" ,
      	 p.kodwfstav 
