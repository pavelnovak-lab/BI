SELECT	-- SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	p."Registraèní èíslo projektu" ,
	p.zadatel,
	zi."Poøadové èíslo ZoR/IoP",
	-- zi.kodwfstav "Stav ZoR",
	zi.wfstav "Stav ZoR"
	p.kodwfstav "Stav projektu" , 
	-- count(hs.stavdo) "Poèet prùchodù stavem P1"
	ct.hop
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMZZIProjekt zi ON zi.id_zad = p.id
INNER JOIN isum.v_bi_UMZCisTypZI ct ON ct.id = zi.id_CisTypZI 
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = zi.id   

WHERE  -- p."Registraèní èíslo projektu" = 'CZ.31.2.0/0.0/0.0/22_014/0004906'
-- and 
-- ct."Poznámka" = 'ZOR' 
-- AND
hs.stavdo ='P1'
AND v."Èíslo výzvy" IN ('31_22_014','31_22_015')
-- AND p."Registraèní èíslo projektu" IN ('CZ.31.2.0/0.0/0.0/22_014/0005820','CZ.31.2.0/0.0/0.0/22_015/0005879','CZ.31.2.0/0.0/0.0/22_014/0003810')
AND ct.hop = 'ZZoRP'
-- GROUP BY SUBSTR(p.kompetencniutvar, 6) ,
-- 	p."Registraèní èíslo projektu" ,
-- 	p.zadatel,
-- 	zi."Poøadové èíslo ZoR/IoP",
-- 	zi.kodwfstav,
-- 	p.kodwfstav 

ORDER BY v."Èíslo výzvy" 
