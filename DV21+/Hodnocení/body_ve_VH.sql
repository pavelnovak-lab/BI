CREATE OR REPLACE VIEW "Posudky_2_krok_VH_Priorita_1"
    FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/hodnoceni' AS


SELECT p."Registraèní èíslo projektu" ,
       s."Název subjektu" ,
	w."Kód" "Kód stavu" ,
	pf."Pøíspìvek Unie" "Dotace",
	
	-- body.pocetbodu "Celkem bodù ve VH",
	body."Celkový výsledek - v bodech",
	ch."Název" "Výsledek VH" 

FROM projekt p
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462 -- ¾adatel 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id 
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav
INNER JOIN hodnoceni_status body ON body.id_noshodnoceni = p.id AND body.id_krokvechodn = 488854
INNER JOIN ciselnik_status_hodnoceni ch ON ch.id = body.id_statushodn

WHERE p.id_vyzva = 80158052 -- Potenciál I
AND w."Kód" not IN ('PP20','PP22','PN22')
AND body."Celkový výsledek - v bodech" >= 60
AND  body."Celkový výsledek - v bodech" <= 69

ORDER BY p."Registraèní èíslo projektu" 

 




 


