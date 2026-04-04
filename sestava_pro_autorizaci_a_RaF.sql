CREATE or REPLACE view "Schválena 2. stupeň" FOLDER=  AS 
SELECT op.nazev as "Opatření" ,
       pl."Číslo platby",
       s."Název subjektu" ,
       -- s."IČ" ,
       -- pl."Vyúčtování - skutečnost",
       pl."Schvalil2Stdatum" "Datum schválení 2. stupeň" ,
       -- EXTRACT(DOW from pl."Schvalil2Stdatum"),
       pwf."Kód" "Stav ŽoP",
       rf."Schválená záloha ZS/ŘO v této ŽoP",
       rf."Schválené vyúčtování ZS/ŘO v této ŽoP" ,
       plwf."Kód" "Schválena P6T/P9T",
       hs."Datum od" "Datum schválení"
       -- addday(hs."Datum od", - 2 ) "Schváleno bez dvou dnů",
       -- EXTRACT(DOW FROM "Datum od") "Den schválení",
       -- TRUNC(hs."Datum od")
       
FROM projekt p 
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN platba pl ON pl.id_nositelplatby = p.id 
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462 -- žadatel 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
-- INNER JOIN INNER JOIN historie_stavu hs ON hs.nositelid = pl.id
INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = pl.id_wfstav -- hs.id_stavdo 
INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id 
INNER JOIN ciselnik_ukazatel_rozpis_financovani cu ON  rf.id_ukazatel = cu.id AND cu."Kód" = '7'
INNER JOIN historie_stavu hs ON hs.nositelid = pl.id
INNER JOIN ciselnik_stav_workflow plwf ON plwf.id = hs.id_stavdo AND plwf."Kód" IN ('P6T','P9T')

WHERE
-- pl."Číslo platby" IN ('CZ.01.04.01/01/22_006/0000030/2023/001/POST', 'CZ.01.07.01/01/23_022/0003010/2024/001/ANTE','CZ.01.01.01/05/23_009/0001986/2024/001/POST')

pwf."Kód" IN ('P6T','P9T','P10','P11')
-- AND pl."Schvalil2Stdatum"

AND (
	(
	EXTRACT(DOW FROM NOW()) in (5,6,0) --sobota-pondělí	
     	AND trunc(addday(now(),-3)) <= hs."Datum od"
	AND hs."Datum od" <= trunc(addday(now(),-1))
	)
     	OR
	(
	EXTRACT(DOW FROM NOW()) IN (1,2,3,4) -- útery-pátek	
     	AND trunc(addday(now(),-1)) <= hs."Datum od"
	)
    )

ORDER BY hs."Datum od"


----------------------------------------
SELECT fn."Název FN"
       rf.*

FROM financni_nastroj fn
INNER JOIN platba pl ON pl.id_nositelplatby = fn.id 
INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id
INNER JOIN ciselnik_ukazatel_rozpis_financovani cu ON  rf.id_ukazatel = cu.id AND cu."Kód" = '3a'

WHERE fn."Název FN" = 'Úspory energie - úvěrový fond'


----------------------------------------
select current_data
