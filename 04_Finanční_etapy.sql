SELECT	-- SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	v."Èíslo výzvy" ,
	p."Registraèní èíslo projektu" as "Registraèní èíslo projektu",
	p.kodwfstav "Stav projektu",
        fp."Pøíspìvek Unie" "Dotace",
	platba."PORADI#Poøadí finanèního plánu" "Poøadí ®oP",
	platba."VYUCTPLAN#Vyúètování plán" "Plánovaná èástka",
	platba.VYUCTSKUT "Skuteènì proplaceno"    ,
	platba."Datum pøedlo¾ení",
	platba."Datum navrácení",
	platba.DATUMVYTVORENI "Datum vytvoøení",
	platba.kodwfstav "Stav platby",
	platba."Datum zmìny stavu",
	platba."Závìreèná platba" as "Závìreèná platba"
	
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UmfPFCelkem fp ON fp.id_projekt = p.ID
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 

-- WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
WHERE v."Èíslo výzvy" IN ('31_22_001', '31_22_005', '31_22_006')
AND p."Registraèní èíslo projektu" is not null 
AND fp.ID_FAZE=99991000000000005 -- sloupec aktuální stav 
AND platba.SOUCTOVYRADEK IS NULL
-- AND platba.kodwfstav not IN ('P0') 
AND p.kodwfstav not like ('PN%')

ORDER BY v."Èíslo výzvy", p."Registraèní èíslo projektu", platba."Datum pøedlo¾ení"




----

SELECT  substr(p."Registraèní èíslo projektu",7,1) "Kod PO",
	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	platba."Datum pøedlo¾ení" as "Datum pøedlo¾ení",
	v."Název výzvy" as "Název výzvy",
	p."Registraèní èíslo projektu" as "Registraèní èíslo projektu",
	p."ZADATEL" as "ZADATEL",
	platba."PORADI#Poøadí finanèního plánu" as "PORADI#Poøadí finanèního plánu",
	platba."WFSTAV" as "Stav ®opl",
	p."KODWFSTAV" as "KODWFSTAV",
	p."WFSTAV" as "Stav projektu",
	platba."Èíslo ¾ádosti o platbu",
        fp."Celkové zpùsobilé výdaje" "CZV" ,
        fp."Pøíspìvek Unie" "Dotace",
	platba."Závìreèná platba" as "Závìreèná platba",
	platba.id,
	platba."Datum navrácení",
	platba.DATUMVYTVORENI "Datum vytvoøení"


FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmfPFCelkem fp ON fp.id_projekt = p.ID

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND p."Registraèní èíslo projektu" is not null 
AND fp.ID_FAZE=99991000000000005 -- sloupec aktuální stav 
AND platba.SOUCTOVYRADEK IS NULL

-- AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/19_299/0023798'
