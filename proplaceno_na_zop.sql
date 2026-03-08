SELECT platba."Èíslo ¾ádosti o platbu" ,
       platba.kodwfstav,
       platba."Datum zmìny stavu",
       rf.CASTKAPOZADOVANA "Po¾adovaná èástka" ,
       rf.CASTKASCHVALENA  "Schválená èástka",
       rf.CASTKASCHVALENAPCO "Schváleno pro S® PCO",
       rfc.CASTKAPOZADOVANA "Po¾adované procento",
       rfc.CASTKASCHVALENA  "Schválené procento",
       rfc.CASTKASCHVALENASZPCO "Schválené procento pro S® PCO"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361346) -- AND rf.castkaschvalena <> rf.castkapozadovana-- øádky cis.
INNER JOIN isum.v_bi_UmpRozpisFin rfc ON rfc.id_platba = platba.id AND rfc.id_ukazatel in ( 361357 ) -- øádky cis.

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
-- AND platba."Èíslo ¾ádosti o platbu" = 'CZ.01.1.02/0.0/0.0/17_147/0020565/2023/003/POST'
AND rfc.castkaschvalena <> rfc.castkapozadovana
AND rfc.castkaschvalena <> 0
AND platba.kodwfstav like ('P1%') 


-- GROUP BY platba."Èíslo ¾ádosti o platbu" ,
--        platba.kodwfstav,
--        platba."Datum zmìny stavu"
