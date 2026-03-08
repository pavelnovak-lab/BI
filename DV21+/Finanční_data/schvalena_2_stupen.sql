-- CREATE OR replace VIEW "Schválena 2. stupeò" FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/finanèní_data' AS
SELECT op.nazev AS "Opatøení",
       pl."Èíslo platby",
       s."Název subjektu" AS "Pøíjemce",
       rf."Schválená záloha ZS/ØO v této ®oP" AS "Schválená záloha",
       rf."Schválené vyúètování ZS/ØO v této ®oP" AS "Schválené vyúètování",
       CASE WHEN pril."Název pøíloh" is not null then 'Ano'
       	    ELSE 'Ne' END AS "Rozhodnutí ministra" ,
       hs."Datum od" AS "Datum schválení" ,
       v."Èíslo výzvy",
       v."Název výzvy"
       
FROM projekt AS p
INNER JOIN vyzva AS v ON v.id = p.id_vyzva
INNER JOIN platba AS pl ON pl.id_nositelplatby = p.id
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null AND s.id_typsubjektuedit = 413462
INNER JOIN vyzva_hierarchie AS vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc AS op ON op.id = vh.id_speccil
INNER JOIN ciselnik_stav_workflow AS pwf ON pwf.id = pl.id_wfstav
INNER JOIN rozpis_financovani AS rf ON rf.id_platba = pl.id
INNER JOIN ciselnik_ukazatel_rozpis_financovani AS cu ON (rf.id_ukazatel = cu.id AND cu."Kód" = '7')
INNER JOIN historie_stavu AS hs ON hs.nositelid = pl.id
INNER JOIN ciselnik_stav_workflow AS plwf ON (plwf.id = hs.id_stavdo AND plwf."Kód" IN ('P6T', 'P9T'))
LEFT JOIN ( SELECT GROUP_CONCAT(priloha."Název dokumentu") "Název pøíloh" ,
		   priloha.id_nositelpril
	    FROM platba_priloha priloha
	    WHERE UPPER(priloha."Název dokumentu") like '%MINISTR%'
	    AND UPPER(priloha."Název dokumentu") not like '%ADMINISTR%'
	    GROUP BY priloha.id_nositelpril) pril ON pril.id_nositelpril = pl.id

WHERE pwf."Kód" IN ('P6T', 'P9T', 'P10', 'P11')
AND (
      (
      (getdayofweek(now()) - 1) IN (5, 6, 0)
      AND trunc(addday(now(), - 3)) <= hs."Datum od"
      AND hs."Datum od" <= trunc(addday(now(), - 1))
      )
  OR ((getdayofweek(now()) - 1) IN (1, 2, 3, 4) AND trunc(addday(now(), - 1)) <= hs."Datum od")
    )


ORDER BY "Datum schválení" DESC;


----------------------------------------
select pl."Èíslo platby" ,
       w."Kód" "Kód stavu" ,
       pp."Název dokumentu"

FROM platba pl
INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id  
INNER JOIN platba_priloha pp ON pp.id_nositelpril = pl.id 


WHERE pl."Èíslo platby" = 'CZ.01.02.01/01/24_005/0000030/2024/001/POST'
----------------------------------------
SELECT DISTINCT p."Registraèní èíslo projektu"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN projekt_ris3 pris ON pris.id_projekt = p.id

WHERE v."Èíslo výzvy" = '10_23_012'
AND p."Registraèní èíslo projektu" is not null

-- AND p."Registraèní èíslo projektu" in ('CZ.01.01.01/03/23_024/0002600', 'CZ.01.01.01/03/23_024/0002606')


----------------------------------------

SELECT -- p."Registraèní èíslo projektu"
       CASE WHEN p.kodkompetence = '0101' THEN '111'
       	    WHEN p.kodkompetence = '0102' THEN '112'
 	    WHEN p.kodkompetence = '0103' THEN '113'
 	    WHEN p.kodkompetence = '0105' THEN '121'
 	    WHEN p.kodkompetence = '0106' THEN '122'
 	    WHEN p.kodkompetence = '0107' THEN '123'
 	    WHEN p.kodkompetence = '0108' THEN '124'
 	    WHEN p.kodkompetence = '0109' THEN '125'
 	    WHEN p.kodkompetence = '0110' THEN '211'
 	    WHEN p.kodkompetence = '0111' THEN '214'
 	    WHEN p.kodkompetence = '0112' THEN '221'
 	    WHEN p.kodkompetence = '0113' THEN '231'
 	    WHEN p.kodkompetence = '0114' THEN '241'
 	    WHEN p.kodkompetence = '0115' THEN '311'
 	    WHEN p.kodkompetence = '0116' THEN '321'
 	    WHEN p.kodkompetence = '0118' THEN '331'
 	    WHEN p.kodkompetence = '0120' THEN '341'
 	    WHEN p.kodkompetence = '0117' THEN '351'
 	    WHEN p.kodkompetence = '0119' THEN '361'
	    WHEN p.kodkompetence = '0121' THEN '411'
	    WHEN p.kodkompetence = '0122' THEN '422'
	    WHEN p.kodkompetence = '0123' THEN '511 nebo 512'
	    ELSE 'chybí'
	    END "Kód programu",
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
       platba."Èíslo ¾ádosti o platbu" ,
       p.zadatel "Pøíjemce dotace" ,
       rf.CASTKASCHVALENA "Èástka (Kè)",
       CASE WHEN pril."Název pøíloh" is not null then 'Ano'
       	    ELSE 'Ne' END AS "Rozhodnutí ministra" ,
       platba."Datum zmìny stavu" ,
       platba.kodwfstav 
       -- (SELECT dentydne FROM isum.v_bi_UmsKalendar WHERE trunc(datum) = trunc(current_date)) "Den tydne"
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356
LEFT JOIN (
     SELECT LISTAGG( priloha.nazevpril, '; ') "Název pøíloh" ,
	    priloha.id_nositelpril
     FROM isum.v_bi_UMSPrilohyPlatba priloha
     WHERE UPPER(priloha.nazevpril) like '%MINISTR%'
     GROUP BY priloha.id_nositelpril) pril ON pril.id_nositelpril = platba.id

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND platba.kodwfstav in ('P6T','P14T','P9T') 


 -- pokud út-pátek, jen pøedchozí den, pokud podnìlí, pak pá-ne, v so-ne negeneruj nic
AND (
      (
      (SELECT dentydne FROM isum.v_bi_UmsKalendar WHERE trunc(datum) = trunc(current_date)) IN (2,3,4,5)  AND platba."Datum zmìny stavu" BETWEEN trunc(current_date-1) AND trunc(current_date)
      )
      OR
      (	
      (SELECT dentydne FROM isum.v_bi_UmsKalendar WHERE trunc(datum) = trunc(current_date)) in ( 1, 6, 7)  AND platba."Datum zmìny stavu" BETWEEN trunc(current_date-3) AND trunc(current_date)
      )
    )

-- AND p."Registraèní èíslo projektu" like '%000494%'



----------------------------------------





