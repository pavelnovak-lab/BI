SELECT p."Registraèní èíslo projektu" ,
       w."Kód" "Kód stavu"
from projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN smlouva s ON id_nositelsml = p.id
INNER JOIN historie_stavu hs ON hs.nositelid = s.id
INNER JOIN ciselnik_stav_workflow pa ON pa.id = hs.id_stavdo
-- INNER JOIN ciselnik_stav_workflow pawfz ON pwf.id = hs.id_z
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  

WHERE pa."Kód" = 'P1'
-- AND w."Kód" IN ( 'PN20b', 'PN20a')
AND v."Èíslo výzvy" = '01_24_049'
