select pl."»Ìslo platby",
       pwf."KÛd" 
       
FROM platba pl
-- INNER JOIN historie_stavu hs ON hs.nositelid = pl.id
INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = pl.id_wfstav

WHERE exists
(SELECT 1
 FROM  historie_stavu hs 
 INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
 WHERE hs.nositelid = pl.id
 AND pwf."KÛd" = 'P14T')
