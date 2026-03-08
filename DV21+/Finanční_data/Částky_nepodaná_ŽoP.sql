SELECT p."Registraèní èíslo projektu" ,
       cuk."Kód", 
       rf.*
       

FROM projekt p
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id 
INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel -- AND cuk."Kód" like '7%' -- øádek F1-C EU celkem


WHERE p."Registraèní èíslo projektu" = 'CZ.01.05.02/01/23_028/0002687'
