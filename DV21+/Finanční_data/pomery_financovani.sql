SELECT p."Registrační číslo projektu" ,
       v."Název výzvy",
       w."Kód" "Kód stavu" ,
       czf."Název" "Zdroj financování vlastního podílu",
       pfc."Příspěvek Unie" "EU" 
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id   
INNER JOIN pomery_financovani pf ON pf.id_nositelpompf = p.id
INNER JOIN ciselnik_zdroj_financovani czf ON czf.id = pf.id_zdrojfin
INNER JOIN prehled_zdroju_financovani pfc ON pfc.id_projekt = p.id AND pfc.id_faze = 99991000000000005 -- aktuální stav 


WHERE p."Registrační číslo projektu" IN ('CZ.01.04.03/01/23_033/0005962','CZ.01.04.03/01/23_033/0005961','CZ.01.04.03/01/23_033/0005960','CZ.01.04.03/01/23_033/0005959','CZ.01.04.03/01/23_032/0005876')
AND pf."Vlastní prostředky financování" = 'A'
AND w."Kód" not like 'PN%'
