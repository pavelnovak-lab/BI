SELECT p."Registraèní èíslo projektu" ,
       isg."Èíslo integrované strategie",
       isg."Název integrované strategie",
       sr.*

FROM projekt p
INNER JOIN integrovane_strategie isg ON isg.id = p.id_isg
INNER JOIN strategicky_ramec_hierarchie sr ON sr.id_strategie = isg.id


WHERE p."Registraèní èíslo projektu" IN ('CZ.01.02.01/01/23_026/0005920','CZ.01.02.01/01/23_026/0005140','CZ.01.02.01/01/23_026/0005648','CZ.01.02.01/01/23_026/0005777','CZ.01.02.01/01/23_026/0005980','CZ.01.02.01/01/23_026/0005629','CZ.01.02.01/01/23_026/0005410')
