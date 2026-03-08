SELECT p."Registraèní èíslo projektu" ,
       p."Bude se poøizovat EDSSMVS" "EDS/SMVS",
       p.akcezed,
       p.kodwfstav ,
       platba."Datum zmìny stavu",
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       platba."Èíslo ¾ádosti o platbu" 

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  p.ID_AGRAKCEZED
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 

WHERE p."Registraèní èíslo projektu" is not null 
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND platba.kodwfstav = 'P6'
