select t.poradi,
       t.kod
       
from (SELECT 1 AS poradi,
       'A' AS kod
UNION ALL
SELECT 2 AS poradi,
       'B' AS kod
UNION ALL
SELECT 3 AS poradi,
       'C' AS kod
UNION ALL
SELECT 4 AS poradi,
       NULL AS kod
UNION ALL
SELECT 5 AS poradi,
       'A' AS kod
UNION ALL
SELECT 6 AS poradi,
       'A' AS kod
UNION ALL
SELECT 7 AS poradi,
       NULL AS kod
UNION ALL
SELECT 8 AS poradi,
       NULL AS kod
UNION ALL
SELECT 9 AS poradi,
       'A' AS kod
UNION ALL
SELECT 10 AS poradi,
       NULL AS kod
UNION ALL
SELECT 11 AS poradi,
       'B' AS kod
UNION ALL
SELECT 12 AS poradi,
       'C' AS kod
UNION ALL
SELECT 13 AS poradi,
       'C' AS kod
UNION ALL
SELECT 14 AS poradi,
       NULL AS kod
UNION ALL
SELECT 15 AS poradi,
       NULL AS kod
UNION ALL
SELECT 16 AS poradi,
       NULL AS kod
UNION ALL
SELECT 17 AS poradi,
       'A' AS kod
UNION ALL
SELECT 18 AS poradi,
       'A' AS kod
UNION ALL
SELECT 19 AS poradi,
       'B' AS kod
UNION ALL
SELECT 20 AS poradi,
       NULL AS kod
ORDER BY poradi ) tabulka t
