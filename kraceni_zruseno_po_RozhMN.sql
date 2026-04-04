SELECT DISTINCT 
       platba."Číslo žádosti o platbu",
       platba."Datum změny stavu",
       platba.kodwfstav "Stav ŽoP" ,
       platba."Krácení dokladů provedeno",
       platba."VYUCTPLAN#Vyúčtování plán" ,
       platba."VYUCTSKUT",
       platba."VYUCTPLAN#Vyúčtování plán" - platba."VYUCTSKUT" AS "Zkráceno o",	
       platba."Částka CZK dot 14f mimo MS I",
       platba."Částka CZK dot 14f mimo MS NeI"



       -- priloha.nazevpril
       -- rf.CASTKAPOZADOVANA "Částka vyúčtovaná",
       -- rf.CASTKASCHVALENA "Částka schválená",
       -- rf.CASTKAPOZADOVANA  - rf.CASTKASCHVALENA  AS "Zkráceno o",
       -- priloha.nazevpril

FROM  isum.v_bi_UmpPlatbaPrj platba 
-- INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356 -- řádek 10a
-- INNER JOIN isum.v_bi_UmsCisZakladni cis ON rf.id_ukazatel=cis.id
INNER JOIN isum.v_bi_UMSPrilohyPlatba priloha ON priloha.id_nositelpril = platba.id AND platba.id_wfstav = 171855



WHERE
-- platba.kodwfstav in ('P10') 
-- platba.id_NositelPlatby = 160126294
-- AND p."Registrační číslo projektu" is not null
regexp_like(priloha.nazevpril, '.*(Kraceni|Krácení|kraceni|krácení|ministra|Ministra).*')
AND trunc(platba."Datum změny stavu") < to_date('2022-01-01','yyyy-mm-dd')
AND trunc(platba."Datum změny stavu") >= to_date('2021-01-01','yyyy-mm-dd')

-- AND EXISTS
-- (SELECT 0
--  FROM isum.v_bi_UMSPrilohyPlatba priloha 
--  WHERE regexp_like(priloha.nazevpril, '.*(kraceni|krácení|ministra|Ministra).*')
--  AND priloha.id_nositelpril = platba.id)
