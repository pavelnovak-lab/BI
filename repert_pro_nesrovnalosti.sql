SELECT platba."Èíslo ¾ádosti o platbu",
       platba."Datum zmìny stavu",
       platba.kodwfstav "Stav ®oP" ,
       platba."Krácení dokladù provedeno",
       rf.castkapozadovana "Po¾adovaná dotace",
       rf.castkaschvalena "Schválená dotace" ,
       rf.castkapozadovana - rf.castkaschvalena "Kráceno celkem",
       -- min bere Ano, kdy¾ je, proto¾e bere podle abecedy       			   
       min(CASE WHEN (UPPER(priloha.nazevpril) like '%MINISTR%' AND UPPER(priloha.nazevpril) not like '%ADMINISTR%') THEN 'Ano'
       		ELSE 'Ne' END) "Rozhodnutí ministra" ,
       LISTAGG(DISTINCT REPLACE(REPLACE(k.charakter,CHR(10),' $ '),CHR(13),' $ '), '; ') "Charakter krácení"
       
FROM isum.v_bi_UmzPrjGGII p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby  
INNER JOIN isum.v_bi_UMSPrilohyPlatba priloha ON priloha.id_nositelpril = platba.id
LEFT JOIN isum.v_bi_UMPKorekce k ON k.id_platba = platba.id  AND k.souctovyradek is null 
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- øádky cis.



WHERE p.id_prioritniosa IN (406085, 406086, 406087, 406088) -- PO 1-4
AND p.kodwfstav in ('PP37','PP40','PP41','PP42','PP43','PU30')
-- Podmínka bere platby v P11 - krátilo se + ty v P10 (nekrátilo se), kde je v pøílohácho zmínka o rozhodnutí ministra, tedy to znamená úspì¹né odvolání u ministra, syntaxe: UPPER proto¾e LIKE je Oracle SQL  case-sensitive
AND (platba.kodwfstav = 'P11'
     OR
     (platba.kodwfstav = 'P10' AND UPPER(priloha.nazevpril) like '%MINISTR%' AND UPPER(priloha.nazevpril) not like '%ADMINISTR%')
     )
AND trunc(platba."Datum zmìny stavu") < to_date('2025-01-01','yyyy-mm-dd')
AND trunc(platba."Datum zmìny stavu") >= to_date('2024-01-01','yyyy-mm-dd')
-- AND platba."Èíslo ¾ádosti o platbu" = 'CZ.01.1.02/0.0/0.0/21_374/0027103/2023/002/POST'

GROUP BY platba."Èíslo ¾ádosti o platbu",
       platba."Datum zmìny stavu",
       platba.kodwfstav,
       platba."Krácení dokladù provedeno" ,
       rf.castkapozadovana ,
       rf.castkaschvalena ,
       rf.castkapozadovana - rf.castkaschvalena       

ORDER BY platba."Datum zmìny stavu"


----------------------------------------
SELECT platba."Èíslo ¾ádosti o platbu"

WHERE 
