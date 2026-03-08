SELECT -- platba."Èíslo ¾ádosti o platbu",
       -- platba."Datum zmìny stavu" ,
       -- platba.kodwfstav "St,
       dp."Export do ÚIS" ,
       dp.regcislo
       -- uc."Èíslo úètu prezentaèní forma"
       
FROM isum.v_bi_UmpPlatbaPrj platba 
INNER JOIN isum.v_bi_umpklasifikace dp ON dp.id_platba = platba.id
-- INNER JOIN isum..V_BI_UMSRSVerzeUctu uc ON uc.id = dp.id_ucetoss



WHERE dp.druhdp = 1
-- AND platba.kodwfstav IN ('P5T','P6','P6T')
-- dp.id = 1980638693
AND platba."Èíslo ¾ádosti o platbu" IN ('CZ.01.1.02/0.0/0.0/20_321/0025219/2024/003/POST','CZ.01.1.02/0.0/0.0/20_321/0025219/2023/002/POST')

ORDER BY dp.regcislo
