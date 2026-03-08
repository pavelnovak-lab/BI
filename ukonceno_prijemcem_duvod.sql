SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       v."Název výzvy" ,
       v."Èíslo výzvy",
       p."Registraèní èíslo projektu" ,
       p.kodwfstav ,
       hs.stavz "Vráceno ze stavu",
       LISTAGG( REPLACE(REPLACE(vr."Dùvod provádìní akce",CHR(10),' $ '),CHR(13),' $ '), '; ') as "Dùvod provádìní akce" 

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
LEFT JOIN isum.v_bi_umzprjggvraceni vr ON vr.id_prjgg = p.id
INNER JOIN (SELECT max(poradi) posledni,
      	   	   NositelId
            FROM isum.v_bi_UmsWFHistorieStavu
	    GROUP BY NositelId) pos ON pos.NositelId = p.id
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND hs.poradi = pos.posledni

WHERE p."Registraèní èíslo projektu" is not null
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_002/0000008'

GROUP BY  SUBSTR(p.kompetencniutvar, 6) ,
       v."Název výzvy" ,
       v."Èíslo výzvy",
       p."Registraèní èíslo projektu" ,
       p.kodwfstav ,
       hs.stavz
