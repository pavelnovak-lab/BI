SELECT p."Registraèní èíslo projektu" ,
       v."Èíslo výzvy",
       v."Název výzvy",
       h."Kód u¾ivatele",
       h."Jméno",
       h."Pøíjmení",
       kh."Datum vyjádøení k nominaci",
       kh."Lhùta vyjádøení",
       kh."Datum odeslání ¾ádosti",
       kh."Náhradník",
       kh."Datum vyjádøení k nominaci",
       kh."Potvrdil nepodjatost"  ,     
       kh."Arbitr",
       kh."Opravný hodnotitel",
       kh."Øádný hodnotitel",
       pzf."Celkové zdroje pøipadající na zpùsobilé výdaje" "CZV",
       CASE WHEN pzf."Celkové zdroje pøipadající na zpùsobilé výdaje" < 10000000 then 9
	    WHEN pzf."Celkové zdroje pøipadající na zpùsobilé výdaje" < 50000000 then 11
	    WHEN pzf."Celkové zdroje pøipadající na zpùsobilé výdaje" < 100000000 then 13
	    ELSE 15
       END as "Poèet hodin"		 


FROM projekt p
INNER JOIN vyzva v ON p.id_vyzva = v.id
INNER JOIN hodnotitel_kompetenece kh ON kh.id_noshodnoceni = p.id
INNER JOIN hodnotitel h ON kh.id_hodnotitel = h.id
INNER JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005


WHERE p."Registraèní èíslo projektu" is not null
AND   h."Interní hodnotitel" ='N'
-- AND   h."Datum vyjádøení" is null
-- AND   h."Datum odeslání ¾ádosti" >  FORMATDATE('yyyy.MM.dd , date)
-- to_date('2021-01-01','yyyy-mm-dd')
