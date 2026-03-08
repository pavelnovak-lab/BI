SELECT p."Registraèní èíslo projektu",
       p.zadatel ,

       prpr.CREATECASPRIL "Datum vytvoøení PRJ",
       prpr.CREATEUZIVPRIL "Vytvoøil u¾ivatel PRJ",
       prpr.nazevpril "Název pøílohy PRJ",
       prpr.TYPPRILOHY "Typ pøílohy PRJ",
       prpr.DRUHPRIL "Druh pøílohy PRJ",
       prpr.PORADI "Poøadí PRJ",

       przop.CREATECASPRIL "Datum vytvoøení ®oP",
       przop.CREATEUZIVPRIL "Vytvoøil u¾ivatel ®oP",
       przop."Název dokumentu" "Název pøílohy ®oP",
       przop."Typ dokumentu" "Typ pøílohy ®oP",
       przop."Druh dokumentu" "Druh pøílohy ®oP",
       przop."Poøadí" "Poradí ®oP"
       
FROM isum.V_BI_UMzPROJEKT p
INNER JOIN isum.V_BI_UMSPRILOHYPRJ prpr  ON p.id=prpr.id_nositelpril
INNER JOIN isum.v_bi_UmpPlatba platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_umsprilohy przop ON przop.id_nositelpril = platba.id

WHERE p."Registraèní èíslo projektu" = 'CZ.01.2.06/0.0/0.0/20_357/0021680'

ORDER BY prpr.poradi, przop."Poøadí"



--------------------------------------------
SELECT *

from  isum.v_bi_umsprilohy

WHERE id = 1350635606

---------------------------------
SELECT
	ROWNUM as poradicelk,
	pril.*,
	uz.uzivatel AS "1.verzi vlo¾il",
	CASE WHEN uz.typ = 'Externí' THEN 'Zástupce pøíjemce'
		when uz.typ = 'Interní' THEN 'Zástupce OP PIK'
		ELSE 'Jiný' END AS "Typ u¾ivatele"
FROM (SELECT pril."Èíslo projektu" AS "Registraèní èíslo projektu",
					p.zadatel,
					pril."Druh dokumentu" AS "Druh pøílohy",
					pril."Poøadí",
					pril."Název dokumentu" AS "Název pøílohy",
					pril.createcaspril AS "Datum vytvoøení",
					pril.createuzivpril AS "1.verzi vlo¾il USERNAME",
					pril.verzeprilohyreal AS "Verze pøílohy",
					regexp_substr(pril.prilohadms, '.+', 34, 1) AS "Název souboru",
					pril."Link DMS" AS "Link na soubor",
					pril."Link DMS LW",
					pril.createuzivpril
				FROM ISUM.v_bi_umsprilohy pril
					INNER JOIN isum.V_BI_UMZPROJEKT p ON p."Registraèní èíslo projektu"=pril."Èíslo projektu"
				WHERE pril."Èíslo projektu" = :p_prj
					AND NVL("Nezobrazovat dokument pøíjemci",'N') IN (:zad)
				UNION ALL
				SELECT p."Registraèní èíslo projektu",
					p.zadatel,
					pril.druhpril AS "Druh pøílohy",
					pril.poradi AS "Poøadí",
					pril.nazevpril AS "Název pøílohy",
					pril.createcaspril AS "Datum vytvoøení",
					pril.createuzivpril AS "1.verzi vlo¾il USERNAME",
					pril.verzeprilohyreal AS "Verze pøílohy",
					regexp_substr(pril.prilohadms, '.+', 34, 1) AS "Název souboru",
					pril."Link DMS" AS "Link na soubor",
					pril."Link DMS LW",
					pril.createuzivpril
				 FROM ISUM.v_bi_umsprilohydep pril
					INNER JOIN ISUM.V_BI_UMzPROJEKT p ON p.id=pril.id_projekt
					WHERE "Registraèní èíslo projektu" = :p_prj
					AND 'N' IN (:zad)
					order by "Datum vytvoøení"
				) pril
 	INNER JOIN ISUM.v_bi_CUzivatel uz ON uz.username = pril.createuzivpril
			--'CZ.01.2.06/0.0/0.0/20_357/0021680'
