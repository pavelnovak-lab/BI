SELECT
       -- vypr."Název" "Vypracoval",
       -- count(platba."Číslo žádosti o platbu") AS "Počet ŽoP" ,
       -- sum(rf.CASTKASCHVALENA) AS "Celkem schváleno"
       platba."Číslo žádosti o platbu" ,
       rf.castkaschvalena
       -- hod.datumzverejnenihodn "Datum schválení KL"       

    
FROM
isum.v_bi_UmpPlatbaPrj platba
-- INNER JOIN isum.v_bi_UMVKontrolaNaMiste knm ON knm.ID_NOSITELKONTROLY = platba.id_NositelPlatby 
-- LEFT JOIN isum.v_bi_UmvHodnoceni hod ON hod.id_kontrola = knm.id AND hod.ID_SOUBORKRIT = 1292529288 -- Kontrolní list č.1127-OPPIK-KL pro autorizaci platby - IP - platnost 25. 3. 2021
-- INNER JOIN isum.V_BI_UMSZamestnanec vypr ON vypr.id = hod.Id_Vypracoval
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356  -- řádky cis."Kód" in ('10a') 
INNER JOIN
(SELECT max(hs.DatumOd) AS Datum,
	hs.nositelid
 FROM isum.v_bi_UmsWFHistorieStavu hs
 WHERE hs.id_stavdo = 171849 -- stav P6
 -- Ve stavu Schválená 1. stupeň podepsaná (P5T) je max 80 dní od schválení KL v poznámce u hod, toto je vazva KL na ŽoP
 GROUP BY hs.NositelId
 ) last_P5T ON last_P5T.nositelid = platba.id and last_P5T.Datum between to_date('2022-03-01','yyyy-mm-dd') AND to_date('2023-03-31','yyyy-mm-dd')




WHERE platba."Číslo žádosti o platbu" like 'CZ.01.5%'
-- AND hod.platnost='A'
-- AND hod.schvalenoschval='A'
-- -- AND :datum_KL between trunc(hod.DATUMHODNOCENI) AND  hod.DATUMHODNOCENI + INTERVAL '40' DAY
-- AND hod.DATUMHODNOCENI between :datum_od AND :datum_od + INTERVAL '30' DAY
-- AND hod.DATUMHODNOCENI between last_P5T.Datum - INTERVAL '7' DAY AND last_P5T.Datum 
-- (sysdate - INTERVAL '30' DAY) AND sysdate
-- AND platba."Číslo žádosti o platbu" = 'CZ.01.4.04/0.0/0.0/16_066/0009453/2020/005/POST'
-- AND hod.DATUMZVEREJNENIHODN between :datum_od AND :datum_od  + 30
-- AND hod.datumzverejnenihodn between to_date('2022-03-01','yyyy-mm-dd') AND to_date('2023-03-31','yyyy-mm-dd')
-- GROUP BY vypr."Název"

ORDER BY platba."Číslo žádosti o platbu" 
