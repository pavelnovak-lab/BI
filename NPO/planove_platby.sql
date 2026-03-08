SELECT	v."Èíslo výzvy",
	p."Registraèní èíslo projektu", 
	platba."PORADI#Poøadí finanèního plánu" ,
       platba.kodwfstav ,
       platba."Datum pøedlo¾ení"       ,
       pzf."Pøíspìvek Unie" ,
       pzf."Celkové zpùsobilé výdaje" ,
       CASE WHEN v."Èíslo výzvy" IN ('31_22_001','31_22_005','31_23_116') THEN '7.1 - fotovoltaika'
       	    WHEN v."Èíslo výzvy" = ('31_23_116') THEN '7.1 - distribuce'
	    WHEN v."Èíslo výzvy" = ('31_22_006') THEN '2.3 - teplárenství'
	    ELSE null END AS "Komponenta" ,
platba.souctovyradek	    
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav

WHERE v."Èíslo výzvy" IN ('31_22_001','31_22_005','31_22_006','31_23_116')
AND p.kodwfstav not like ('PN%') 
-- AND p."Registraèní èíslo projektu" = 'CZ.31.3.0/0.0/0.0/22_001/0006710'
AND platba.SOUCTOVYRADEK is not null 

