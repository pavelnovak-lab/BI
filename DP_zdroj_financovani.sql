SELECT p."Registraèní èíslo projektu" ,
       p.zadatel,
       platba."Datum zmìny stavu" ,
       platba."PORADI#Poøadí finanèního plánu" "Poøadí ®oP",
       -- dp.druhdp,
       dp.REGCISLO "Detail platby",
       ci."Kód",
       ci."Název",
       CASE WHEN (dp."Èástka (CZK)" = 0 OR dp."Èástka (CZK)" is null)  THEN dp."Èástka v CZK ¾ádost"
       	    ELSE dp."Èástka (CZK)" END "Èástka v CZK",
       CASE WHEN dp.druhdp = 0 THEN 'SR'
       	    WHEN dp.druhdp = 1 THEN 'EU'
       	    ELSE null END "SR/EU èást",
       dp."Zálohová platba"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
LEFT JOIN isum.v_bi_umpklasifikace dp ON dp.id_platba = platba.id AND dp.druhdp IN (0,1)
-- INNER JOIN isum.V_BI_UMSRSVerzeUctu uc ON uc.id = dp.id_ucetoss
-- INNER JOIN isum.v_bi_UMSCisZdrojeF zdroj ON zdroj.id = dp.id_zdrojfin
LEFT JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = dp.id_zdroj


WHERE p."Registraèní èíslo projektu" IN ('CZ.01.5.125/0.0/0.0/15_020/0005956' ,'CZ.01.5.125/0.0/0.0/15_020/0015483','CZ.01.5.125/0.0/0.0/15_020/0019693','CZ.01.5.125/0.0/0.0/15_020/0006102','CZ.01.5.125/0.0/0.0/15_020/0015375')
-- AND dp.id IN (189876230, 189876236)



ORDER BY p."Registraèní èíslo projektu" , platba."PORADI#Poøadí finanèního plánu"  , dp.druhdp
