SELECT p."Registraèní èíslo projektu",
       p.kodwfstav,
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
       platba."VYUCTPLAN#Vyúètování plán" "Plánované vyúètování",
       platba.VYUCTSKUT,
       (1 - "VYUCTPLAN#Vyúètování plán"/VYUCTSKUT) "% rozdíl",
       pocet."Poèet ®oP",
       propl."Proplaceno ®oP"
       -- p.czv
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN (
      SELECT pl."PORADI#Poøadí finanèního plánu" "Poèet ®oP",
      	     pl.id_NositelPlatby
      FROM isum.v_bi_UmpPlatbaPrj pl
      WHERE pl."Závìreèná platba" = 'A' ) pocet ON pocet.id_nositelplatby = platba.id_nositelplatby

INNER JOIN (                
      SELECT count(pl.id) "Proplaceno ®oP",
      	     pl.id_NositelPlatby
      FROM isum.v_bi_UmpPlatbaPrj pl
      WHERE pl.kodwfstav in ('N1','P10','P11')
      GROUP BY pl.id_nositelplatby) propl ON propl.id_nositelplatby = platba.id_nositelplatby

WHERE p."Registraèní èíslo projektu" is not null 
-- p."Registraèní èíslo projektu" = 'CZ.01.5.125/0.0/0.0/15_020/0015478'
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43') 
AND platba.SOUCTOVYRADEK = 'A'
AND platba.VYUCTSKUT <> 0
AND platba.VYUCTSKUT is not null 

ORDER BY "VYUCTPLAN#Vyúètování plán"/VYUCTSKUT DESC
