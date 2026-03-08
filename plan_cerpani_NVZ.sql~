SELECT  substr(p."Registraèní èíslo projektu",7,2) "Kod PO",
	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	platba."Datum pøedlo¾ení" as "Datum pøedlo¾ení",
	v."Název výzvy" as "Název výzvy",
	p."Registraèní èíslo projektu" as "Registraèní èíslo projektu",
	p."ZADATEL" as "ZADATEL",
	platba."PORADI#Poøadí finanèního plánu" as "PORADI#Poøadí finanèního plánu",
	platba."WFSTAV" as "Stav ®opl",
	p."KODWFSTAV" as "KODWFSTAV",
	p."WFSTAV" as "Stav projektu",
	platba."Èíslo ¾ádosti o platbu",
	platba."VYUCTPLAN#Vyúètování plán" as CZV,
	((platba."VYUCTPLAN#Vyúètování plán"/100)*fp."PROC_EU") as "Dotace",
	platba."Závìreèná platba" as "Závìreèná platba",
	
	-- case when rf.id_ukazatel = 361347 then rf.castkaschvalena
	-- end as "CZV Schválené",
	-- case when rf.id_ukazatel = 361356 then rf.castkaschvalena
	-- end as "Dotace schválená",
	-- case when rf.id_ukazatel in ('361360','361362','361364','361366','361368') then rf.castkaschvalena
	-- end as "NVZ",

	-- czv_schvalene.castkaschvalena "CZV Schválené",
	-- eu_schvalene.castkaschvalena "Dotace schválená"	,
	-- nvz_schvalene.castkaschvalena "NVZ",

	nvl(platba.kurz, 0) "Kurz",
	-- nvl(platba.kurz * czv_schvalene.castkaschvalena, 0) AS "CZV scvhálené EUR",
 	-- nvl(platba.kurz * eu_schvalene.castkaschvalena, 0) AS "Dotace scvhálené EUR",

	-- nvl(platba.kurz * "NVZ",0) AS "NVZ v EUR",

	platba.id,
	
	platba."Datum navrácení",
	platba.DATUMVYTVORENI "Datum vytvoøení"
	-- prvni."datum prvního stavu P4"

FROM isum.v_bi_UmzProjekt p 
-- INNER JOIN isum.v_bi_UmsHiPLinie pl ON p."ID_PRIORITNIOSA"=pl.id  
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmfPFCelkem fp ON fp.id_projekt = p.ID
-- LEFT JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id -- AND rf.id_ukazatel in ( 361346, 361347, 361356, 361370 ) -- øádky cis.

-- LEFT JOIN
-- (SELECT rf.CASTKASCHVALENA,
-- 	rf.id_platba
--  FROM isum.v_bi_UmpRozpisFin rf
--  WHERE  rf.id_ukazatel = 361347 -- øádek 2, CZV	
-- ) czv_schvalene ON czv_schvalene.id_platba = platba.id
-- LEFT JOIN
-- (SELECT rf.CASTKASCHVALENA,
-- 	rf.id_platba
--  FROM isum.v_bi_UmpRozpisFin rf
--  WHERE rf.id_ukazatel = 361356 -- øádek 10a, dotace EU
-- ) eu_schvalene ON eu_schvalene.id_platba = platba.id

-- LEFT JOIN
-- (SELECT rf.CASTKASCHVALENA,
-- 	rf.id_platba
--  FROM isum.v_bi_UmpRozpisFin rf
--  WHERE rf.id_ukazatel in ('361360','361362','361364','361366','361368') -- øádk 12a - 16a spolufinancování z NVZ
-- ) nvz_schvalene ON nvz_schvalene.id_platba = platba.id

-- LEFT JOIN
-- (select hi.nositelid,
-- 	min(hi.datumod) as "datum prvního stavu P4"
-- from isum.v_bi_umswfhistoriestavu hi
-- where hi.stavdo = 'P4'
-- group by hi.nositelid) prvni on prvni.nositelid=platba.id

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND p."Registraèní èíslo projektu" is not null 
AND fp.ID_FAZE=99991000000000005 -- sloupec aktuální stav 
AND platba.SOUCTOVYRADEK IS NULL



AND platba."Èíslo ¾ádosti o platbu" = 'CZ.01.4.03/0.0/0.0/19_259/0024756/2022/001/POST'


-------------------------------------------------------

SELECT prvni."datum prvního stavu P4",

       case when rf.id_ukazatel = 361347 then rf.castkaschvalena
       end as "CZV Schválené",

       case when rf.id_ukazatel = 361356 then rf.castkaschvalena
       end as "Dotace schválená",
       
       case when rf.id_ukazatel in ('361360','361362','361364','361366','361368') then rf.castkaschvalena
       end as "NVZ"


FROM isum.v_bi_UmpPlatbaPrj platba
LEFT JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id
LEFT JOIN
(select hi.nositelid,
	min(hi.datumod) as "datum prvního stavu P4"
from isum.v_bi_umswfhistoriestavu hi
where hi.stavdo = 'P4'
group by hi.nositelid) prvni on prvni.nositelid=platba.id





-------------------------------------------------------
SELECT platba."Èíslo ¾ádosti o platbu" ,
       rf.castkaschvalena "Schvaleno v této ®oP",
       platba."Datum zmìny stavu",
       p."Datum prvního podání",
       vu."Èíslo úètu prezentaèní forma s",
       CASE WHEN p.kodwfstav in ('PP30','PP36','PP37','PU30') THEN p.id END AS id
FROM isum.v_bi_umzprjggii p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpRozpisFinprj rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356  -- øádek 10a
INNER JOIN isum.V_BI_UMSRSVerzeUctu vu ON vu.id = platba.id_ucetprijemce
WHERE p."Registraèní èíslo projektu" = 'CZ.01.4.04/0.0/0.0/18_237/0015022'


-------------------------------------------------------

SELECT SUM(rf.castkaschvalena) AS"Schváleno na ostatních ®oP",
	count(platba.id) pocet_zop,
	platba.id_NositelPlatby
FROM isum.v_bi_UmpPlatbaPrj platba
 INNER JOIN isum.v_bi_UmpRozpisFinprj rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356  -- øádek 10a
WHERE platba.kodwfstav in ('P10','P11')
GROUP BY platba.id_NositelPlatby


-------------------------------------------------------

SELECT platba."Èíslo ¾ádosti o platbu" ,
       rf.castkaschvalena "Schvaleno v této ®oP",
       platba."Datum zmìny stavu",
       p."Datum prvního podání",
       vu."Èíslo úètu prezentaèní forma s",
       jiz_schvaleno.dotace "Schváleno na ostatních ®oP",
       jiz_schvaleno.pocet_zop

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356  -- øádek 10a
INNER JOIN isum.V_BI_UMSRSVerzeUctu vu ON vu.id = platba.id_ucetprijemce

LEFT JOIN
(SELECT sum(rf.CASTKASCHVALENA) dotace,
	count(platba.id) pocet_zop,
	p.id
 FROM isum.v_bi_UmzPrjGGII p 
 INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id = platba.id_NositelPlatby
 INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356  -- øádek 10a
 WHERE platba.kodwfstav in ('P10','P11')
 AND p.kodwfstav in ('PP30','PP36','PP37','PU30')
 GROUP BY p.id
) jiz_schvaleno ON jiz_schvaleno.id = p.id

WHERE p."Registraèní èíslo projektu" = 'CZ.01.4.04/0.0/0.0/18_237/0015022'
-- AND platba.kodwfstav in ('P5T')
