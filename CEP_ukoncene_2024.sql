ELECT p."Registraèní èíslo projektu",
       substr(p."Registraèní èíslo projektu",-5,5) "Projekt" ,
       p.zadatel "®adatel",
       zav."Název dokumentu",
       zav."Link DMS" ,
       zav."Typ souboru",
       vs.pocet "Poèet partnerù"

FROM isum.v_bi_UmzProjekt p 
LEFT JOIN (SELECT platba.id ,
      	    	   pril."Název dokumentu",
       		   pril."Link DMS" ,
		   SUBSTR(pril.PRILOHADMS, -4, 4) AS "Typ souboru", 
      	   	   platba."Èíslo ¾ádosti o platbu" ,
		   platba.id_nositelplatby
	    FROM isum.v_bi_UmpPlatbaPrj platba
	    INNER JOIN isum.v_bi_UMSPrilohy pril ON pril.id_nositelpril = platba.id
	    LEFT JOIN (SELECT max(poradi) posledni,
			       id_nositelpril
	    	        FROM isum.v_bi_UMSPrilohyPlatba
			-- WHERE (upper(nazevpril) like upper('%kontrolni%') OR upper(nazevpril) like upper('%kontrolní%') )
			WHERE (upper(nazevpril) like upper('%kontr%') OR upper(nazevpril) like upper('%tabulka%') )
			GROUP BY id_nositelpril
			) poslpril ON poslpril.id_nositelpril = platba.id
	    WHERE platba."Závìreèná platba" = 'A'
	    AND poslpril.posledni = pril."Poøadí"
	    ) zav ON zav.id_nositelplatby = p.id
left JOIN (SELECT count(vs.id) pocet,
      	   	   vs.id_prjgg
  FROM isum.v_bi_UmzPrjGGvs vs
  WHERE vs.neplatny is null
  AND vs.id_typsubjektu = 300785 -- partner
  GROUP BY vs.id_prjgg ) vs ON vs.id_prjgg = p.id

-- INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id

WHERE 
-- hs.stavdo = 'PP40'
-- AND to_date('2024-01-01','yyyy-mm-dd') <= hs.datumod
-- AND hs.datumod < to_date('2025-01-01','yyyy-mm-dd')  
-- AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'
-- AND p.kodwfstav in ('PP41','PP42','PP43')

p."Registraèní èíslo projektu" like ('%23876')
OR p."Registraèní èíslo projektu" like ('%24033')
OR p."Registraèní èíslo projektu" like ('%24328')
OR p."Registraèní èíslo projektu" like ('%24842')
OR p."Registraèní èíslo projektu" like ('%24864')
OR p."Registraèní èíslo projektu" like ('%24871')
OR p."Registraèní èíslo projektu" like ('%26862')
OR p."Registraèní èíslo projektu" like ('%27339')
OR p."Registraèní èíslo projektu" like ('%27380')



ORDER BY p."Registraèní èíslo projektu"
