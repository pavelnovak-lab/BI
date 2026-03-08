SELECT SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
       platba."»Ìslo æ·dosti o platbu" ,
       p.zadatel ,
       p.wfstav "Stav projektu",
       platba.wfstav "Stav ÆoP",
       count(hs.stavdo) "PoËet vr·cenÌ do ISKP"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = platba.id

WHERE hs.stavdo like 'P4'

-- having count(hs.stavdo) > 1

GROUP BY  SUBSTR(p.kompetencniutvar, 6 )  ,
       platba."»Ìslo æ·dosti o platbu" ,
       p.zadatel ,
       p.wfstav ,
       platba.wfstav ,
       p.zadatel,
      


ORDER BY SUBSTR(p.kompetencniutvar, 6 ), platba."»Ìslo æ·dosti o platbu" 


