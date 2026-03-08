CREATE or REPLACE view "®oP První podání" FOLDER= AS 
SELECT pl."Èíslo platby" ,
       min(hs."Datum od") "Poprvné v P4",
       COALESCE(vr.pocet,0)  "Poèet vrácení do ISKP",
       op.nazev as "Opatøení" 
       max(CASE WHEN cuk."Kód" = '7' THEN rf."Schválené vyúètování ZS/ØO v této ®oP"
       ELSE NULL END) AS "Schválená dotace",
       max(CASE WHEN cuk."Kód" = '1' THEN rf."Schválené vyúètování ZS/ØO v této ®oP"
       ELSE NULL END) AS "Schválené ZV"

FROM projekt p 
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN historie_stavu hs ON hs.nositelid = pl.id
INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id 
INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel 
LEFT JOIN (SELECT count(hs."Datum od") pocet,
     	  	  pl.id
	   FROM platba pl
	   INNER JOIN historie_stavu hs ON hs.nositelid = pl.id
	   INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
	   WHERE pwf."Kód" = 'N0'
	   GROUP BY pl.id) vr ON vr.id = pl.id

WHERE pwf."Kód" = 'P4'
AND pl."Èíslo platby" is not null
-- AND pl."Èíslo platby" ='CZ.01.01.01/01/22_002/0000818/2024/001/POST'


GROUP BY pl."Èíslo platby" ,
      	 vr.pocet,
       	 op.nazev 

ORDER BY COALESCE(vr.pocet,0) 
