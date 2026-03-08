SELECT v."Číslo výzvy",
    v."Název výzvy",
    p."Registrační číslo projektu",
    p."Název projektu CZ",
    p."IČ",
    p.zadatel,
    LISTAGG(DISTINCT ciu."Název",';') WITHIN GROUP (ORDER BY ciu."Název") AS "Místa realizace",
    p.kodwfstav,
    p."Datum zahájení předp",
    p."Datum ukončení předp",
    
    indose."Ind. 3 | Povinný k naplnění?" ,
    indose."Ind. 3 | Dosažená hodnota" ,
    indose."Ind. 3 | Cílová hodnota" ,    

    indose."Ind. 4 | Povinný k naplnění?" ,
    indose."Ind. 4 | Dosažená hodnota" ,
    indose."Ind. 4 | Cílová hodnota" ,    

    indose."Ind. 5 | Povinný k naplnění?" ,
    indose."Ind. 5 | Dosažená hodnota" ,
    indose."Ind. 5 | Cílová hodnota" ,    

    indose."Ind. 28 | Povinný k naplnění?" ,
    indose."Ind. 28 | Dosažená hodnota" ,
    indose."Ind. 28 | Cílová hodnota" ,    


    m05."Celkové způsobilé výdaje" AS "CZV aktuálně",
    m05."Příspěvek Unie" AS "Příspěvek Unie",

    rf.CASTKASCHVALENA AS "Proplaceno (EU podíl)"
    

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id = p.id_vyzva
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id = platba.id_NositelPlatby AND platba.souctovyradek IS NULL
-- Formulář F1-C mají jen podané ŽoP, projekt s RoPD, ale může být v PN40* a nemít podanou ŽoP
LEFT JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel IN (361356) -- řádek 10a na formuláři F1-C na ŽoP
INNER JOIN isum.V_BI_UMFPFCELKEM m05 ON m05.ID_PROJEKT = p.id AND m05.id_faze = 99991000000000005

INNER JOIN (SELECT ind.id_nositelindi,

		   max(CASE WHEN i."Kód NČI 2014+" = '00003' THEN ind."Povinný k naplnění" END) "Ind. 3 | Povinný k naplnění?" ,
		   MAX(CASE WHEN i."Kód NČI 2014+" = '00003' THEN ind."Dosažená hodnota" END) "Ind. 3 | Dosažená hodnota" ,
		   MAX(CASE WHEN i."Kód NČI 2014+" = '00003' THEN ind."Cílová hodnota" END) "Ind. 3 | Cílová hodnota" ,

		   MAX(CASE WHEN i."Kód NČI 2014+" = '00004' THEN ind."Povinný k naplnění" END) "Ind. 4 | Povinný k naplnění?" ,
		   MAX(CASE WHEN i."Kód NČI 2014+" = '00004' THEN ind."Dosažená hodnota" END) "Ind. 4 | Dosažená hodnota" ,
		   MAX(CASE WHEN i."Kód NČI 2014+" = '00004' THEN ind."Cílová hodnota" END) "Ind. 4 | Cílová hodnota" ,

		   MAX(CASE WHEN i."Kód NČI 2014+" = '00005' THEN ind."Povinný k naplnění" END) "Ind. 5 | Povinný k naplnění?" ,
		   MAX(CASE WHEN i."Kód NČI 2014+" = '00005' THEN ind."Dosažená hodnota" END) "Ind. 5 | Dosažená hodnota" ,
		   MAX(CASE WHEN i."Kód NČI 2014+" = '00005' THEN ind."Cílová hodnota" END) "Ind. 5 | Cílová hodnota" ,

		   MAX(CASE WHEN i."Kód NČI 2014+" = '00028' THEN ind."Povinný k naplnění" END) "Ind. 28 | Povinný k naplnění?" ,
		   MAX(CASE WHEN i."Kód NČI 2014+" = '00028' THEN ind."Dosažená hodnota" END) "Ind. 28 | Dosažená hodnota" ,
		   MAX(CASE WHEN i."Kód NČI 2014+" = '00028' THEN ind."Cílová hodnota" END) "Ind. 28 | Cílová hodnota"

	   FROM isum.v_bi_UmvIndiHodnotaPRJ ind
	   INNER JOIN isum.v_bi_UmvIndikator i ON i.id = ind.id_indikator

	   WHERE i."Kód NČI 2014+" IN ('00003', '00004', '00005','00028')

	   GROUP BY ind.id_nositelindi)
	   
	   indose ON indose.id_nositelindi = p.id 

LEFT JOIN isum.v_bi_UmzPrjUmisteni um ON um.id_projekt = p.id AND um.typ = 0
LEFT JOIN isum.v_bi_UmsCisZakladni ciu ON um.id_uzemnijednotky = ciu.id

WHERE v."Číslo výzvy" IN ('31_22_008', '31_22_018', '31_22_010', '31_25_157') 
AND REGEXP_LIKE(p.kodwfstav, 'P[NPU][34][0-6][ab]?') -- projekty po PP30 včetně
-- AND p."Registrační číslo projektu" = 'CZ.31.5.0/0.0/0.0/22_008/0005361'

GROUP BY v."Číslo výzvy",
    v."Název výzvy",
    p."Registrační číslo projektu",
    p."Název projektu CZ",
    p."IČ",
    p.zadatel,
    p.kodwfstav,
    p."Datum zahájení předp",
    p."Datum ukončení předp",
    indose."Ind. 3 | Povinný k naplnění?" ,
    indose."Ind. 3 | Dosažená hodnota" ,
    indose."Ind. 3 | Cílová hodnota" ,    
    indose."Ind. 4 | Povinný k naplnění?" ,
    indose."Ind. 4 | Dosažená hodnota" ,
    indose."Ind. 4 | Cílová hodnota" ,    
    indose."Ind. 5 | Povinný k naplnění?",
    indose."Ind. 5 | Dosažená hodnota", 
    indose."Ind. 5 | Cílová hodnota" ,    
    indose."Ind. 28 | Povinný k naplnění?" ,
    indose."Ind. 28 | Dosažená hodnota" ,
    indose."Ind. 28 | Cílová hodnota" ,    
    m05."Celkové způsobilé výdaje" ,
    m05."Příspěvek Unie" ,
    rf.CASTKASCHVALENA 
    
