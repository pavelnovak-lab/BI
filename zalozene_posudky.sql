SELECT 	p."Registraèní èíslo projektu" ,
	p.kodwfstav,
	h.*

FROM isum.v_bi_UmzPrjGGII p 
INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
INNER JOIN isum.v_bi_UmvHodnSchvaleni sch ON h.id=sch.id_hodnoceni
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva

WHERE
p."Registraèní èíslo projektu" is not null 
AND 	h.id_kolohodnoceni=171212   /* hodnocení "ostré" µádosti */
AND 	h.id_KrokVecHodn = 171213 /* 1. krok VH */ 
AND 	h.OpravneHodnoceni = 'N'
AND 	v."Èíslo výzvy" = '01_21_376'




