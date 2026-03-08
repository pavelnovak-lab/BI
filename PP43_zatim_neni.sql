SELECT	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
	p."Registraèní èíslo projektu",
	p.kodwfstav,
	p.wfstavdatum
	-- zou.wfstav "Stav ZZoU"

FROM isum.v_bi_UmzProjekt p 
-- INNER JOIN isum.v_bi_UMZZIProjekt zou ON zou.id_zad = p.id
-- INNER JOIN isum.v_bi_UMZCisTypZI cizi ON cizi.id = zou.id_cistypzi 

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND p.kodwfstav = 'PP42'
AND not exists
(SELECT 0
 FROM isum.v_bi_UMZZIProjekt
 WHERE id_cistypzi = 361331 -- AND cizi."Kód" = 31 -- ZZoU
 AND id_zad = p.id
)



--------------------------------------------
("Kód stavu"='PP42')
AND 
( exists(UMZZIProjekt, ID_CISTYPZI=&ID AND id_cistypzi = 361331 )			    
)






-- AND not exists 
-- (SELECT 0
--  FROM isum.v_bi_UMZZIProjekt zou
--  WHERE zou.kodwfstav = 'P5' -- schválena ØO z hlediska obsahové kvality
--  AND zou.id_cistypzi = 361331-- AND cizi."Kód" = 31 -- ZZoU
--  AND zou.id_zad = p.id)

