SELECT p."Registraèní èíslo projektu"

FROM projekt p
INNER JOIN historie_stavu hs ON hs.nositelid = p.id
INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo

WHERE pwf.stavdo like 'PP24%'
