SELECT	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	p."Registraèní èíslo projektu" as "Registraèní èíslo projektu",
	p.kodwfstav "Stav projektu",
       fp."Pøíspìvek Unie" "Dotace",
	platba."Datum pøedlo¾ení",
	platba."Datum navrácení",
	platba.DATUMVYTVORENI "Datum vytvoøení",
	platba.kodwfstav "Stav platby",
	platba."Datum zmìny stavu",
	platba."Závìreèná platba" as "Závìreèná platba",
	platba.ZALOHACZVCELK	
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UmfPFCelkem fp ON fp.id_projekt = p.ID

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND p."Registraèní èíslo projektu" is not null 
AND fp.ID_FAZE=99991000000000005 -- sloupec aktuální stav 
AND platba.SOUCTOVYRADEK IS NULL
AND platba.kodwfstav not IN ('P10','P11','P12','P13','P14','P15','N1','N2')
ANDp.kodwfstav in ('PP30','PP36','PP37','PP40','PU30') 

ORDER BY platba."Datum pøedlo¾ení"
