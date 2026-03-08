SELECT p."Registraèní èíslo projektu",
       pf."Pøíspìvek Unie" "Dotace RoPD" , 
       pfzoz."Pøíspìvek Unie" "Aktuální stav" ,
       c."Proplaceno"
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000011 -- aktuální stav
INNER JOIN prehled_zdroju_financovani pfzoz ON pfzoz.id_projekt = p.id AND pfzoz.id_faze = 99991000000000005 -- aktuální stav 
INNER JOIN (SELECT sum(rf."Schválené vyúètování ZS/ØO v této ®oP") "Proplaceno",
      	    	   pl.id_nositelplatby
            FROM platba pl
	    INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id  
	    INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id 
	    INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel AND cuk."Kód" = '7' -- øádek F1-C 
	    WHERE w."Kód" IN ('P10','PP11')
	    GROUP BY pl.id_nositelplatby) c ON c.id_nositelplatby = p.id

-- WHERE pfzoz."Pøíspìvek Unie" < c."Proplaceno"
