SELECT pl."Číslo platby" ,
       hs.*

FROM platba pl
INNER JOIN historie_stavu hs ON hs.nositelid = pl.id
INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo

WHERE pl."Číslo platby" = 'CZ.01.01.02/01/23_023/0003940/2025/001/POST'
