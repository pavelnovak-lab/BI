SELECT	p."Registraèní èíslo projektu" ,
	p."Název projektu CZ", 
	vs."Název subjektu" "®adatel",
	vs."IÈ" ,
	p.kodwfstav ,
        va."Adresa uvedená textovì" "Adresy ¾adatele",
        va.KODYTYPUADRESY,
	p.id
       
       
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel 
INNER JOIN isum.v_bi_UMSRSVerzeAdresy va ON va.id_verzesubjektu = vs.id

WHERE p."Registraèní èíslo projektu" is not null 
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND p.kodwfstav not like 'PN%'
AND va."Adresa uvedená textovì" like '%Polepy%'
OR va."Adresa uvedená textovì" like '%Encovany%'

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC 


