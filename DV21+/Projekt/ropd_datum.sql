SELECT p."Registraèní èíslo projektu" ,
       -- w."Kód" "Kód stavu", 
       hs.*
from projekt p
INNER JOIN historie_stavu hs ON hs.nositelid = p.id
INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo

WHERE pwf."Kód" = 'PN30'

ORDER BY hs."Datum od"
