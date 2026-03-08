SELECT p."Registraèní èíslo projektu",
       substr(p."Registraèní èíslo projektu",-5,5) "Projekt" ,
       p.zadatel,
       p."Název projektu CZ",
       p.id,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       REPLACE(REPLACE(zav."Název dokumentu",CHR(10),' $ '),CHR(13),' $ ') "Název dokumentu",
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
LEFT JOIN (SELECT count(vs.id) pocet,
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
	    -- AND platba."Èíslo ¾ádosti o platbu" = 'CZ.01.1.02/0.0/0.0/20_321/0024777/2023/004/POST'
	    AND poslpril.posledni = pril."Poøadí"
	    ) zav ON zav.id_nositelplatby = p.id

WHERE p.kodwfstav in ('PP41','PP42','PP43')
AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'
-- AND v."Èíslo výzvy" IN ('01_17_106','01_17_107','01_17_175','01_17_176','01_19_262','01_20_321')
AND to_date('2023-01-01','yyyy-mm-dd') <= platba."Datum proplacení pøíjemci"
AND platba."Datum proplacení pøíjemci" <= to_date('2024-01-11','yyyy-mm-dd')  
AND platba.kodwfstav in ('P10','P11','P12','P13','P13T','P14','P14T')

GROUP BY p."Registraèní èíslo projektu",
       substr(p."Registraèní èíslo projektu",-5,5),
       p.zadatel,
       p."Název projektu CZ",
       p.id,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       zav."Název dokumentu",
       zav."Link DMS" ,
       vs.pocet
