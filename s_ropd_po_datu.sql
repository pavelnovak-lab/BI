SELECT p."Název projektu CZ",
       p."Registraèní èíslo projektu",
       p.zadatel,
       hs.datumod "Datum PP30",
       p.kodwfstav ,
       v."Název výzvy",
       v."Èíslo výzvy",
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" 


FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND hs.stavdo = 'PP30'
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 

WHERE trunc(hs.datumod) > :datum_PP30_od

-- to_date(:datum_PP30_od,'yyyy-mm-dd')


ORDER BY hs.datum_PP30_od 
