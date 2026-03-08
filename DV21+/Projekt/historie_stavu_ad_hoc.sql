-- CREATE or REPLACE view "RIS3_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 

SELECT p."Registraèní èíslo projektu" ,
       w."Kód" "Kód souèasného stavu" ,
       z."Kód" "Stav z" ,
       do."Kód" "Stav do"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN historie_stavu hs ON hs.nositelid = p.id
INNER JOIN ciselnik_stav_workflow z ON z.id = hs.id_stavz
INNER JOIN ciselnik_stav_workflow do ON do.id = hs.id_stado
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  

WHERE pwd."Kód" <> 'PN20b'
AND z."Kód" = 'PN20b'
- -v."Èíslo výzvy" = '01_23_026'
-- AND pwf."Kód" = 'PP30'

-- ORDER BY hs."Datum pøepnutí"


CZ.01.02.01/04/23_017/0002514|CZ.01.02.01/01/23_026/0004470|
