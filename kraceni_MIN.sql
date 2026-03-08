SELECT platba."Èíslo ¾ádosti o platbu",
       platba."Datum zmìny stavu",
       platba.kodwfstav "Stav ®oP" ,
       platba."Krácení dokladù provedeno",
       -- platba."VYUCTPLAN#Vyúètování plán" ,
       platba."VYUCTSKUT",
       rf.CASTKAPOZADOVANA "Scháleno", 
       rf.CASTKAPOZADOVANA - platba."VYUCTSKUT"  AS "Zkráceno o",	
       -- platba."Èástka CZK dot 14f mimo MS I",
       -- platba."Èástka CZK dot 14f mimo MS NeI",
       -- platba.id
       -- LISTAGG( priloha.nazevpril, '; ') "Název pøíloh",
       LISTAGG( priloha.nazevpril, '; ') "Název pøíloh"

       
FROM isum.v_bi_UmzPrjGGII p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby  
INNER JOIN isum.v_bi_UMSPrilohyPlatba priloha ON priloha.id_nositelpril = platba.id
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id  AND rf.id_ukazatel = 361347 --øádek 2 na F1-C

WHERE p.id_prioritniosa IN (406085, 406086, 406087, 406088) 
AND p.kodwfstav in ('PP37','PP40','PP41','PP42','PP43','PU30')
AND platba.kodwfstav = 'P11'
-- AND platba.id_wfstav = 171855 -- zop v P10
AND trunc(platba."Datum zmìny stavu") < to_date('2024-01-01','yyyy-mm-dd')
AND trunc(platba."Datum zmìny stavu") >= to_date('2023-01-01','yyyy-mm-dd')
AND (UPPER(priloha.nazevpril) like '%KRACENI%' OR UPPER(priloha.nazevpril) like '%KRÁCENÍ%' OR UPPER(priloha.nazevpril) like '%MINISTR%')
AND UPPER(priloha.nazevpril) not like '%ADMINISTR%'

GROUP BY platba."Èíslo ¾ádosti o platbu",
       platba."Datum zmìny stavu",
       platba.kodwfstav,
       platba."Krácení dokladù provedeno",
       -- platba."VYUCTPLAN#Vyúètování plán" ,
       platba."VYUCTSKUT",
       rf.CASTKASCHVALENA,
       platba."VYUCTSKUT" - rf.CASTKASCHVALENA 


----------------------------------------

SELECT platba."Èíslo ¾ádosti o platbu" ,
       platba.vyuctskut "Po¾adováno"
       rf.CASTKASCHVALENA "Scháleno"

FROM isum.v_bi_UmpPlatbaPrj platba
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id  AND rf.id_ukazatel = 361347 --øádek 2 na F1-C

WHERE platba."Èíslo ¾ádosti o platbu" = 'CZ.01.4.04/0.0/0.0/16_066/0009453/2020/005/POST'


JJJJ40-
U4
----------------------------------------
SELECT platba."Èíslo ¾ádosti o platbu",
       platba."Datum zmìny stavu",
       platba.kodwfstav "Stav ®oP" ,
       platba."Krácení dokladù provedeno",
       platba."VYUCTPLAN#Vyúètování plán" ,
       platba."VYUCTSKUT",
       -- platba."VYUCTPLAN#Vyúètování plán" - platba."VYUCTSKUT" AS "Zkráceno o",	
       -- platba."Èástka CZK dot 14f mimo MS I",
       -- platba."Èástka CZK dot 14f mimo MS NeI",
       -- platba.id
       -- LISTAGG( priloha.nazevpril, '; ') "Název pøíloh",
       LISTAGG( priloha.nazevpril, '; ') "Název pøíloh"

       
FROM isum.v_bi_UmzPrjGGII p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby  
INNER JOIN isum.v_bi_UMSPrilohyPlatba priloha ON priloha.id_nositelpril = platba.id


WHERE p.id_prioritniosa IN (406085, 406086, 406087, 406088) 
AND p.kodwfstav in ('PP37','PP40','PP41','PP42','PP43','PU30')
-- AND platba.id_wfstav = 171855 -- zop v P10
AND trunc(platba."Datum zmìny stavu") < to_date('2024-01-01','yyyy-mm-dd')
AND trunc(platba."Datum zmìny stavu") >= to_date('2023-01-01','yyyy-mm-dd')
-- AND (UPPER(priloha.nazevpril) like '%MINISTR%' AND UPPER(priloha.nazevpril) not like '%ADMINISTR%')

GROUP BY platba."Èíslo ¾ádosti o platbu",
       platba."Datum zmìny stavu",
       platba.kodwfstav,
       platba."Krácení dokladù provedeno",
       platba."VYUCTPLAN#Vyúètování plán" ,
       platba."VYUCTSKUT"
