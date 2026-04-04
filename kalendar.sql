SELECT *

FROM 
(SELECT k.datum
FROM isum.v_bi_UmsKalendar k
WHERE k.dentydne not in (6,7)
AND   k.svatek = 'N'
AND   trunc(k.datum) < to_date('2021-01-01','yyyy-mm-dd')
ORDER BY k.datum DESC )

WHERE rownum < 4
