SELECT zareg."Registrační číslo projektu",
--       ostatni.plan as "Plánováno celkem",
	 ostatni.CZV,
	 ostatni.proplaceno as "Zatím proplaceno",
	 zareg.poradi as "Pořadí ŽoP",
      	 zareg.plan as "Požadováno v ŽoP",
	 ostatni.CZV - ostatni.proplaceno as "Zbývá proplatit"


FROM 

(SELECT p."Registrační číslo projektu",
	p.id,	       
       pl.cisloplatbyzkr,
       pl."PORADI#Pořadí finančního plánu" as poradi,
       pl.kodwfstav,
       pl.wfstav,
       pl.VYUCTSKUT,
       pl."VYUCTPLAN#Vyúčtování plán" as plan,
       pl.SOUCTOVYRADEK

FROM		isum.v_bi_UmzProjekt p
inner join 	isum.v_bi_UmpPlatbaPrj pl ON p.id=pl.id_nositelplatby


WHERE p."Registrační číslo projektu" = 'CZ.01.4.04/0.0/0.0/16_076/0007810'
AND   pl.kodwfstav = 'P4' ) zareg

INNER JOIN

-- (SELECT p.id,
-- 	sum(pl.vyuctskut) as proplaceno
	

-- FROM		isum.v_bi_UmzProjekt p
-- INNER JOIN 	isum.v_bi_UmpPlatbaPrj pl ON p.id=pl.id_nositelplatby 

-- WHERE 	pl.SOUCTOVYRADEK is null

-- GROUP BY p.id) ostatni

(SELECT p.id,
	pl.VYUCTSKUT as proplaceno,
        pl."VYUCTPLAN#Vyúčtování plán" 	CZV
	
FROM		isum.v_bi_UmzProjekt p
INNER JOIN 	isum.v_bi_UmpPlatbaPrj pl ON p.id=pl.id_nositelplatby 

WHERE 	pl.SOUCTOVYRADEK = 'A' ) ostatni

ON ostatni.id=zareg.id

WHERE zareg.plan > ostatni.CZV - ostatni.proplaceno
