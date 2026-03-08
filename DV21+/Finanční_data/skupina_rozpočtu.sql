SELECT p."Registraèní èíslo projektu",
       pl."Èíslo platby" ,
       pl.id,
       w."Kód" "Kód stavu"

FROM projekt p
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id  

WHERE p."Registraèní èíslo projektu" IN ('CZ.01.01.01/04/23_030/0003524','CZ.01.01.01/04/23_030/0003487','CZ.01.01.01/04/23_030/0003414','CZ.01.01.01/04/23_040/0004758','CZ.01.01.01/04/23_040/0005197','CZ.01.01.01/04/23_040/0005586')

ORDER BY p."Registraèní èíslo projektu" 
