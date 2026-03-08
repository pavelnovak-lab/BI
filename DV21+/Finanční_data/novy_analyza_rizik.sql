-- CREATE or REPLACE view "seznam_ZoP_analyze_rizik" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Finanční_data' AS	
SELECT sc.kodnovy as  "Kód SC",
       substring(prg."Kód",4) "Kód Priority",
       op.nazev as "Opatření",
       v."Číslo výzvy" ,
       p."Registrační číslo projektu" ,
       pl."Číslo platby" ,
       w."Kód" "Současný stav ŽoP",
       pl."Datum změny stavu",
       pl."Verze ŽoP", 
       pl."Pořadí finančního plánu" "Pořadí ŽoP",
       pz.p "Počet ŽoP na projektu",
       
       CASE WHEN pl."Pořadí finančního plánu" = 1 THEN 0
       	    ELSE (CASE WHEN pl.id_wfstav = 405643 THEN (pz."Počet ŽoP v PP11" - 1)/pz.p
	    	       ELSE pz."Počet ŽoP v PP11"/pz.p  END)
 	    END AS "% předchozích krácených ŽoP",

       pl."Zálohová platba",
       pl."Závěrečná platba" , 
       sd."VZ" "Počet pro ŽoP relevnantní VZ ",
       sd."Počet dokladů s krácením",
       sd."Počet dokladů",
       sd."Celkem kráceno na dokladech",
       c."Vlastní výdaje (Schválené)",
       c."Výdaje EU (Schválené)" ,

       sum(kr."Krácení celkem") "Celkem kráceno",
       GROUP_CONCAT(DISTINCT typk."Název CZ") "Způsob provedení krácení",
       GROUP_CONCAT(DISTINCT kr."Typ krácení" ) "Typ krácení 0 - věcné, 1 - VR, 2 - jiné",
       p."Evidován v BL",

       CASE WHEN trp.id_prjgg is null THEN 'N'
       	    ELSE 'A' END "Tag rizikový projekt" ,

       pf."Právní forma" "Právní forma příjemce" ,
       s."Počet zaměstnanců",
       vp."Velikost kategorie podniku",
       
       CASE WHEN pa.id_prjgg is null THEN 'N'
       	    ELSE 'A' END "Administruje PA" ,
	    
       pzf."Příspěvek Unie" "EU dotace projekt" ,
       pzf."Celkové zdroje připadající na způsobilé výdaje" "CZV projekt" 
       
FROM projekt p
INNER JOIN vyzva v on v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN v_rav_umshisc sc on sc.id=op.id_hierarchie
INNER JOIN programova_linie prg ON prg.id = sc.id_osa
INNER JOIN platba pl ON pl.id_nositelplatby = p.id

INNER JOIN (SELECT count(id) p,
      	   	   sum(CASE WHEN id_wfstav = 405643 then 1
		   	ELSE 0 END ) "Počet ŽoP v PP11",
      	   	   id_nositelplatby
     	    FROM platba
	    WHERE "Součtový řádek" is null
	    GROUP BY id_nositelplatby) pz ON pz.id_nositelplatby = p.id 

INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id  
LEFT JOIN korekce kr ON kr.id_platba = pl.id  AND kr.id_typkorekce > 0 -- není součtovým řádkem na F1-B
LEFT JOIN ciselnik_typ_korekce typk ON typk.id = kr.id_typkorekce

INNER JOIN (SELECT sum(CASE WHEN cuk."Kód" in ('8','9','10','11','12','13') THEN rf."Schválené vyúčtování ZS/ŘO v této ŽoP" 
       	    	   	    END) "Vlastní výdaje (Schválené)",
 		   max(CASE WHEN cuk."Kód" in ('7') THEN rf."Schválené vyúčtování ZS/ŘO v této ŽoP" 
	    	   	    END) "Výdaje EU (Schválené)",
	           rf.id_platba
		   FROM rozpis_financovani rf 
		   INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel AND cuk."Kód" in ('7','8','9','10','11','12','13')
		   GROUP BY rf.id_platba) c ON c.id_platba = pl.id 

INNER JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null AND s.id_typsubjektuedit IN (413462) -- žadatel, partner s FP
INNER JOIN ciselnik_pravni_forma pf on pf.id = s.id_hosppravforma 
INNER JOIN ciselnik_velikost_podniku vp ON vp.id = s.id_velikostpodniku
LEFT JOIN (SELECT id_prjgg
     	   FROM subjekt
 	   WHERE "Neplatný od" IS NULL
	   AND id_typsubjektuedit = 413437 /* poradenka */ ) AS pa ON pa.id_prjgg = p.id

LEFT JOIN (SELECT COUNT(DISTINCT 
			CASE WHEN id_vz > 0 then id_vz
			     ELSE null END ) "VZ",
      	   	   SUM(CASE WHEN "Snížení prokazovaných způsobilých \nvýdajů" > 0 THEN 1
		   	    ELSE 0 END) AS "Počet dokladů s krácením",
		   COUNT(id) "Počet dokladů",
		   SUM("Snížení prokazovaných způsobilých \nvýdajů") "Celkem kráceno na dokladech",
		   id_platba
      	    FROM soupiska_doklad
	    WHERE "Součtový řádek" is null
	    GROUP BY id_platba) sd  ON pl.id = sd.id_platba 

LEFT JOIN (SELECT t.id_prjgg 		  
		  FROM tag t 
		  INNER JOIN ciselnik_tagy_projektu ct on ct.id = t.id_tag
		  WHERE ct."Název" = 'Rizikový projekt obecně') trp ON trp.id_prjgg = p.id 

WHERE pl."Číslo platby" is not null 
-- AND pl."Číslo platby" IN ( 'CZ.01.01.01/02/22_003/0000133/2025/001/POST','CZ.01.04.01/01/22_006/0000001/2024/001/POST','CZ.01.04.01/01/22_006/0000380/2024/001/POST','CZ.01.04.02/01/22_007/0000017/2024/001/POST','CZ.01.01.01/07/23_011/0001296/2024/002/POST','CZ.01.01.01/01/22_002/0000436/2024/001/POST','CZ.01.01.01/04/23_031/0003515/2025/001/POST')

GROUP BY  sc.kodnovy ,
       substring(prg."Kód",4),
       op.nazev,
       v."Číslo výzvy" ,
       p."Registrační číslo projektu" ,
       pl."Číslo platby" ,
       w."Kód" ,
       pl."Datum změny stavu",
       pl."Verze ŽoP", 
       pl."Pořadí finančního plánu" ,
       pz.p , 
       pl."Zálohová platba",
       pl."Závěrečná platba" ,
       "Počet pro ŽoP relevnantní VZ ",
       sd."Počet dokladů s krácením",
       sd."Počet dokladů",
       sd."Celkem kráceno na dokladech" ,
       c."Vlastní výdaje (Schválené)",
       "% předchozích krácených ŽoP"  ,
       c."Výdaje EU (Schválené)" ,
       p."Evidován v BL",
       "Tag rizikový projekt",
       "Právní forma příjemce" ,
       "Právní forma příjemce" ,
       s."Počet zaměstnanců",
       vp."Velikost kategorie podniku",
       "Administruje PA" ,
       "EU dotace projekt" ,
       "CZV projekt" 

ORDER BY "% předchozích krácených ŽoP" DESC 
