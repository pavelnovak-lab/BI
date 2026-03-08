SELECT	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	v."Èíslo výzvy" ,
	p."Registraèní èíslo projektu" ,
	-- p.zadatel,
	zi."Poøadové èíslo ZoR/IoP" "Èíslo ZoU",
	p."Poèet ZoU" "Poèet ZoU (z Detailu projektu)",
	zi.kodwfstav "Stav ZoU",
	p.kodwfstav "Stav projektu",
	count(hs.stavdo) "Poèet prùchodù stavem P1"
	
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMZZIProjekt zi ON zi.id_zad = p.id
LEFT JOIN isum.v_bi_UMZCisTypZI ct ON ct.id = zi.id_CisTypZI 
LEFT JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = zi.id AND hs.stavdo ='P1' 
-- INNER JOIN isum.v_bi_UMSCisStavWF sw ON sw.id = zi.id_wfstav

WHERE  -- p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_002/0000565'
p."Registraèní èíslo projektu" is not null 
AND p.kodwfstav not like 'PN%'
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
-- and 
AND ct."Poznámka" = 'ZOU' 

-- AND v."Èíslo výzvy" IN ('31_22_014','31_22_015')

GROUP BY SUBSTR(p.kompetencniutvar, 6) ,
        v."Èíslo výzvy",
	p."Registraèní èíslo projektu" ,
	p.zadatel,
	zi."Poøadové èíslo ZoR/IoP",
	zi.kodwfstav,
	p.kodwfstav ,
	p."Poèet ZoU"

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC , zi."Poøadové èíslo ZoR/IoP"
