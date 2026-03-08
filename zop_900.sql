SELECT p."Registraèní èíslo projektu" ,
     -- SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
     platba."Závìreèná platba",
     platba.CISLOPLATBYZKR,
     -- platba.SOUCTOVYRADEK,
     platba.kodwfstav 

FROM isum.v_bi_UmzPrjGGII p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby


WHERE p."Registraèní èíslo projektu" is not null --   'CZ.01.3.10/0.0/0.0/18_183/0017168'
AND platba.SOUCTOVYRADEK is null
AND REGEXP_LIKE (platba.cisloplatbyzkr, '.*[8-9][0-9][0-9]/POST')

