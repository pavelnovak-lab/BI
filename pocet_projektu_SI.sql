SELECT	v."Číslo výzvy",
        v."Název výzvy",
       	v.wfstav ,
	nvl(poct.pocet,0)

FROM isum.v_bi_UmzVyzva v 
-- LEFT JOIN isum.v_bi_UmzPrjGGII p ON v.id=p.id_vyzva
LEFT JOIN
(SELECT count(p.id) as pocet,
	v.id
FROM isum.v_bi_UmzVyzva v 
LEFT JOIN isum.v_bi_UmzPrjGGII p ON v.id=p.id_vyzva

WHERE v."Název výzvy" like ('%INFRASTRUKTURY%')
AND v."Název výzvy" like ('% ITI %')
AND p."Registrační číslo projektu" is not null
GROUP BY v.id) poct ON poct.id = v.id


WHERE v."Název výzvy" like ('%INFRASTRUKTURY%')
AND v."Název výzvy" like ('% ITI %')


ORDER BY v."Číslo výzvy" 


