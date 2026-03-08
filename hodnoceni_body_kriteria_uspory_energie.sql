SELECT 	v."Číslo výzvy",
	v."Název výzvy",
	p."Registrační číslo projektu",
	p.zadatel,
	p.kodwfstav "Stav projektu" ,
	hs.p23 "Datum přepnutí stavu po VH",
 	sh.pocetbodu "Celkem bodů ve VH",
       	ci."Název" "Status hodnocení VH",
	-- hodnotitel."Kód" "Kód hodnotitele",
	kategorie."Splněné bináry v A",
	kategorie."Opravné hodnocení v A",
	kategorie."Počet bodů v B",
	kategorie."Max bodů v B",
	kategorie."Opravné hodnocení v B",
	kategorie."Počet bodů v C",
	kategorie."Max bodů v C",
	kategorie."Opravné hodnocení v C",
	kategorie."Počet bodů v D",
	kategorie."Max bodů v D",
	kategorie."Opravné hodnocení v D",
	kategorie."Počet bodů v E",
	kategorie."Max bodů v E",
	kategorie."Opravné hodnocení v E"
		
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMVHodnSoubKritVyz skv ON skv.id_vyzva = v.id
INNER JOIN isum.v_bi_UMVHodnStatusdh sh ON sh.id_souborkrit = skv.id_souborkrit AND sh.id_noshodnoceni = p.id 
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  sh.id_statushodn 
INNER JOIN (SELECT max(datumod) p23,
      	   	   nositelid
      	    FROM isum.v_bi_UmsWFHistorieStavu
	    GROUP BY nositelid) hs ON hs.NositelId = p.id
-- hodnocení v kritériích z řádných i opravných posudků
INNER JOIN (SELECT h.id_noshodnoceni,
		   h.id_souborkrit,
		     -- Indikátory opravných hodnocení
       		   CASE WHEN COUNT(CASE WHEN UPPER(opr.kod) LIKE 'A%' THEN 1 END) > 0 
			THEN 'Ano' ELSE 'Ne' END "Opravné hodnocení v A",
		   CASE WHEN COUNT(CASE WHEN UPPER(opr.kod) LIKE 'B%' THEN 1 END) > 0 
			THEN 'Ano' ELSE 'Ne' END "Opravné hodnocení v B",
		   CASE WHEN COUNT(CASE WHEN UPPER(opr.kod) LIKE 'C%' THEN 1 END) > 0 
			THEN 'Ano' ELSE 'Ne' END "Opravné hodnocení v C",
		   CASE WHEN COUNT(CASE WHEN UPPER(opr.kod) LIKE 'D%' THEN 1 END) > 0 
			THEN 'Ano' ELSE 'Ne' END "Opravné hodnocení v D",
		   CASE WHEN COUNT(CASE WHEN UPPER(opr.kod) LIKE 'E%' THEN 1 END) > 0 
			THEN 'Ano' ELSE 'Ne' END "Opravné hodnocení v E",
			
		   		   CASE WHEN SUM(CASE WHEN UPPER(COALESCE(opr.kod, kr.kod)) LIKE 'A%' 
					  AND COALESCE(opr.vyhovel, kr.vyhovel) = 'A' THEN 1 ELSE 0 END) = 
			  SUM(CASE WHEN UPPER(COALESCE(opr.kod, kr.kod)) LIKE 'A%' THEN 1 ELSE 0 END) 
		     THEN 'Ano'
		     ELSE 'Ne'
		     END "Splněné bináry v A",
		SUM(CASE WHEN UPPER(COALESCE(opr.kod, kr.kod)) LIKE 'B%' 
			 THEN COALESCE(opr.pocetbodu, kr.pocetbodu)/2 END) "Počet bodů v B",
		SUM(CASE WHEN UPPER(COALESCE(opr.kod, kr.kod)) LIKE 'B%' 
			 THEN kr.maxbodu/2 END) "Max bodů v B",
		SUM(CASE WHEN UPPER(COALESCE(opr.kod, kr.kod)) LIKE 'C%' 
			 THEN COALESCE(opr.pocetbodu, kr.pocetbodu)/2 END) "Počet bodů v C",
		SUM(CASE WHEN UPPER(COALESCE(opr.kod, kr.kod)) LIKE 'C%' 
			 THEN kr.maxbodu/2 END) "Max bodů v C",
		SUM(CASE WHEN UPPER(COALESCE(opr.kod, kr.kod)) LIKE 'D%' 
			 THEN COALESCE(opr.pocetbodu, kr.pocetbodu)/2 END) "Počet bodů v D",
		SUM(CASE WHEN UPPER(COALESCE(opr.kod, kr.kod)) LIKE 'D%' 
			 THEN kr.maxbodu/2 END) "Max bodů v D",
		SUM(CASE WHEN UPPER(COALESCE(opr.kod, kr.kod)) LIKE 'E%' 
			 THEN COALESCE(opr.pocetbodu, kr.pocetbodu)/2 END) "Počet bodů v E",
		SUM(CASE WHEN UPPER(COALESCE(opr.kod, kr.kod)) LIKE 'E%' 
			 THEN kr.maxbodu/2 END) "Max bodů v E"

		FROM isum.v_bi_UmvHodnoceniPrj h
		-- INNER JOIN isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id = h.id_hodnotitel
		INNER JOIN isum.v_bi_UMVHodnotaKrit kr ON kr.id_hodnoceni = h.id
		LEFT JOIN (SELECT h.id_noshodnoceni,
			   h.id_souborkrit,
			   kr.kod,
			   kr.id_kriterium,
			   kr.vyhovel,
			   kr.pocetbodu
			   
		    FROM isum.v_bi_UmvHodnoceniPrj h 
		    -- INNER JOIN isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id = h.id_hodnotitel
		    INNER JOIN isum.v_bi_UMVHodnotaKrit kr ON kr.id_hodnoceni = h.id
		    WHERE h.opravnehodnoceni = 'A'
			AND h.platnost = 'A'
			AND h.finalizovano = 'A'
			AND kr.needitovatelne = 'N'
			AND kr.islist = 'A'
			) opr ON opr.id_noshodnoceni = h.id_noshodnoceni
		     AND opr.id_souborkrit = h.id_souborkrit
		     AND opr.id_kriterium = kr.id_kriterium

		WHERE h.platnost = 'A'
		    AND h.arbiter = 'N'
		    AND h.finalizovano = 'A'
		    AND h.opravnehodnoceni = 'N'
		    -- AND h.id_noshodnoceni = 1617272
		    -- AND h.id_souborkrit = 1370889
	       GROUP BY h.id_noshodnoceni,
		   h.id_souborkrit
	       ) kategorie ON kategorie.id_noshodnoceni = p.id AND kategorie.id_souborkrit = skv.id_souborkrit

		    
WHERE v."Číslo výzvy" IN ('01_15_010','01_15_025','01_16_061','01_16_064','01_17_095','01_17_099','01_17_101','01_17_138','01_17_178','01_18_183','01_18_184','01_18_188','01_18_189','01_19_251','01_19_255','01_19_316','01_20_370','01_20_371')

AND skv.pocethodnotitelu = 2

AND p."Registrační číslo projektu" IN ('CZ.01.3.10/0.0/0.0/15_010/0003477','CZ.01.3.10/0.0/0.0/15_010/0000001')
-- AND v."Číslo výzvy" = '01_15_010'

ORDER BY p."Registrační číslo projektu" 
----------------------------------------


SELECT v."Číslo výzvy" ,
       v."Název výzvy" ,
       vh.id_speccil,
       sk.nazev "Název SK",
       kr.kod, 
       kr.KODFUNKCEKRITERIA

FROM isum.v_bi_UmzVyzva v
INNER JOIN isum.v_bi_UMZVYZVAHIERARCHIE vh ON vh.id_vyzva = v.id 
INNER JOIN isum.v_bi_UMVHodnSoubKritVyz skv ON skv.id_vyzva = v.id
INNER JOIN isum.V_BI_UMVHodnSouborKrit sk ON sk.id = skv.id_souborkrit
INNER JOIN isum.v_bi_UMVHODNKRITERIUM kr ON krit.id_souborkrit = sk.id 


WHERE skv.pocethodnotitelu = 2
AND skv.platnost = 'A'
AND vh.id_speccil = (406224)
-- AND v."Číslo výzvy" = '01_15_010'
AND kr.kod is not null 

ORDER BY v."Číslo výzvy" , sk.nazev, krit.id 
