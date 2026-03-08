SELECT p."Registraèní èíslo projektu" ,
       platba."Èíslo ¾ádosti o platbu",
       platba.kodwfstav,
       platba."Datum zmìny stavu" ,
       platba."Datum proplacení pøíjemci"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby

WHERE p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.4','31.5','31.9','31.14','31.22')
AND platba.kodwfstav in ('P6T','P10','P11') 
