SELECT
	ROWNUM as poradicelk,
	pril.*,
	uz.uzivatel AS "1.verzi vlo¾il",
	CASE WHEN uz.USERNAME = 'ISUM_USER' THEN 'MS2014+'
		WHEN uz.typ = 'Externí' THEN 'Zástupce pøíjemce'
		WHEN uz.typ = 'Interní' THEN 'Zástupce OP PIK'
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
					pril.createuzivpril,
					NULL AS "Pøedmìt",
					NULL AS datumodeslani,
					NULL AS odesilatel,
					NULL AS adresatitext
				FROM ISUM.v_bi_umsprilohy pril
					INNER JOIN isum.V_BI_UMZPROJEKT p ON p."Registraèní èíslo projektu"=pril."Èíslo projektu"
				WHERE pril."Èíslo projektu" = :p_prj
					AND NVL("Nezobrazovat dokument pøíjemci",'N') IN (:zad)
				UNION ALL
					SELECT p."Registraèní èíslo projektu",
					p.zadatel,
					'Pøíloha z depe¹e' AS "Druh pøílohy",
					pril.poradi AS "Poøadí",
					pril.nazevpril AS "Název pøílohy",
					pril.createcaspril AS "Datum vytvoøení",
					pril.createuzivpril AS "1.verzi vlo¾il USERNAME",
					pril.verzeprilohyreal AS "Verze pøílohy",
					regexp_substr(pril.prilohadms, '.+', 34, 1) AS "Název souboru",
					pril."Link DMS" AS "Link na soubor",
					pril."Link DMS LW",
					pril.createuzivpril,
					z."Pøedmìt",
					z.datumodeslani,
					aa.adresa AS odesilatel,
					REPLACE(z.adresatitext,',',';') AS adresatitext
				 FROM ISUM.v_bi_umsprilohydep pril
				 	INNER JOIN ISUM.V_BI_UMSZPRAVAPRJ Z ON Z.id=pril.id_nositelpril
				 	INNER JOIN isum.v_bi_umsadresaabs aa ON aa.id=z.id_adrodesilatel
					INNER JOIN ISUM.V_BI_UMzPROJEKT p ON p.id=pril.id_projekt
					WHERE "Registraèní èíslo projektu" = :p_prj
					AND 'N' IN (:zad)
					order by "Datum vytvoøení"
				) pril
 	INNER JOIN ISUM.v_bi_CUzivatel uz ON uz.username = pril.createuzivpril
			--'CZ.01.2.06/0.0/0.0/20_357/0021680'
