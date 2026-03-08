CREATE or REPLACE view "kraceni_podle_14ef_pro_nessrovnalosti_a_CHJ" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Finanèní_data' AS	

SELECT pl."Èíslo platby",
       pl."Datum zmìny stavu",
       w."Kód" AS "Stav ®oP",
       rf."Pøedlo¾ené vyúètování v toto ®oP" AS "Po¾adovaná EU dotace",
       rf."Schválené vyúètování ZS/ØO v této ®oP" AS "Schválená EU dotace",
       rf."Pøedlo¾ené vyúètování v toto ®oP" - rf."Schválené vyúètování ZS/ØO v této ®oP" AS "Po¾adováno EU - schváleno EU" ,
       CASE WHEN pril."Název pøíloh" is not null then 'Ano'
       	    ELSE 'Ne' END AS "Rozhodnutí ministra" ,
       GROUP_CONCAT(DISTINCT kr."Typ krácení") AS "Typ krácení 0 - vìcné, 1 - VR, 2 - jiné"

FROM projekt AS p
INNER JOIN platba AS pl ON pl.id_nositelplatby = p.id
INNER JOIN ciselnik_stav_workflow AS w ON pl.id_wfstav = w.id
LEFT JOIN korekce AS kr ON kr.id_platba = pl.id AND kr."Typ krácení" > 0 AND kr."Krácení celkem" > 1
-- INNER JOIN ciselnik_typ_korekce AS typk ON typk.id = kr.id_typkorekce
INNER JOIN rozpis_financovani AS rf ON rf.id_platba = pl.id
INNER JOIN ciselnik_ukazatel_rozpis_financovani AS cuk ON cuk.id = rf.id_ukazatel AND cuk."Kód" IN ('7')
LEFT JOIN ( SELECT GROUP_CONCAT(priloha."Název dokumentu") "Název pøíloh" ,
		   priloha.id_nositelpril
	    FROM platba_priloha priloha
	    WHERE UPPER(priloha."Název dokumentu") like '%MINISTR%'
	    AND UPPER(priloha."Název dokumentu") not like '%ADMINISTR%'
	    GROUP BY priloha.id_nositelpril) pril ON pril.id_nositelpril = pl.id

WHERE w."Kód" REGEXP_LIKE 'P1[0-4][T]?|N1'
-- buï existuje záznam na F1-B typu 1 nebo 2, nebo ho odmazali po rozhodnutí ministra a ®oP je tedy v P10
AND (
    (pril."Název pøíloh" is not NULL AND w."Kód" = 'P10')
    OR
    kr.id IS NOT NULL
    )
AND rf."Pøedlo¾ené vyúètování v toto ®oP" > 1
AND pl."Datum zmìny stavu" < to_date('yyyy-MM-dd','2026-01-01')
AND pl."Datum zmìny stavu" >= to_date('yyyy-MM-dd','2025-01-01')
-- AND pl."Èíslo platby" = 'CZ.01.01.02/01/23_039/0003379/2024/001/POST'


GROUP BY pl."Èíslo platby",
       pl."Datum zmìny stavu",
       w."Kód",
       rf."Pøedlo¾ené vyúètování v toto ®oP",
       rf."Schválené vyúètování ZS/ØO v této ®oP",
       CASE WHEN pril."Název pøíloh" is not null then 'Ano'
       	    ELSE 'Ne' END
	    
ORDER BY pl."Datum zmìny stavu" ASC
