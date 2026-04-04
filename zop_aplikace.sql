SELECT p."Registraèní èíslo projektu",
       substr(p."Registraèní èíslo projektu",-5,5) "Projekt" ,
       p.zadatel,
       p."Název projektu CZ",
       p.id,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       zav."Název dokumentu",
       zav."Link DMS" ,

       max(platba."Datum proplacení pøíjemci") "Poslední datum proplacení ®oP v 2023" ,
       max( platba."Èíslo ¾ádosti o platbu") "Èíslo ¾ádosti o platbu, poslední v 2023",
       count( platba."Èíslo ¾ádosti o platbu") "Poèet ¾ádosti o platbu 2023",
       -- pril.NAZEVPRIL,
       -- pril."Link DMS" ,
       vs.pocet "Poèet partnerù",
       sum(czv.czv) "suma czv",
       sum(eu.eu) "suma eu"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id = p.id_vyzva 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id = platba.id_NositelPlatby 
-- INNER JOIN isum.v_bi_UMFSmlouva sml ON  sml.id_nositelsml = p.id
-- INNER JOIN isum.v_bi_UMSPrilohyPA pril ON pril.id_nositelpril = sml.id
left JOIN (SELECT count(vs.id) pocet,
      	   	   vs.id_prjgg
  FROM isum.v_bi_UmzPrjGGvs vs
  WHERE vs.neplatny is null
  AND vs.id_typsubjektu = 300785 -- partner
  GROUP BY vs.id_prjgg ) vs ON vs.id_prjgg = p.id
INNER JOIN (SELECT rf.castkaschvalena czv ,
	rf.id_platba
  FROM isum.v_bi_UmpRozpisFin rf
  WHERE rf.id_ukazatel = 361347) czv ON czv.id_platba = platba.id

INNER JOIN (SELECT rf.castkaschvalena eu ,
	rf.id_platba
  FROM isum.v_bi_UmpRozpisFin rf
  WHERE rf.id_ukazatel = 361356) eu ON eu.id_platba = platba.id

INNER JOIN (
      	    SELECT platba.id ,
      	    	   pril."Název dokumentu",
       		   pril."Link DMS" ,
      	   	   platba."Èíslo ¾ádosti o platbu" ,
		   platba.id_nositelplatby
	    FROM isum.v_bi_UmpPlatbaPrj platba
	    INNER JOIN isum.v_bi_UMSPrilohy pril ON pril.id_nositelpril = platba.id
	    INNER JOIN (
	    	        SELECT max(poradi) posledni,
			       id_nositelpril
	    	        FROM isum.v_bi_UMSPrilohyPlatba
			WHERE (upper(nazevpril) like upper('%kontrolni%') OR upper(nazevpril) like upper('%kontrolní%') )
			GROUP BY id_nositelpril
			) poslpril ON poslpril.id_nositelpril = platba.id
	    WHERE platba."Závìreèná platba" = 'A'
	    AND platba."Èíslo ¾ádosti o platbu" = 'CZ.01.1.02/0.0/0.0/20_321/0024458/2023/003/POST'
	    AND poslpril.posledni = pril."Poøadí"
	    ) zav ON zav.id_nositelplatby = p.id

WHERE p.kodwfstav in ('PP41','PP42','PP43')
AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'
-- AND v."Èíslo výzvy" IN ('01_17_106','01_17_107','01_17_175','01_17_176','01_19_262','01_20_321')
-- AND p."Registraèní èíslo projektu" IN ('CZ.01.1.02/0.0/0.0/17_176/0015727')
-- AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/17_176/0015523'
AND to_date('2023-01-01','yyyy-mm-dd') <= platba."Datum proplacení pøíjemci"
AND platba."Datum proplacení pøíjemci" <= to_date('2023-12-31','yyyy-mm-dd')  
AND platba.kodwfstav in ('P10','P11','P12','P13','P13T','P14','P14T')
-- AND upper(pril.NAZEVPRIL) like upper('%Rozpoèet%')
-- AND sml."Poøadí" = 1

GROUP BY p."Registraèní èíslo projektu",
       substr(p."Registraèní èíslo projektu",-5,5),
       p.zadatel,
       p."Název projektu CZ",
       p.id,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       zav."Název dokumentu",
       zav."Link DMS" ,

       -- platba."Datum proplacení pøíjemci",
       -- platba."Èíslo ¾ádosti o platbu" ,
       -- pril.NAZEVPRIL,
       -- pril."Link DMS" ,
       vs.pocet


-- https://msiu.mssf.cz/api/v01/as/exports/document?docID=VU1TUHJpbG9oeVBsYXRiYTsxODk0MTcwNDM0O1ByaWxvaGFETVM7ZmFsc2U=


-- SELECT *
-- from isum.v_bi_umsprilohy
