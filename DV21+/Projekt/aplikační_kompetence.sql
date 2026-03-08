SELECT op."Název specifického cíle/opatření" as "Opatření",
       p."Registrační číslo projektu",
       w."Kód" "Kód stavu" ,
       CASE WHEN pm.id_uzivatel = 68548708 THEN 'Iveta Vinklerová'
       	    WHEN pm.id_uzivatel = 24935409 THEN 'Vladimír Boura'
	    WHEN pm.id_uzivatel = 196314351 THEN 'Kristýna Blažková'
	    WHEN pm.id_uzivatel = 24947455 THEN 'Ilona Kubešová'
	    WHEN pm.id_uzivatel = 196314351 THEN 'Kristýna Blažková'
	    WHEN pm.id_uzivatel = 24947455 THEN 'Ilona Kubešová'
	    WHEN pm.id_uzivatel = 196314351 THEN 'Kristýna Blažková'
	    WHEN pm.id_uzivatel = 28435929 THEN 'Petra Hájková'
	    WHEN pm.id_uzivatel = 68500820 THEN 'Michaela Grachová'
	    WHEN pm.id_uzivatel = 28429067 THEN 'Anna Faltysová'
	    WHEN pm.id_uzivatel = 68566379 THEN 'Ivana Antoňová'
	    WHEN pm.id_uzivatel = 28429115 THEN 'Jakub Koula'
	END "Manažer projektu",
	pm."Hlavní",
	pm."Veldejší"


FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN projekt_odpovednost pm ON pm.id_prjgg = p.id
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil

WHERE pm."Datum do" is null
AND w."Kód" not like 'PN%'
-- AND pm."Vedlejší" = 'A'
AND p."Registrační číslo projektu" IN ('CZ.01.03.01/01/23_037/0003112','CZ.01.01.02/01/23_023/0004088','CZ.01.01.02/01/23_023/0004079','CZ.01.01.02/01/23_023/0004135','CZ.01.01.02/01/23_023/0004103','CZ.01.01.02/01/23_023/0004059','CZ.01.01.02/01/23_023/0004091')
--AND pm.id_uzivatel IN ('186268804','162784611')		
