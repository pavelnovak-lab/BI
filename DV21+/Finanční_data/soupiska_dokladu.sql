select	op.nazev as "Opatøení" ,
	-- p."Registraèní èíslo projektu" ,
	sum(CASE WHEN sd."Èástka bez DPH pøipadající \nProkazované zpùsobilé výdaje" = sd."Celková èástka bez DPH \nuvedená na dokladu" THEN 1
	ELSE 0 END) "Poèet CZV bez DPH je na dokladu",
	count(sd.id) "Poèet dokladù",
	sum(CASE WHEN sd."Èástka bez DPH pøipadající \nProkazované zpùsobilé výdaje" = sd."Celková èástka bez DPH \nuvedená na dokladu" THEN 1
	ELSE 0 END) / count(sd.id) * 100 AS "Procento stejných"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN ciselnik_stav_workflow wpl ON pl.id_wfstav = wpl.id  
INNER JOIN soupiska_doklad sd ON pl.id = sd.id_platba 

WHERE pl."Èíslo platby" = 'CZ.01.04.01/01/22_006/0000007/2023/001/POST'
 AND wpl."Kód"  IN ('P5','P5T','P6','P6T','P7','P7','P8','P8T','P9T','P10','P11','P12','P13','P13T','P14','P14T')
AND sd."Souètový øádek" Is NULL
GROUP BY op.nazev , wpl."Kód" 
