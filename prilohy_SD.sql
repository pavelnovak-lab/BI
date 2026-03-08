SELECT p."Registraèní èíslo projektu",
       p.zadatel ,
       -- prpr.PORADI "Poøadí",
       -- prpr.CREATECASPRIL "Datum vytvoøení",
       -- prpr.CREATEUZIVPRIL "1. verzi vlo¾il USERNAME",
       -- prpr.nazevpril "Název pøílohy",
       -- prpr.TYPPRILOHY "Typ pøílohy",
       -- prpr.DRUHPRIL "Druh pøílohy",
       -- prpr.VERZEPRILOHYREAL "Verze pøílohy",
       -- prpr."Vrácena k doplnìní" ,
       -- regexp_substr(prpr.prilohadms, '.+', 34, 1) "Název souboru",
       -- prpr."Link DMS" "Link na soubor",
       -- uz.uzivatel "1. verzi vlo¾il",
       -- 	case when uz.typ = 'Externí' then 'Zástupce pøíjemce'
       -- 	     when uz.typ = 'Interní' then 'Zástupce OP PIK'
       -- 	     else 'Jiný'
       -- 	end as "Typ u¾ivatele"

       prsd."Poøadí" ,
       prsd.CREATECASPRIL "Datum vytvoøení",
       prsd.CREATEUZIVPRIL "1. verzi vlo¾il USERNAME",
       prsd."Název dokumentu" "Název pøílohy",
       prsd."Typ dokumentu" "Typ pøílohy",
       DECODE(prsd."Druh dokumentu",
       		'®ádosti o platbu do finanèního nástroje', 'Pøíloha soupisky dokladù') "Druh pøílohy",
       prsd.VERZEPRILOHYREAL "Verze pøílohy",
       -- prsd."Vrácena k doplnìní" ,
       regexp_substr(prsd.prilohadms, '.+', 34, 1) "Název souboru",
       prsd."Link DMS" "Link na soubor",
       uz.uzivatel "1. verzi vlo¾il",
       	case when uz.typ = 'Externí' then 'Zástupce pøíjemce'
       	     when uz.typ = 'Interní' then 'Zástupce OP PIK'
       	     else 'Jiný'
       	end as "Typ u¾ivatele"



       
       
FROM isum.V_BI_UMzPROJEKT p
-- INNER JOIN isum.V_BI_UMSPRILOHYPRJ prpr  ON p.id=prpr.id_nositelpril
INNER JOIN isum.v_bi_UmpPlatba platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UMFSoupiskaDoklad sd ON sd.id_platba = platba.id
INNER JOIN isum.v_bi_umsprilohy prsd ON prsd.id_nositelpril = sd.id
INNER JOIN isum.v_bi_CUzivatel uz ON uz.username = prsd.CREATEUZIVPRIL

WHERE p."Registraèní èíslo projektu" = 'CZ.01.2.06/0.0/0.0/20_357/0021680'

ORDER BY prsd."Poøadí"



--------------------------------------------
SELECT *

from  isum.v_bi_umsprilohy

WHERE id = 1350635606
