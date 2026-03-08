SELECT	v."Èíslo výzvy", v."Název výzvy",
	sk.limitrozdilarbbodu,
	sk.limitrozdilarbproc,
	sk.limitvyhovelbodu,
	sk.rozptylbodu,
	sum(krit.maxbodu) "Celkem bodù"
	

FROM isum.v_bi_UMVHodnSoubKritVyz sk
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=sk.id_vyzva
INNER JOIN isum.v_bi_UMVHodnKriterium krit ON krit.id_souborkrit = sk.id_souborkrit

WHERE sk.id_krokvechodn = (171214) -- 2. krok vh 
AND sk.platnost = 'A'
-- AND krit.id = 500022849
-- AND krit.id = 500229429
AND (krit.funkcekriteria ='Hodnotící' or krit.funkcekriteria = 'Kombinované')
AND v."Èíslo výzvy" = '01_17_175'
-- AND sk.id = 500022849
-- AND v.id = 583473093
AND krit.nazev <> '(Koøen)'

GROUP BY v."Èíslo výzvy", v."Název výzvy",
	sk.limitrozdilarbbodu,
	sk.limitrozdilarbproc,
	sk.limitvyhovelbodu,
	sk.rozptylbodu

ORDER BY sum(krit.maxbodu)
