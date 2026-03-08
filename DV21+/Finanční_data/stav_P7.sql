SELECT pl."»Ìslo platby",
       hs.*
       , pwf."KÛd"

FROM platba pl
INNER JOIN historie_stavu hs ON hs.nositelid = pl.id
INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo

WHERE pl."»Ìslo platby" = 'CZ.01.04.01/01/22_006/0000018/2023/001/POST'
AND pwf."KÛd" = 'P7'
