SELECT 	p."Registraèní èíslo projektu" ,
	-- pl."Datum pøedlo¾ení",
	-- pl."PORADI#Poøadí finanèního plánu",
	-- pl.wfstav as "Stav ®opl",
 	-- pl.kodwfstav ,
	p.kodwfstav ,
	p.wfstav 

FROM isum.v_bi_umzprojekt p
-- LEFT JOIN isum.v_bi_umpplatba pl on pl.id_nositelplatby = p.id
-- inner join isum.v_bi_umfpfcelkem pf on pf.id_projekt = p.id

WHERE pl.souctovyradek is null
AND p."Registraèní èíslo projektu" is not null
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND not exist
(SELECT 0
FROM isum.v_bi_umpplatba platba
where platba.id_nositelplatby = p.id)

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC , pl."PORADI#Poøadí finanèního plánu" ASC  


