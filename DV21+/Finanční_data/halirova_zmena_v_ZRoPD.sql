
SELECT p."Registrační číslo projektu" ,
       s."Název subjektu" "Žadatel" ,
       w."Kód" ,
       pf."Příspěvek Unie" "Dotace RoPD" ,
       pf."Celkové zdroje připadající na způsobilé výdaje" "CZV" ,
       zropd.czv,
       zropd.zmena "Dotace Změnové RoPD" ,
       CASE WHEN zropd.zmena - pf."Příspěvek Unie" = 0 THEN NULL
       	    ELSE zropd.zmena - pf."Příspěvek Unie" END "Dotace navýšena / ponížena o"

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null -- AND s.id_typsubjektuedit IN (413462, 413467) -- žadatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000011 --Právní akt
INNER JOIN (SELECT "Příspěvek Unie" zmena ,
      	   	   "Celkové zdroje připadající na způsobilé výdaje" czv ,
      	   	   pf.id_projekt 
	    FROM prehled_zdroju_financovani pf 
	    WHERE pf.id_faze = 99991000000000015 --"Právní akt - změna"
	   ) zropd ON zropd.id_projekt = p.id 

WHERE v."Číslo výzvy" = '01_23_023'
AND zropd.czv = pf."Celkové zdroje připadající na způsobilé výdaje" 



----------------------------------------

SELECT DISTINCT
	op."Název specifického cíle/opatření" as "Opatření" ,
	v."Název výzvy" ,
	pa1."Registrační číslo projektu" ,
	s."Název subjektu" "Žadatel" ,
	ropd."Příspěvek Unie" "EU RoPD",
	ropd."Celkové zdroje připadající na způsobilé výdaje" "CZV RoPD",
 	pf."Příspěvek Unie" "EU aktuální PA",
	pf."Celkové zdroje připadající na způsobilé výdaje" "CZV aktuální PA" ,
	ropd."Příspěvek Unie" - pf."Příspěvek Unie" "Rozdíl EU Aktuální PA - RoPD",
	pa1."Celkové způsobilé výdaje bez příjmů" "CZV PA 1 = CZV PA 2",
	pa1."Datum uzavření" "Datum uzavření PA1",
	sml1."Datum uzavření" "Datum uzavření SML1",
	smll."Pořadí" "Pořadí PA1",
        pa1."EU",
        pa2."EU",
 	pa1."Datum uzavření" "Datum uzavření PA2",
 	sml2."Pořadí" "Pořadí PA2",
        pa2."EU" - pa1."EU" "Rozdíl EU v PA nový - stařší",
	ted."Pořadí" "Pořadí posledního PA"
	
FROM prehled_zdroju_financovani_pravni_akt pa1
INNER JOIN prehled_zdroju_financovani_pravni_akt pa2
INNER JOIN projekt p ON p."Registrační číslo projektu" = pa1."Registrační číslo projektu"
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil 
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null AND s.id_typsubjektuedit IN (413462) -- žadatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 
INNER JOIN prehled_zdroju_financovani ropd ON ropd.id_projekt = p.id AND ropd.id_faze = 99991000000000011 -- ropd 
INNER JOIN smlouva sml1 ON sml1.id_nositelsml = p.id AND sml1."Datum uzavření" = pa1."Datum uzavření"
INNER JOIN smlouva sml2 ON sml2.id_nositelsml = p.id AND sml2."Datum uzavření" = pa2."Datum uzavření"
INNER JOIN (SELECT max("Pořadí"),
      	   	   id_nositelsml
      	    FROM smlouva
	    GROUP BY id_nositelsml ) ted ON ted.id_nositelsml = p.id

WHERE pa1."Celkové způsobilé výdaje bez příjmů" = pa2."Celkové způsobilé výdaje bez příjmů"
AND pa1."Registrační číslo projektu" = pa2."Registrační číslo projektu"
AND pa1."EU" - pa2."EU" < 1
AND pa1."EU" - pa2."EU" > -1
AND pa1."EU" <> pa2."EU"
-- AND (pf."Příspěvek Unie" = pa1."EU" OR pf."Příspěvek Unie" = pa1."EU")
AND pa1."Celkové způsobilé výdaje bez příjmů" = pa2."Celkové způsobilé výdaje bez příjmů" 
AND pa1."Datum uzavření" < pa2."Datum uzavření"

ORDER BY op."Název specifického cíle/opatření" , p."Registrační číslo projektu" 
