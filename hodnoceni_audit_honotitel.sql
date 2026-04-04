SELECT hodnotitel."Délka praxe" ,
       hodnotitel.id ,
       hodnotitel."Kód",
       prg.POCETHODNHODN,
       prg.RATINGZNAMKANAPOCETH ,
       LISTAGG(DISTINCT noh."Název" , '; ' on overflow truncate) WITHIN GROUP (ORDER BY noh."Název") "Odbornosti EH" ,
       LISTAGG(DISTINCT vs."Název subjektu", '; ' on overflow truncate) "Název zaměstnavatele",
       LISTAGG(DISTINCT vs."IČ",  '; ' on overflow truncate) "IČ zaměstnavatele" ,
 
       hodnotitel."Externí hodnotitel" "EH" 
       -- ci."Kód" "Kód úrovně vzdělání",
       -- ci."Název" "Úroveň vzdělání" ,
       -- cis."Kód" "Kód titul",
       -- cis."Název" "Název titul"

       
FROM isum.v_bi_UmvHodnotitel hodnotitel
INNER JOIN isum.v_bi_UmvHodnotitelPrg prg ON prg.id_hodnotitel = hodnotitel.id 
LEFT JOIN isum.v_bi_UmvHodnOdbornost oh ON oh.id_hodnotitelprg = prg.id
INNER JOIN isum.v_bi_UMSCisOdbornost noh ON noh.id = oh.id_odbornost
LEFT JOIN isum.v_bi_UMVHodnVerzeSubjektu vs  ON vs.id_hodnotitel = hodnotitel.id
-- LEFT JOIN isum.v_bi_UMVHODNVZDELANI vzd ON vzd.id_hodnotitel = hodnotitel.id
-- LEFT JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  vzd.id_urovenvzdelani
-- LEFT JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vzd.id_tituljm  



WHERE
-- hodnotitel."Kód" = '4245'
-- prg.id_hodnotitel = 222861414
prg.id_program = 172133


GROUP BY  hodnotitel."Délka praxe" ,
       hodnotitel.id,
       hodnotitel."Kód",
       prg.POCETHODNHODN,
       prg.RATINGZNAMKANAPOCETH,
       hodnotitel."Externí hodnotitel"


----------------------------------------
SELECT * 
FROM isum.v_bi_UMSCISseznam
WHERE "Kód" = 178


select ci.*
FROM isum.v_bi_UmsCisZakladni ci
WHERE ci.id_umscisseznam = 198482


SELECT vzd.*

FROM isum.v_bi_UMVHODNVZDELANI vzd

WHERE vzd.CREATE_UZIVATEL = 'GHULLBOH'


WHERE vzd.id = 779280976

WHERE vzd.id_hodnotitel = 227027251
