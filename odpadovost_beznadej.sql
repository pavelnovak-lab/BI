WITH poslstav AS (
       SELECT DISTINCT
       p."Registrační číslo projektu",
       p.id,
       FORMATDATE('YY-MM',p."Datum registrace žádosti") mregistrace,
       FORMATDATE('YY-MM',hs."Datum od") as mesic,
       LAST_VALUE(wfp."Kód") OVER (PARTITION by p.id, FORMATDATE('YY-MM',hs."Datum od") ORDER BY FORMATDATE('YY-MM',hs."Datum od")) as poslstav
       FROM historie_stavu hs
       INNER JOIN ciselnik_stav_workflow wfp on wfp.id=hs.id_stavdo
       INNER JOIN projekt p ON p.id = hs.nositelid
       WHERE p."Registrační číslo projektu" in ('CZ.01.01.01/01/22_002/0000418','CZ.01.04.01/01/22_006/0001268')
       ),
       
"23-09" AS (
SELECT max(poslstav.mesic) maxmesic,
       poslstav.id
FROM poslstav
WHERE poslstav.mesic <= '23-09'
GROUP BY poslstav.id
),

"23-10" AS (
SELECT max(poslstav.mesic) maxmesic,
       poslstav.id
FROM poslstav
WHERE poslstav.mesic <= '23-10'
GROUP BY poslstav.id
),

"23-11" AS (
SELECT max(poslstav.mesic) maxmesic,
       poslstav.id
FROM poslstav
WHERE poslstav.mesic <= '23-11'
GROUP BY poslstav.id
)

SELECT p."Registrační číslo projektu",
       FORMATDATE('YY-MM', p."Datum registrace žádosti") mesicregistrace ,
       max(CASE WHEN "23-09".maxmesic = poslstav.mesic THEN poslstav.poslstav END) AS "23-09",
       max(CASE WHEN "23-10".maxmesic = poslstav.mesic THEN poslstav.poslstav END) AS "23-10",
       max(CASE WHEN "23-11".maxmesic = poslstav.mesic THEN poslstav.poslstav END) AS "23-11"

FROM projekt p
INNER JOIN poslstav ON poslstav.id = p.id
INNER JOIN "23-09" ON  "23-09".id = p.id
INNER JOIN "23-10" ON  "23-10".id = p.id
INNER JOIN "23-11" ON  "23-11".id = p.id 

GROUP BY mesicregistrace, p."Registrační číslo projektu" 
