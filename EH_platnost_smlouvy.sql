SELECT	sml."Platnost od",
        sml."Platnost do",
	hodn.create_uzivatel,
	hodn."Název"

FROM isum.v_bi_UMVHodnotitelPrg h
INNER JOIN isum.v_bi_UMVHodnSmlouva sml ON sml.id_hodnotitelprg = h.id
INNER JOIN isum.v_bi_UmvHodnotitel hodn ON hodn.id = h.id_hodnotitel
INNER JOIN
(SELECT h.id,
	max(sml.id) as maxid
FROM isum.v_bi_UmvHodnotitelPrg h
INNER JOIN isum.v_bi_UMVHodnSmlouva sml ON sml.id_hodnotitelprg = h.id
GROUP BY h.id ) smlaktual ON smlaktual.id = h.id


WHERE smlaktual.maxid = sml.id
AND hodn."Interní hodnotitel" ='N'
AND trunc(sml."Platnost do") >  to_date('2021-01-01','yyyy-mm-dd') 
