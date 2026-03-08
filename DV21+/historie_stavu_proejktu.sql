SELECT p."Registraèní èíslo projektu",
       w."Kód" "Kód aktuálního stavu" ,
       z."Kód" "Pøepnuto z" ,
       do."Kód" "Pøepnuto do",
       -- count(hs.id)
       hs."Datum pøepnutí"



FROM projekt p 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN historie_stavu hs ON hs.nositelid = p.id
INNER JOIN ciselnik_stav_workflow do ON pwf.id = hs.id_stavdo
INNER JOIN ciselnik_stav_workflow z ON pwf.id = hs.id_z


WHERE p."Registraèní èíslo projektu" like '%2044'
AND w."Kód" = 'PN20b'
AND do."Kód" = 'PN20b'
AND z."Kód" = 'PP20'

-- ('CZ.01.02.01/07/23_021/0002918','CZ.01.02.01/07/23_021/0002635','CZ.01.02.01/07/23_021/0001805','CZ.01.02.01/07/23_021/0002897','CZ.01.02.01/07/23_021/0001496','CZ.01.02.01/07/23_021/0002723','CZ.01.02.01/07/23_021/0002717','CZ.01.02.01/07/23_021/0002472','CZ.01.02.01/07/23_021/0002130','CZ.01.02.01/07/23_021/0002705','CZ.01.02.01/07/23_021/0002117','CZ.01.02.01/07/23_021/0002243','CZ.01.02.01/07/23_021/0002475','CZ.01.02.01/07/23_021/0001946','CZ.01.02.01/07/23_021/0002020')


-- GROUP BY p."Registraèní èíslo projektu", pwf."Kód" 


SELECT p."Registraèní èíslo projektu",
       w."Kód" "Kód aktuálního stavu" ,
       z."Kód" "Pøepnuto z" ,
       do."Kód" "Pøepnuto do",
       -- count(hs.id)
       hs."Datum pøepnutí"



FROM projekt p 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN historie_stavu hs ON hs.nositelid = p.id
INNER JOIN ciselnik_stav_workflow do ON do.id = hs.id_stavdo
INNER JOIN ciselnik_stav_workflow z ON z.id = hs.id_stavz


WHERE 
-- p."Registraèní èíslo projektu" like '%2044'
-- AND w."Kód" = 'PN20b'
 do."Kód" = 'PN20b'
AND z."Kód" = 'PP20'


ORDER BY hs."Datum pøepnutí"
