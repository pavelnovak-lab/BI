SELECT sz.*,
       w."KÛd stavu",
       w.wfstav 
       
FROM isum.v_bi_UmpSouhrnnaPlatba sz 
LEFT JOIN isum.v_bi_UMSCisStavWF w ON w.id = sz.id_wfstav 


-- where platba."»Ìslo æ·dosti o platbu" in ('CZ.01.2.111/0.0/0.0/15_016/0000743/2016/001/POST', 'CZ.31.3.0/0.0/0.0/22_001/0000504/2023/001/POST')


WHERE sz."»Ìslo souhrnnÈ æ·dosti" is not null

-- OR sz."»Ìslo souhrnnÈ æ·dosti"

----------------------------------------


SELECT -- datum refundace *
FROM isum.v_bi_UMPKlasifikace_SP
WHERE id_sz is not null 
and id_projekt = 1062146929

----------------------------------------
SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       platba."»Ìslo æ·dosti o platbu" ,
       rf.CASTKASCHVALENA  "»·stka schv·len· EU" ,
       -- kl."»Ìslo souhrnnÈ æ·dosti"
       kl.*
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- ¯·dky cis.
-- pozor na left join --
INNER JOIN isum.v_bi_UMPKlasifikace kl ON kl.id_platba = platba.id 

WHERE kl.druhdp=2 --refundace
AND platba."»Ìslo æ·dosti o platbu" = 'CZ.01.2.06/0.0/0.0/19_249/0023750/2023/002/POST'
AND p.KodPrioritniOsa In ('01.1', '01.2', '01.3', '01.4','01.5')
AND platba.kodwfstav IN ('P4','P5','P5T','P6','P6T','P7','P8T','P8','P9','P9T','P10','P11','P12','P13','P13T','P14','P14T') 
