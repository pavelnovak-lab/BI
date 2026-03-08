SELECT p."Registraèní èíslo projektu",
       p.kodwfstav ,
       platba.CISLOPLATBYZKR,
       platba.kodwfstav ,
       platba."PORADI#Poøadí finanèního plánu",
       platba."Datum pøedlo¾ení",
       platba."VYUCTPLAN#Vyúètování plán",
       hs.datumod "Datum pøepnutí do PP30"

FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id 


WHERE platba.SouctovyRadek is null 
AND hs.stavdo = 'PP30'
AND trunc(hs.datumod) < to_date('2021-09-23','yyyy-mm-dd')
AND p.kodwfstav not like ('PN%') 

ORDER BY substr(p."Registraèní èíslo projektu",-5,5), platba."PORADI#Poøadí finanèního plánu" asc


