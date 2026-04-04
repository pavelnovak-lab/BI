SELECT	pr."Název",
	tr.popis AS "Objekt",
 	decode (pr."Typ události", 1, 'Změna atributu', 
                                'jiná hodnota')  AS "Typ události",
 	decode (pr."Typ pravidla", 0, 'Událostní', 
                                'jiná hodnota') AS "Typ pravidla",
	
	REPLACE(REPLACE(pr."Popis",CHR(10),' $ '),CHR(13),' $ ') as "Popis",
	pr.podminka AS "Podmínka pravidla" ,
	pr."Platnost",
	pr.create_uzivatel AS "Správce pravidla",
	sabl.nazev AS "Název šablony depeší",
	sabl.predmet AS "Předmět" ,
	sabl."Popis šablony",
	sabl."Správce šablony",
	sabl.SEZNAMEDITORUTEXT AS "Seznam editorů šablony",
	REPLACE(REPLACE( sabl."Vzor depeše",CHR(10),' $ '),CHR(13),' $ ') as "Vzor depeše" ,
	atr.popis AS "Atribut pravidla",
	cu.*
	
FROM isum.v_bi_UMSPravidlo pr
INNER JOIN isum.v_bi_UMSUdalostTrida tr ON tr.id = pr.id_trida
INNER JOIN isum.v_bi_UMSSablonaZpravy sabl ON sabl.id = pr.id_sablona
INNER JOIN isum.v_bi_UMSUdalostAtribut atr ON atr.id = pr.id_atribut
INNER JOIN isum.V_BI_CUzivatel cu ON cu.id = pr.id_vlastnikobjektu

WHERE pr."Platnost" = 'A'
AND pr."Název" like 'OPPIK%'
-- pr.id = 1278629373





