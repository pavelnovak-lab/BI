SELECT REPLACE(REPLACE(p."Anotace projektu",CHR(10),' $ '),CHR(13),' $ ') "Anotace projektu",
        REPLACE(REPLACE(p."Co je cílem projektu?",CHR(10),' $ '),CHR(13),' $ ') "Cíl projektu",
	P."Datum registrace ¾ádosti,
	p.wfstavdatum ,
	p.wfstav ,
       p."Název projektu CZ" ,
       p.kodwfstav ,
       p."Registraèní èíslo projektu" ,
       p."IÈ",
       p.zadatel ,
       gg.eu,
       gg.czv
       

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 


WHERE p."Registraèní èíslo projektu" is not null
AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'
