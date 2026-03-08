CREATE or REPLACE view "tak-mpo-nedodrzel-lhutu-na-opravu-fnap" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/' AS 
SELECT op."Název specifického cíle/opatření" as "Opatření" ,
       p."Registrační číslo projektu",
       w."Kód" "Stav WF" ,
       p."Datum změny stavu" "Datum současného stavu" ,
       hs."Datum přepnutí" "Datum posledního PU22a" ,
       pp20."Datum přepnutí" "Datum posledního PP20" ,
       GETDAYSBETWEEN(hs."Datum přepnutí", pp20."Datum přepnutí") AS "Vráceno po (dny)"
FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id    
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN (SELECT max(hs.id),
      	   	   hs.nositelid,
		   hs."Datum přepnutí" 
      	    FROM historie_stavu hs 
	    INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
	    WHERE pwf."Kód" = 'PU22a'
	    GROUP BY hs."Datum přepnutí",
	    	     hs.nositelid) hs ON hs.nositelid = p.id
INNER JOIN (SELECT max(hs."Pořadí") maxporadipp20 ,
      	   	   hs.nositelid,
		   hs."Datum přepnutí" 
      	    FROM historie_stavu hs 
	    INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
	    WHERE pwf."Kód" = 'PP20'
	    GROUP BY hs."Datum přepnutí",
	    	     hs.nositelid) pp20 ON pp20.nositelid = p.id
INNER JOIN (SELECT max(hs."Pořadí") poradi ,
      	   	   hs.nositelid
      	    FROM historie_stavu hs 
	    INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
	    GROUP BY hs."Datum přepnutí",
	    	     hs.nositelid) ted ON ted.nositelid = p.id



INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil


WHERE GETDAYSBETWEEN(hs."Datum přepnutí", pp20."Datum přepnutí") > 8
AND w."Kód" IN ( 'PN20b', 'PN22')
AND ted.poradi = pp20.maxporadipp20 + 1
