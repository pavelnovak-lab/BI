with poslstav AS (
     SELECT DISTINCT
       p."Registrační číslo projektu",
       p.id,
       FORMATDATE('YY-MM',p."Datum registrace žádosti") mregistrace,
       FORMATDATE('YY-MM',hs."Datum od") as mesic,
       LAST_VALUE(wfp."Kód") OVER (PARTITION by FORMATDATE('YY-MM',hs."Datum od") ORDER BY FORMATDATE('YY-MM',hs."Datum od")) as poslstav
       FROM projekt p
       INNER JOIN historie_stavu hs ON p.id = hs.nositelid
       INNER JOIN ciselnik_stav_workflow wfp on wfp.id=hs.id_stavdo
       WHERE p."Registrační číslo projektu" = 'CZ.01.01.01/01/22_002/0000418'
       AND FORMATDATE('YY-MM',hs."Datum od") <= '23-10' AND FORMATDATE('YY-MM',hs."Datum od") >= '23-08' 
)

SELECT p."Registrační číslo projektu",
       "23-08".mesic "08 posl nenulový měsíc" ,
       "23-08".stav "08 stav" ,
       "23-09".mesic "09 posl nenulový měsíc" ,
       "23-09".stav "09 stav" ,
       "23-10".mesic "10 posl nenulový měsíc",
       "23-10".stav "10 stav" 
FROM projekt p
INNER JOIN ( SELECT ps.id,
      	     	    pm.mesic,
       	     	    CASE WHEN pm.mesic = ps.mesic THEN ps.poslstav END AS stav 
	     FROM poslstav ps
	     INNER JOIN (
		   SELECT max(ps.mesic) mesic,
			  ps.id
			  -- CASE WHEN max(ps.mesic) = ps.mesic THEN ps.poslstav END stav 
		   FROM poslstav ps
		   WHERE ps.poslstav is not null
		   AND ps.mesic <= '23-08'
		   GROUP BY ps.id) pm ON pm.id = ps.id
             WHERE CASE WHEN pm.mesic = ps.mesic THEN ps.poslstav END is not null 
	     ) "23-08" ON "23-08".id = p.id
INNER JOIN ( SELECT ps.id,
      	     	    pm.mesic,
       	     	    CASE WHEN pm.mesic = ps.mesic THEN ps.poslstav END AS stav 
	     FROM poslstav ps
	     INNER JOIN (
		   SELECT max(ps.mesic) mesic,
			  ps.id
			  -- CASE WHEN max(ps.mesic) = ps.mesic THEN ps.poslstav END stav 
		   FROM poslstav ps
		   WHERE ps.poslstav is not null
		   AND ps.mesic <= '23-09'
		   GROUP BY ps.id) pm ON pm.id = ps.id
             WHERE CASE WHEN pm.mesic = ps.mesic THEN ps.poslstav END is not null 
	     ) "23-09" ON "23-09".id = p.id
INNER JOIN ( SELECT ps.id,
      	     	    pm.mesic ,
       	     	    CASE WHEN pm.mesic = ps.mesic THEN ps.poslstav END AS stav 
	     FROM poslstav ps
	     INNER JOIN (
		   SELECT max(ps.mesic) mesic,
			  ps.id
			  -- CASE WHEN max(ps.mesic) = ps.mesic THEN ps.poslstav END stav 
		   FROM poslstav ps
		   WHERE ps.poslstav is not null
		   AND ps.mesic <= '23-10'
		   GROUP BY ps.id) pm ON pm.id = ps.id
             WHERE CASE WHEN pm.mesic = ps.mesic THEN ps.poslstav END is not null 
	     ) "23-10" ON "23-10".id = p.id




