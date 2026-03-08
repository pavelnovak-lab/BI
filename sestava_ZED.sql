SELECT p."Registraèní èíslo projektu" ,
       p.zed,
       p.akcezed,
       ci."Název",
       ci."Kód" ,
       p.kodwfstav ,
       SUBSTR(p.kompetencniutvar, 6) "Komponenta NPO",
       hs.datumod,
       p."Bude se poøizovat EDSSMVS" EDS
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  p.ID_AGRAKCEZED
LEFT JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND  hs.stavdo = 'PP29'


WHERE p."Registraèní èíslo projektu" is not null 
AND p.kodwfstav in ('PP29')
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5','31.1', '31.2', '31.3', '31.4','31.5','31.9','31.14','31.22')
AND p."Bude se poøizovat EDSSMVS" = 'N'
AND p.akcezed is null
AND p."Registraèní èíslo projektu" not in ('CZ.01.1.02/0.0/0.0/20_358/0028028','CZ.01.1.02/0.0/0.0/20_358/0028069')

ORDER BY hs.datumod
