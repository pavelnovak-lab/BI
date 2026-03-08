-- CREATE or REPLACE view "02_KnM_Zadosti_o_zmenu" FOLDER= AS 

SELECT	p."Registraèní èíslo projektu" ,
	zoz."Poøadí" ,
	COALESCE(zo.pocet,0) "Poèet ®oZ"

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
LEFT JOIN zmena zoz ON zoz.id_zad = p.id
LEFT JOIN (SELECT max("Poøadí") pocet,
		  id_zad		
           FROM zmena
	   GROUP BY id_zad) zo ON zo.id_zad = p.id

WHERE p."Registraèní èíslo projektu" is not null 
AND w."Kód" IN ('PP30','PP31','PU30')
ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC , zoz."Poøadí"

-- WHERE p."Registraèní èíslo projektu" = 'CZ.01.04.01/01/22_006/0000002'
