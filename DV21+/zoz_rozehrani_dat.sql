SELECT 

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN zmena zoz ON zoz.id_zad = p.id
INNER JOIN historie_stavu hs ON hs.nositelid = p.id
INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo 
