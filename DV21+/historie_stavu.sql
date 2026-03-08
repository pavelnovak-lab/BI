SELECT platba."Èíslo platby" ,
       platba."Závìreèná platba",
swf.*, hs.*

FROM platba platba
INNER JOIN historie_stavu hs ON hs.nositelid = platba.id
INNER JOIN ciselnik_stav_workflow swf ON swf.id = hs.id_stavdo


WHERE platba."Èíslo platby" IN ('CZ.01.01.01/05/22_004/0000079/2023/001/POST','CZ.01.01.01/05/22_004/0000340/2023/001/POST','CZ.01.01.01/05/22_004/0001267/2023/001/POST','CZ.01.01.01/05/22_004/0001405/2023/001/POST','CZ.01.01.01/05/23_009/0001454/2023/001/POST','CZ.01.01.01/05/23_009/0001494/2023/001/POST','CZ.01.04.01/01/22_006/0000009/2023/001/POST','CZ.01.04.01/01/22_006/0000263/2023/001/POST')
