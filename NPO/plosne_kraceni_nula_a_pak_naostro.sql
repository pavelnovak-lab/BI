SELECT platba."Èíslo ¾ádosti o platbu" ,
       platba.kodwfstav ,
       k.ID_TYPKOREKCE,
       k.TYPKRACENI,
       k.VYSE,
       k.CREATE_CAS ,
       cu.uzivatel
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpKorekce k ON k.id_platba = platba.id
-- INNER JOIN isum.V_BI_UMSCisTypKorekce tk ON tk.id = k.id_typkorekce
INNER JOIN isum.v_bi_CUzivatel cu ON cu.username = k.CREATE_UZIVATEL 

-- INNER JOIN isum.v_bi_UmfSoupiskaDokladPRJ s ON s.id_platba = platba.id


WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') -- p.KodPrioritniOsa in ('31.3') 
AND k.SOUCTOVYRADEK  is  null 
-- AND platba."Èíslo ¾ádosti o platbu" = 'CZ.31.3.0/0.0/0.0/22_001/0005660/2024/001/POST'

AND exists (SELECT 1
    	    FROM isum.v_bi_UmpKorekce kor
	    -- INNER JOIN isum.v_bi_UmpPlatbaPrj pl ON pl.id = kor.id_platba
	    WHERE kor.vyse = 0
	    -- AND pl.id = platba.id)
	    AND kor.id_platba = platba.id)

ORDER BY platba."Èíslo ¾ádosti o platbu" , k.vyse


----------------------------------------
SELECT -- count(p.id),
       SUBSTR(p."Registraèní èíslo projektu" , 1, 5) AS "Program podpory"

FROM isum.v_bi_UmzProjekt p

WHERE p.KodPrioritniOsa in ('31.3',  '01.1', '01.2', '01.3', '01.4','01.5')
AND p."Registraèní èíslo projektu" is not null

GROUP BY SUBSTR(p."Registraèní èíslo projektu" , 1, 5)
