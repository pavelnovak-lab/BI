-- CREATE or REPLACE view "tak-mpo-novak Rozpad ŽoP na výzvách" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Vyzvy' AS 
SELECT v."Číslo výzvy",
       v."Název výzvy",
       op.kodnovy ,
       op.nazev as "Opatření",
       v."Finanční alokace výzvy (CZV)",
       vw."Název" "Stav výzvy" ,

       (COALESCE(predpa."Počet ŽoP projektů před RoPD",0) + COALESCE(popaiskp."Počet nepodanýc ŽoP projektů s RoPD",0) + COALESCE(popapodane."Počet neproplacených podaných ŽoP",0) + COALESCE(popapropl."Počet proplacených ŽoP projektů po RoPD",0) ) AS "ŽoP celkem" ,
       
       (COALESCE(predpa."Počet ŽoP projektů před RoPD",0) + COALESCE(popaiskp."Počet nepodanýc ŽoP projektů s RoPD",0) + COALESCE(popapodane."Počet neproplacených podaných ŽoP",0)) AS "Nepropacených ŽoP celkem" ,
       COALESCE(popapropl."Počet proplacených ŽoP projektů po RoPD",0) "Proplacených ŽoP celkem",
       -- "Proplacených ŽoP celkem"/"ŽoP celkem" * 100 AS "Proplaceno ŽoP (%)" -- nemůžu pouužíta aliasy...,
       COALESCE(popapropl."Počet proplacených ŽoP projektů po RoPD",0) / (COALESCE(predpa."Počet ŽoP projektů před RoPD",0) + COALESCE(popaiskp."Počet nepodanýc ŽoP projektů s RoPD",0) + COALESCE(popapodane."Počet neproplacených podaných ŽoP",0) + COALESCE(popapropl."Počet proplacených ŽoP projektů po RoPD",0) ) * 100 AS  "Proplaceno ŽoP (%)" ,

       (COALESCE(predpa."EU dotace před RoPD",0) + COALESCE(popaiskp."Nepropacene EU dotace v nepodaných ŽoP projektů s RoPD",0) + COALESCE(popapodane."Počet neproplacených podaných ŽoP",0) + COALESCE(popapodane."Nepropacene EU dotace v podaných ŽoP",0) + COALESCE(popapropl."Proplacené EU dotace po RoPD",0) ) AS "Celková požadovaná EU dotace",
       (COALESCE(predpa."EU dotace před RoPD",0) + COALESCE(popaiskp."Nepropacene EU dotace v nepodaných ŽoP projektů s RoPD",0) + COALESCE(popapodane."Počet neproplacených podaných ŽoP",0) + COALESCE(popapodane."Nepropacene EU dotace v podaných ŽoP",0) ) "Celková nepropacená EU dotace" ,
       COALESCE(popapropl."Proplacené EU dotace po RoPD",0) AS  "Proplacené EU dotace po RoPD",
       --- proplaceno EU / celkem EU * 100
       COALESCE(popapropl."Proplacené EU dotace po RoPD",0) / (COALESCE(predpa."EU dotace před RoPD",0) + COALESCE(popaiskp."Nepropacene EU dotace v nepodaných ŽoP projektů s RoPD",0) + COALESCE(popapodane."Počet neproplacených podaných ŽoP",0) + COALESCE(popapodane."Nepropacene EU dotace v podaných ŽoP",0) + COALESCE(popapropl."Proplacené EU dotace po RoPD",0) ) AS "Proplacená dotace (%)" ,



       COALESCE(predpa."Počet ŽoP projektů před RoPD",0) "Počet ŽoP projektů před RoPD",
       COALESCE(predpa."EU dotace před RoPD",0) "EU dotace před RoPD",
       COALESCE(popaiskp."Počet nepodanýc ŽoP projektů s RoPD",0) "Počet nepodanýc ŽoP projektů s RoPD",
       COALESCE(popaiskp."Nepropacene EU dotace v nepodaných ŽoP projektů s RoPD",0) "Nepropacene EU dotace v nepodaných ŽoP projektů s RoPD",
       COALESCE(popapodane."Počet neproplacených podaných ŽoP",0) "Počet neproplacených podaných ŽoP" ,
       COALESCE(popapodane."Nepropacene EU dotace v podaných ŽoP",0) "Nepropacene EU dotace v podaných ŽoP" 

FROM vyzva AS v
INNER JOIN ciselnik_stav_workflow AS vw ON vw.id = v.id_wfstav
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
LEFT JOIN (SELECT p.id_vyzva,
     	  	  sum( CASE WHEN (p.id_typplatby = 282638 /*ex ante projekt */ AND pl."Zálohová platba" = 'A') THEN pl."Částka na krytí výdajů - skutečnost"  -- bude třeba ještě promyslet - nyní konverzí řešíme osdtranění vlatního podílu
ELSE pl."Vyúčtování - skutečnost" END ) AS "EU dotace před RoPD" ,
     		  count(pl.id) AS "Počet ŽoP projektů před RoPD" 

FROM projekt p
INNER JOIN ciselnik_stav_workflow AS pw ON pw.id = p.id_wfstav
INNER JOIN platba pl ON pl.id_nositelplatby = p.id 

WHERE pw."Kód" in ('Z1','Z2','Z3','Z4','PP20', 'PP22', 'PU22a','PP23a','PP23b','PU24','PP24','PP25a','PP25b','PP26','PU26')
AND p."Registrační číslo projektu" is not null 
GROUP BY p.id_vyzva  ) predpa ON predpa.id_vyzva = v.id

LEFT JOIN (SELECT p.id_vyzva,
     	  	  sum( CASE WHEN (p.id_typplatby = 282638 /*ex ante projekt */ AND pl."Zálohová platba" = 'A') THEN pl."Částka na krytí výdajů - skutečnost"  -- bude třeba ještě promyslet - nyní konverzí řešíme osdtranění vlatního podílu
ELSE pl."Vyúčtování - skutečnost" END ) AS "Proplacené EU dotace po RoPD" ,
     		  count(pl.id)  AS "Počet proplacených ŽoP projektů po RoPD" 

	    FROM projekt p
	    INNER JOIN ciselnik_stav_workflow AS pw ON pw.id = p.id_wfstav
 	    INNER JOIN platba pl ON pl.id_nositelplatby = p.id 
	    INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id  
	    WHERE pw."Kód" regexp_like '^PP[34][0-9]'
	    AND w."Kód" IN ('P10','P11','P12','P13','P13T','P14','P14T')
	    GROUP BY p.id_vyzva  ) popapropl ON popapropl.id_vyzva = v.id

LEFT JOIN (SELECT p.id_vyzva,
     	  	  sum( CASE WHEN (p.id_typplatby = 282638 /*ex ante projekt */
		       	    	   AND pl."Zálohová platba" = 'A')
			    THEN pl."Částka na krytí výdajů - skutečnost"  -- bude třeba ještě promyslet - nyní konverzí řešíme osdtranění vlatního podílu
		  	    ELSE pl."Vyúčtování - skutečnost" END ) AS "Nepropacene EU dotace v podaných ŽoP" ,
     		  count(pl.id) AS "Počet neproplacených podaných ŽoP" 

	    FROM projekt p
	    INNER JOIN ciselnik_stav_workflow AS pw ON pw.id = p.id_wfstav
 	    INNER JOIN platba pl ON pl.id_nositelplatby = p.id 
	    INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id  
	    WHERE pw."Kód" regexp_like '^PP[34][0-9]'
	    AND w."Kód" IN ('P4','P5','P5T','P6','P6T')
	    GROUP BY p.id_vyzva  ) popapodane ON popapodane.id_vyzva = v.id

LEFT JOIN (SELECT p.id_vyzva,
     	  	  sum( CASE WHEN (p.id_typplatby = 282638 /*ex ante projekt */ AND pl."Zálohová platba" = 'A') THEN pl."Částka na krytí výdajů - skutečnost"  -- bude třeba ještě promyslet - nyní konverzí řešíme osdtranění vlatního podílu
ELSE pl."Vyúčtování - skutečnost" END ) AS "Nepropacene EU dotace v nepodaných ŽoP projektů s RoPD" ,
     		  count(pl.id) AS "Počet nepodanýc ŽoP projektů s RoPD" 

	    FROM projekt p
	    INNER JOIN ciselnik_stav_workflow AS pw ON pw.id = p.id_wfstav
 	    INNER JOIN platba pl ON pl.id_nositelplatby = p.id 
	    INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id  
	    WHERE pw."Kód" regexp_like '^PP[34][0-9]'
	    AND w."Kód" regexp_like '^P[0-3]'
	    GROUP BY p.id_vyzva  ) popaiskp ON popaiskp.id_vyzva = v.id

WHERE v.id_integnastr = 0 -- vyhazuje ven výzvy na ISg CLLD a ITI
AND vw."Název" <> 'Zrušená'
-- AND v."Číslo výzvy" IN ('01_23_013', '01_23_022')
AND (COALESCE(predpa."Počet ŽoP projektů před RoPD",0) + COALESCE(popaiskp."Počet nepodanýc ŽoP projektů s RoPD",0) + COALESCE(popapodane."Počet neproplacených podaných ŽoP",0) + COALESCE(popapropl."Počet proplacených ŽoP projektů po RoPD",0) ) > 0


ORDER BY op.kodnovy , v."Číslo výzvy" 

