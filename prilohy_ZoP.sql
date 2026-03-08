SELECT p."Registraèní èíslo projektu",
       p.zadatel ,
       prpr.PORADI "Poøadí",
       prpr.CREATECASPRIL "Datum vytvoøení",
       prpr.CREATEUZIVPRIL "1. verzi vlo¾il USERNAME",
       prpr.nazevpril "Název pøílohy",
       prpr.TYPPRILOHY "Typ pøílohy",
       prpr.DRUHPRIL "Druh pøílohy",
       prpr.VERZEPRILOHYREAL "Verze pøílohy",
       prpr."Vrácena k doplnìní" ,
       regexp_substr(prpr.prilohadms, '.+', 34, 1) "Název souboru",
       prpr."Link DMS" "Link na soubor",
       uz.uzivatel "1. verzi vlo¾il",
       	case when uz.typ = 'Externí' then 'Zástupce pøíjemce'
	     when uz.typ = 'Interní' then 'Zástupce OP PIK'
	     else 'Jiný'
	end as "Typ u¾ivatele"

       -- przop.CREATECASPRIL "Datum vytvoøení ®oP",
       -- przop.CREATEUZIVPRIL "Vytvoøil u¾ivatel ®oP",
       -- przop."Název dokumentu" "Název pøílohy ®oP",
       -- przop."Typ dokumentu" "Typ pøílohy ®oP",
       -- przop."Druh dokumentu" "Druh pøílohy ®oP",
       -- przop."Poøadí" "Poradí ®oP"
       
FROM isum.V_BI_UMzPROJEKT p
INNER JOIN isum.V_BI_UMSPRILOHYPRJ prpr  ON p.id=prpr.id_nositelpril
INNER JOIN isum.v_bi_CUzivatel uz ON uz.username = prpr.CREATEUZIVPRIL
-- INNER JOIN isum.v_bi_UmpPlatba platba ON p.id=platba.id_NositelPlatby
-- INNER JOIN isum.v_bi_umsprilohy przop ON przop.id_nositelpril = platba.id

WHERE p."Registraèní èíslo projektu" = 'CZ.01.2.06/0.0/0.0/20_357/0021680'

ORDER BY prpr.poradi



--------------------------------------------
SELECT *

from  isum.v_bi_umsprilohy

WHERE id = 1350635606
