SELECT p."Registraèní èíslo projektu",
       pwf."Kód" , 
       hs."Datum od" ,
       zor."Poøadí"

FROM projekt p
INNER JOIN zprava_o_realizaci zor ON zor.id_zad = p.id
-- INNER JOIN ciselnik_stav_workflow w ON zor.id_wfstav = w.id
INNER JOIN historie_stavu hs ON hs.nositelid = zor.id
INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo

WHERE pwf."Kód" = 'Z2'
AND p."Registraèní èíslo projektu" = 'CZ.01.02.01/04/23_017/0002007'
AND hs."Datum od" > to_date('yyyy-MM-dd HH:mm:ss','2024-12-05 12:00:00')


ORDER BY hs."Datum od" 
