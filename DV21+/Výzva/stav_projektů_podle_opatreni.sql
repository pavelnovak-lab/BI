-- CREATE OR replace VIEW "Stav_opatreni_pocet_projektu_a_finance" FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/Vyzvy' AS


SELECT SUBSTR(prg."Kód",5) AS "Kód Priority",
       prg."Název" "Priorita",
       SUBSTR(sc.kodnovy,4) AS "Kód SC",
       op.nazev as "Opatøení",
       op.kodnovy "Kód opatøení",
       
       SUM(CASE WHEN w."Kód" REGEXP_LIKE 'P[PU]2[0-6][ab]?|Z[1-4]' THEN 1 END) AS "Projektù pøed RoPD",
       SUM(CASE WHEN w."Kód" REGEXP_LIKE 'P[PU]2[0-6][ab]?|Z[1-4]' THEN pzf."Pøíspìvek Unie"/1000000 END) AS "EU pøed RoPD (mil. Kè)",
       
       SUM(CASE WHEN w."Kód" REGEXP_LIKE 'P[PU][34][0-6]' THEN 1 END) AS "Projektù s RoPD",
       SUM(CASE WHEN w."Kód" REGEXP_LIKE 'P[PU][34][0-6]' THEN pzf."Pøíspìvek Unie"/1000000 END) AS "EU s RoPD (mil. Kè)",
       SUM(CASE WHEN w."Kód" REGEXP_LIKE 'PP4[0-3]' THEN (platby_agg."Celkem proplaceno")/1000000 ELSE 0 END) AS "Dosud proplaceno  (mil. Kè)" ,
       
       SUM(CASE WHEN w."Kód" REGEXP_LIKE 'PP4[0-3]' THEN 1 ELSE 0 END) AS "Ukonèených projektù",
       SUM(CASE WHEN w."Kód" REGEXP_LIKE 'PP4[0-3]' THEN (platby_agg."Nedoèerpáno vùèi FP")/1000000.0 ELSE 0 END) AS "Rozdíl FP - proplaceno v ukonèených projektech (mil. Kè)" ,
       -- SUM(CASE WHEN w."Kód" REGEXP_LIKE 'PP4[0-3]' THEN pzf."Pøíspìvek Unie"/1000000 END) AS "EU v ukonèených projektech (mil. Kè)",
       -- SUM( CASE WHEN w."Kód" REGEXP_LIKE 'PP4[0-3]' THEN platby_agg."Celkem_proplaceno"/1000000 ELSE 0) AS "Z toho ji¾ proplaceno v ukonèených (mil. Kè)",

       -- COUNT(CASE WHEN w."Kód" REGEXP_LIKE 'PP37|PP40]' THEN 1 END) AS "Rozfinancovaných neukonèených projektù",
       -- SUM(platby_agg."Celkem_proplaceno"/1000000) AS "Z toho ji¾ proplaceno v rozfinancovaných (mil. Kè)",
       -- SUM(platby_agg."Celkem_proplaceno"/1000000) - SUM(pzf."Pøíspìvek Unie"/1000000) AS "Rozdíl èástek FP - skuteènì proplaceno (mil. Kè)"
       sum(CASE WHEN w."Kód" REGEXP_LIKE 'P[PU][234][0-6][ab]?|Z[1-4]' THEN 1
       		END) "Poèet projetù v pozitivním stavu" ,
       sum(CASE WHEN w."Kód" REGEXP_LIKE 'PN[234][0-6][ab]?' THEN 1
       		END) "Poèet projetù v negativním stavu" ,       
       count(p.id) "Registrovaných projektù"
       
FROM vyzva AS v
INNER JOIN projekt AS p ON p.id_vyzva = v.id AND p."Registraèní èíslo projektu" IS NOT NULL
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op ON op.id = vh.id_speccil
INNER JOIN v_rav_umshisc sc ON sc.id = op.id_hierarchie
INNER JOIN programova_linie prg ON prg.id = sc.id_osa
LEFT JOIN (
    SELECT pl.id_nositelplatby,
    	   SUM(CASE WHEN (pl."Závìreèná platba"  = 'A'  ) THEN rf."Aktuální zùstatek k proplacení za projekt" ELSE 0 END) AS "Nedoèerpáno vùèi FP",
           SUM(rf."Schválené vyúètování ZS/ØO v této ®oP") AS "Celkem proplaceno"
    FROM platba pl
    INNER JOIN projekt p ON pl.id_nositelplatby = p.id
    INNER JOIN vyzva v ON v.id = p.id_vyzva 
    INNER JOIN ciselnik_stav_workflow wpl ON pl.id_wfstav = wpl.id AND wpl."Kód" REGEXP_LIKE ('P1[0-4]')
    INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id
    INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel AND cuk."Kód" = '7'
    GROUP BY pl.id_nositelplatby
) platby_agg ON platby_agg.id_nositelplatby = p.id

WHERE p."Registraèní èíslo projektu" IS NOT NULL


GROUP BY SUBSTR(prg."Kód",5) , prg."Název", SUBSTR(sc.kodnovy,4) , op.nazev , op.kodnovy



ORDER BY op.kodnovy
