SELECT v."Název výzvy" ,
	v."Číslo výzvy"

FROM  isum.v_bi_UmzVyzva v   

WHERE v.kodwfstav not in ('S1','S2')
AND NOT EXISTS
(SELECT 1
FROM isum.v_bi_UMVHodnSoubKritVyz eskv
WHERE eskv.id_krokvechodn = (171214) -- 2. krok vh 
AND eskv.platnost = 'A'
AND eskv.id_vyzva = v.id)
