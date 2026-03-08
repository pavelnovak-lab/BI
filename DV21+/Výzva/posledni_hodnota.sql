SELECT 


--        t1.poradi "Poøadí T1",
--        t1."kod" "Kod T1",
--        -- t2.poradi "Poøadí T2",
--        -- t2."kod" "Kod T2"
--        LAST_VALUE(t1.kod) over (order by t1.poradi) posledni
FROM vzorova_data_pro_fce t1
-- INNER JOIN vzorova_data_pro_fce t2 ON t1."poradi" = t2."poradi"

WHERE t2.poradi < 5
-- t1."kod" is not null 
-- AND t1."poradi" < t2."poradi"
-- AND t2."kod" is null

-- GROUP BY t1."kod", t2."kod"

ORDER BY t1."poradi"


----------------------------------------
SELECT CASE WHEN kod is not null THEN poradi END poradi_nenuly

FROM vzorova_data_pro_fce

WHERE poradi < 6

----------------------------------------

16
B
16
C
17
A
18
A
19
B
20
A
20
B
20
C
