SELECT p."Registraèní èíslo projektu",
       p."Název projektu CZ",
       p.eu,
       p.czv,
       platba.VYUCTSKUT "Schválené vyuètování",
       platba.kodwfstav,
       platba.wfstav,
       platba.CISLOPLATBYZKR,
       platba."Èíslo ¾ádosti o platbu",
       platba.SOUCTOVYRADEK,
       platba."Datum zmìny stavu",
       platba."ZALOHASKUT" "Po¾adovaná záloha"

FROM isum.v_bi_UmzPrjGG p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmpPlatba platba ON p.id=platba.id_NositelPlatby
-- INNER JOIN isum.v_bi_UmpCastkySchval castky ON platba.id_SchvaleneCastky=castky.id

WHERE p."Registraèní èíslo projektu" = 'CZ.01.5.125/0.0/0.0/15_020/0019691'
-- AND   v."Èíslo výzvy" = '01_15_020'
-- AND   platba.SOUCTOVYRADEK <> 'A'
-- AND   platba."Èíslo ¾ádosti o platbu" = 'CZ.01.5.125/0.0/0.0/15_020/0005785/2016/001/ANTE'

-- AND platba.kodwfstav = 'P1'

ORDER BY substr(p."Registraèní èíslo projektu",-5,5), platba.cisloplatbyzkr asc 
