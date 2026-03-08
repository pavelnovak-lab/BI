SELECT v."Èíslo výzvy" , v."Název výzvy" ,
       count(CASE WHEN ck."Název kraje" = 'Jihomoravský kraj' then 1 END) AS "Jihomoravský kraj",
       count(CASE WHEN ck."Název kraje" = 'Moravskoslezský kraj' then 1 END) AS "Moravskoslezský kraj" ,
       count(CASE WHEN ck."Název kraje" = 'Plzeòský kraj' then 1 END) AS "Plzeòský kraj" ,
       count(CASE WHEN ck."Název kraje" = 'Ústecký kraj' then 1 END) AS "Ústecký kraj" ,
       count(CASE WHEN ck."Název kraje" = 'Zlínský kraj' then 1 END) AS "Zlínský kraj",
       count(CASE WHEN ck."Název kraje" = 'Støedoèeský kraj' then 1 END) AS "Støedoèeský kraj",
       count(CASE WHEN ck."Název kraje" = 'Olomoucký kraj' then 1 END) AS "Olomoucký kraj",
       count(CASE WHEN ck."Název kraje" = 'Pardubický kraj' then 1 END) AS "Pardubický kraj",
       count(CASE WHEN ck."Název kraje" = 'Kraj Vysoèina' then 1 END) AS "Kraj Vysoèina",
       count(CASE WHEN ck."Název kraje" = 'Liberecký kraj' then 1 END) AS "Liberecký kraj",
       count(CASE WHEN ck."Název kraje" = 'Královéhradecký kraj' then 1 END) AS "Královéhradecký kraj",
       count(CASE WHEN ck."Název kraje" = 'Karlovarský kraj' then 1 END) AS "Karlovarský kraj" ,
       count(CASE WHEN ck."Název kraje" = 'Jihoèeský kraj' then 1 END) AS "Jihoèeský kraj"       

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN ciselnik_uzemi_kraje ck on ck.id_projekt = p.id
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 

-- where p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000925'

WHERE p."Registraèní èíslo projektu" is not null
-- AND v."Èíslo výzvy" = '01_22_002'

GROUP BY v."Èíslo výzvy", v."Název výzvy" 

ORDER BY v."Èíslo výzvy" 

----------------------------------------
SELECT v."Èíslo výzvy" , v."Název výzvy" ,
       sum(CASE WHEN ck."Název kraje" = 'Jihomoravský kraj' then pf."Pøíspìvek Unie" END) AS "Jihomoravský kraj",
       sum(CASE WHEN ck."Název kraje" = 'Moravskoslezský kraj' then pf."Pøíspìvek Unie" END) AS "Moravskoslezský kraj" ,
       sum(CASE WHEN ck."Název kraje" = 'Plzeòský kraj' then pf."Pøíspìvek Unie" END) AS "Plzeòský kraj" ,
       sum(CASE WHEN ck."Název kraje" = 'Ústecký kraj' then pf."Pøíspìvek Unie" END) AS "Ústecký kraj" ,
       sum(CASE WHEN ck."Název kraje" = 'Zlínský kraj' then pf."Pøíspìvek Unie" END) AS "Zlínský kraj",
       sum(CASE WHEN ck."Název kraje" = 'Støedoèeský kraj' then pf."Pøíspìvek Unie" END) AS "Støedoèeský kraj",
       sum(CASE WHEN ck."Název kraje" = 'Olomoucký kraj' then pf."Pøíspìvek Unie" END) AS "Olomoucký kraj",
       sum(CASE WHEN ck."Název kraje" = 'Pardubický kraj' then pf."Pøíspìvek Unie" END) AS "Pardubický kraj",
       sum(CASE WHEN ck."Název kraje" = 'Kraj Vysoèina' then pf."Pøíspìvek Unie" END) AS "Kraj Vysoèina",
       sum(CASE WHEN ck."Název kraje" = 'Liberecký kraj' then pf."Pøíspìvek Unie" END) AS "Liberecký kraj",
       sum(CASE WHEN ck."Název kraje" = 'Královéhradecký kraj' then pf."Pøíspìvek Unie" END) AS "Královéhradecký kraj",
       sum(CASE WHEN ck."Název kraje" = 'Karlovarský kraj' then pf."Pøíspìvek Unie" END) AS "Karlovarský kraj",
       sum(CASE WHEN ck."Název kraje" = 'Jihoèeský kraj' then pf."Pøíspìvek Unie" END) AS "Jihoèeský kraj"


FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN ciselnik_uzemi_kraje ck on ck.id_projekt = p.id
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 

-- where p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000925'

WHERE p."Registraèní èíslo projektu" is not null
-- AND v."Èíslo výzvy" = '01_22_002'

GROUP BY v."Èíslo výzvy", v."Název výzvy" 

ORDER BY v."Èíslo výzvy" 


----------------------------------------
SELECT v."Èíslo výzvy" , v."Název výzvy" ,
       sum(CASE WHEN ck."Název kraje" = 'Jihomoravský kraj' then pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END) AS "Jihomoravský kraj",
       sum(CASE WHEN ck."Název kraje" = 'Moravskoslezský kraj' then pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END) AS "Moravskoslezský kraj" ,
       sum(CASE WHEN ck."Název kraje" = 'Plzeòský kraj' then pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END) AS "Plzeòský kraj" ,
       sum(CASE WHEN ck."Název kraje" = 'Ústecký kraj' then pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END) AS "Ústecký kraj" ,
       sum(CASE WHEN ck."Název kraje" = 'Zlínský kraj' then pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END) AS "Zlínský kraj",
       sum(CASE WHEN ck."Název kraje" = 'Støedoèeský kraj' then pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END) AS "Støedoèeský kraj",
       sum(CASE WHEN ck."Název kraje" = 'Olomoucký kraj' then pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END) AS "Olomoucký kraj",
       sum(CASE WHEN ck."Název kraje" = 'Pardubický kraj' then pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END) AS "Pardubický kraj",
       sum(CASE WHEN ck."Název kraje" = 'Kraj Vysoèina' then pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END) AS "Kraj Vysoèina",
       sum(CASE WHEN ck."Název kraje" = 'Liberecký kraj' then pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END) AS "Liberecký kraj",
       sum(CASE WHEN ck."Název kraje" = 'Královéhradecký kraj' then pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END) AS "Královéhradecký kraj",
       sum(CASE WHEN ck."Název kraje" = 'Karlovarský kraj' then pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END) AS "Karlovarský kraj",
       sum(CASE WHEN ck."Název kraje" = 'Jihoèeský kraj' then pf."Celkové zdroje pøipadající na zpùsobilé výdaje" END) AS "Jihoèeský kraj"


FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN ciselnik_uzemi_kraje ck on ck.id_projekt = p.id
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 

-- where p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000925'

WHERE p."Registraèní èíslo projektu" is not null
-- AND v."Èíslo výzvy" = '01_22_002'

GROUP BY v."Èíslo výzvy", v."Název výzvy" 

ORDER BY v."Èíslo výzvy" 



----------------------------------------
SELECT v."Èíslo výzvy" , v."Název výzvy" , p."Registraèní èíslo projektu" ,
       ck."Název kraje", pf.* 

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN ciselnik_uzemi_kraje ck on ck.id_projekt = p.id
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 


WHERE  ci."Název kraje" = 'Jihoèeský kraj'
AND p."Registraèní èíslo projektu" is not null

pf."Celkové zdroje pøipadající na zpùsobilé výdaje" 
