select pl."Èíslo platby" ,
       pl."Datum proplacení pøíjemci / vypoøádání"
       pl."Financování pau¹ální sazbou",
       -- r."Kód" "Kód polo¾ky Re¾ie" 
       sum(sd."Schválené zpùsobilé FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN ciselnik_stav_workflow wpl ON pl.id_wfstav = wpl.id  
INNER JOIN soupiska_doklad sd ON pl.id = sd.id_platba
INNER JOIN rozpocet_polozka r ON r.id = sd.id_polozka

WHERE pl."Financování pau¹ální sazbou" is null 
-- AND pl."Èíslo platby" = 'CZ.01.01.01/01/22_002/0000818/2024/001/POST'
AND v."Èíslo výzvy" = '01_22_002'
AND wpl."Kód"  IN ('P6T','P7','P7','P8','P8T','P9T','P10','P11','P12','P13','P13T','P14','P14T')
AND r."Kód" REGEXP_LIKE '1.1.1.[12].5.[1-9]'

GROUP BY pl."Èíslo platby" ,
       pl."Financování pau¹ální sazbou",
       pl."Datum proplacení pøíjemci / vypoøádání"
----------------------------------------

SELECT count(pl."Èíslo platby") 
       -- pl."Financování pau¹ální sazbou"       
              


FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id  


where v."Èíslo výzvy" = '01_22_002'
-- AND pl."Èíslo platby" = 'CZ.01.01.01/01/22_002/0000818/2024/001/POST'
AND w."Kód"  IN ('P6T','P7','P7','P8','P8T','P9T','P10','P11','P12','P13','P13T','P14','P14T')
AND pl."Financování pau¹ální sazbou" is null 
