select p."Registraèní èíslo projektu" ,
       platba."Èíslo platby" 
       platba."Datum proplacení pøíjemci / vypoøádání"

from projekt p
INNER JOIN platba platba ON pl.id_nositelplatby = p.id 

where platba."Èíslo ¾ádosti o platbu" IN ('CZ.01.04.01/01/22_006/0001844/2024/001/POST','CZ.01.04.01/01/22_006/0001392/2024/001/POST','CZ.01.04.01/01/22_006/0001200/2024/001/POST','CZ.01.04.01/01/22_006/0001183/2023/001/POST','CZ.01.04.01/01/22_006/0001317/2024/001/POST','CZ.01.04.01/01/22_006/0002140/2024/001/POST','CZ.01.04.01/01/22_006/0000399/2024/001/POST','CZ.01.04.01/01/22_006/0001169/2024/001/POST','CZ.01.04.01/01/22_006/0001157/2024/001/POST')
