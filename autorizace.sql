SELECT vypr."Název" "Vypracoval",
       count(platba."Èíslo ¾ádosti o platbu") AS "Poèet ®oP" ,
       sum(rf.CASTKASCHVALENA) AS "Celkem schváleno"
       -- platba."Èíslo ¾ádosti o platbu" ,
       -- rf.castkaschvalena,
       -- hod.datumzverejnenihodn "Datum schválení KL"       

    
FROM isum.v_bi_UmzPrjGGII p 
INNER JOIN isum.v_bi_UMVKontrolaNaMiste knm ON knm.ID_NOSITELKONTROLY = p.id 
INNER JOIN isum.v_bi_UmvHodnoceni hod ON hod.id_kontrola = knm.id AND hod.ID_SOUBORKRIT = 1440402139 -- Kontrolní list è.1162-OPPIK-KL pro II. stupeò kontroly - úplnost a finanèní kontrola ®oP - platnost 11. 10. 2021
INNER JOIN isum.V_BI_UMSZamestnanec vypr ON vypr.id = hod.Id_Vypracoval
-- INNER JOIN isum.V_BI_UMSZamestnanec schv ON schv.id = hod.id_schvalil
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby -- AND platba.id = 641452886
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356  -- øádky cis."Kód" in ('10a') 
INNER JOIN
(SELECT max(hs.DatumOd) AS Datum,
	hs.nositelid
 FROM isum.v_bi_UmsWFHistorieStavu hs
 WHERE hs.id_stavdo = 171846 -- stav P5T
 -- Ve stavu Schválená 1. stupeò podepsaná (P5T) je max 80 dní od schválení KL v poznámce u hod, toto je vazva KL na ®oP
 GROUP BY hs.NositelId
 ) last_P5T ON last_P5T.nositelid = platba.id and last_P5T.Datum between trunc(hod.Datumzverejnenihodn) -  INTERVAL '80' DAY and trunc(hod.Datumzverejnenihodn)

WHERE hod.platnost='A'
AND hod.schvalenoschval='A'
-- AND :datum_KL between trunc(hod.DATUMHODNOCENI) AND  hod.DATUMHODNOCENI + INTERVAL '40' DAY
-- AND hod.DATUMHODNOCENI between :datum_od AND :datum_od + INTERVAL '30' DAY
-- AND trunc(hod.DATUMHODNOCENI) between (sysdate - INTERVAL '30' DAY) AND sysdate
-- AND platba."Èíslo ¾ádosti o platbu" = 'CZ.01.4.04/0.0/0.0/16_066/0009453/2020/005/POST'
AND hod.DATUMZVEREJNENIHODN between :datum_od AND :datum_od  + 30
-- AND hod.datumzverejnenihodn between to_date('2022-03-01','yyyy-mm-dd') AND to_date('2023-03-31','yyyy-mm-dd')

-- GROUP BY vypr."Název"

ORDER BY sum(rf.CASTKASCHVALENA) DESC
-- ORDER BY vypr."Název", hod.datumhodnoceni
