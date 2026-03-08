SELECT p."Registraèní èíslo projektu" ,
       platba.*


FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby

WHERE p."Registraèní èíslo projektu" = 'CZ.31.2.0/0.0/0.0/23_100/0010609'
