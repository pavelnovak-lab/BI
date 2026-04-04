CREATE or REPLACE view "mesicni_kurz_eura" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Help_wievs' AS 
WITH posledni_kurz AS
     (SELECT SUBSTR("Datum", 0,7) mesic,
       	     "Měsíční kurz (CZK/EUR)" kurz
	     FROM skutecnost_sc_eu
	     WHERE id_kr = 0
	     AND id_sc = 0
	     AND id_fond = 0
	     ORDER BY mesic DESC
	     LIMIT 1
      )

SELECT p."Registrační číslo projektu" ,
       p."Datum registrace žádosti" ,
       czkeu."Měsíční kurz (CZK/EUR)",
        SUBSTR(czkeu."Datum", 0,7),
        SUBSTR(p."Datum registrace žádosti",0,7)
       
FROM projekt p
LEFT JOIN skutecnost_sc_eu czkeu ON SUBSTR(czkeu."Datum", 0,7)= SUBSTR(p."Datum registrace žádosti",0,7)
     AND SUBSTR(p."Datum registrace žádosti",0,7) =
     (
        SELECT MAX(SUBSTR(kurz."Datum", 0,7))
        FROM skutecnost_sc_eu kurz
        WHERE SUBSTR(p."Datum registrace žádosti") >= SUBSTR(kurz."Datum", 0,7)
	AND id_kr = 0
	AND id_sc = 0
	AND id_fond = 0
     )
where p."Registrační číslo projektu" is not null
and id_kr = 0
and id_sc = 0
and id_fond = 0
ORDER BY p."Datum registrace žádosti" DESC

----------------------------------------

WITH posledni_kurz AS -- beru kurz z minulého měsíce a pak UNIONem lepím k výstupu ze skutečnosti finančních prostředků
 ( SELECT "Měsíční kurz (CZK/EUR)" AS kurz,
          ROW_NUMBER() OVER (ORDER BY "Datum" DESC) AS rn
    FROM skutecnost_sc_eu
    WHERE id_kr = 0 AND id_sc = 0 AND id_fond = 0
 )

-- programová linie OP TAK sice byla v MS21+ až v říjnu 2022, ale VZ mohly být daleko dříve (v jiných OP).
SELECT SUBSTR("Datum", 1,7) mesic,
       CASE WHEN SUBSTR("Datum", 0,7) < '2022-10' THEN 24.687  
	    ELSE "Měsíční kurz (CZK/EUR)" END AS kurz
FROM skutecnost_sc_eu 
WHERE id_kr = 0
AND id_sc = 0
AND id_fond = 0

UNION ALL

SELECT SUBSTR(now(),1,7) mesic,
       (SELECT kurz FROM posledni_kurz WHERE rn = 1) AS kurz;

ORDER BY mesic
