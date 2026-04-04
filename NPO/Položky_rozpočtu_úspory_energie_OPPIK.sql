
SELECT  v."Číslo výzvy" ,
       CASE WHEN v."Číslo výzvy" = '01_15_010' THEN '1.'
       	    WHEN v."Číslo výzvy" = '01_16_061' THEN '2.'
 	    WHEN v."Číslo výzvy" = '01_17_101' THEN '3.'
 	    WHEN v."Číslo výzvy" = '01_18_183' THEN '4.'
 	    WHEN v."Číslo výzvy" = '01_19_251' THEN '5.'
 	    WHEN v."Číslo výzvy" = '01_20_370' THEN '6.'
	    END AS "Pořadí výzvy",
       v."Název výzvy",
       p."Registrační číslo projektu" ,
       hs.datumod "Datum certifikace (přechodu do PP42)",
       -- p."Registrační číslo projektu",
       -- p.zadatel ,
       -- p."IČ",
       -- p.kodwfstav,
       -- p.wfstavdatum,

       -- v."Číslo výzvy" ,

       -- sr.id_ciszakladni,        
       -- ci."Název" "SR",

       -- sr.id ,       
       -- -- ci."Kód" ,
       -- polsk."Kód" "Kód položky",
       -- polsk."Název" "Název položky",

       sum(CASE WHEN (sr.id = 1469972 AND polsk."Kód" = '1.2.1.1')
       	    	 OR
		 (sr.id = 366884317 AND polsk."Kód" = '1.2.1.1')
		 OR
		 (sr.id = 173209806 AND polsk."Kód" = '1.2.1.1' )
		 OR
		 (sr.id = 502893127 AND polsk."Kód" = '1.2.1.1' )
		 OR
		 (sr.id IN (1124299104, 765587257) AND REGEXP_LIKE (polsk."Kód" , '1.2.1.0[0-3]'))
	     THEN pr."Částka celkem"
	     END) AS "Stavby nerozdělené podle článků GBER / součet z rodělených podle GBER",

       sum(CASE WHEN sr.id IN (1124299104, 765587257) AND polsk."Kód" = '1.2.1.01' THEN pr."Částka celkem"
	     END) AS "Stavby čl. 38",

       sum(CASE WHEN sr.id IN (1124299104, 765587257) AND polsk."Kód" = '1.2.1.02' THEN pr."Částka celkem"
	     END) AS "Stavby čl. 40",

       sum(CASE WHEN sr.id IN (1124299104, 765587257) AND polsk."Kód" = '1.2.1.03' THEN pr."Částka celkem"
	     END) AS "Stavby čl. 41",

       sum(CASE WHEN (v."Číslo výzvy" IN  ('01_18_183', '01_17_101', '01_16_061', '01_15_010') AND polsk."Kód" = '1.2.1.2')
       	    	 OR
		 -- nepadá to tam správně 
		 (v."Číslo výzvy" IN ('01_20_370', '01_19_251') AND regexp_like(polsk."Kód", '1.2.1.0[0-4]'))
		 THEN pr."Částka celkem"
		 END) AS "Stroje a zařízení neroztříděno podle čl. GBER / součet ze všech čl. GBER",

       sum(CASE WHEN sr.id IN (1124299104, 765587257) AND polsk."Kód" = '1.2.1.04' THEN pr."Částka celkem"
	     END) AS "Stroje čl. 38",

       sum(CASE WHEN sr.id IN (1124299104, 765587257) AND polsk."Kód" = '1.2.1.05' THEN pr."Částka celkem"
	     END) AS "Stroje čl. 40",

       sum(CASE WHEN sr.id IN (1124299104, 765587257) AND polsk."Kód" = '1.2.1.06' THEN pr."Částka celkem"
	     END) AS "Stroje čl. 41",

	sum(CASE WHEN regexp_like(polsk."Název", 'činnost|inženýr', 'i') THEN pr."Částka celkem"
	     END) AS "Projektová a inženýrská činnost",


	sum(CASE WHEN regexp_like(polsk."Název", 'dokumentace', 'i') THEN pr."Částka celkem"
	     END) AS "Projektová dokumentace",

	sum(CASE WHEN regexp_like(polsk."Název", 'výběrového', 'i') THEN pr."Částka celkem"
	     END) AS "Náklady na VŘ",


	sum(CASE WHEN regexp_like(polsk."Název", 'posudek', 'i') THEN pr."Částka celkem"
	     END) AS "Energetický posudek"

       -- vp."Kombinace veřejné podpory" ,

       -- pr."Název",
       -- pr."Částka celkem",
       -- pr."Procento"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND stavdo = 'PP42'
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UMZVyzvaMD sr ON sr.id_vyzva = v.id AND sr."Platnost" = 'A' AND sr.id_cisseznam = 198427 -- skupina rozpočtu 
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  sr.id_ciszakladni
INNER JOIN isum.v_bi_UMFROZSkupina skupina ON sr.id_ciszakladni = skupina.id
INNER JOIN isum.V_BI_UMFROZSkupinaPol polsk ON polsk.id_predpis = skupina.id AND polsk."Listová" = 'A' AND not regexp_like(polsk."Název", 'nezpusobile', 'i') 
INNER JOIN isum.V_BI_UMSCisMiryVP vp ON vp.id = polsk.id_verejnapodpora

INNER JOIN isum.v_bi_UMFROZHlavicka hr ON hr.id_nrozpocet = p.id AND hr."Aktuální" = 'A' AND hr.id_skupina = skupina.id 
INNER JOIN isum.v_bi_UMFROZPolozky pr ON pr.id_hlavicka = hr.id AND pr.id_rozpis = polsk.id 
-- INNER JOIN projekty_s_polozkami psp ON psp.id_nrozpocet = p.id


WHERE v."Číslo výzvy" IN ('01_20_370', '01_19_251', '01_18_183', '01_17_101', '01_16_061', '01_15_010')
AND p.kodwfstav IN ('PP42','PP43')
-- AND sr.id = 765587257
-- AND regexp_like(polsk."Název", 'posudek', 'i')
-- AND hs.datumod  >= DATE '2020-07-01'
-- AND hs.datumod < DATE '2021-01-01'
-- AND p."Registrační číslo projektu" = 'CZ.01.3.10/0.0/0.0/20_370/0026512'
AND p."Registrační číslo projektu" IN 'CZ.01.3.10/0.0/0.0/19_251/0020070'


GROUP BY v."Číslo výzvy" ,
       CASE WHEN v."Číslo výzvy" = '01_15_010' THEN '1.'
       	    WHEN v."Číslo výzvy" = '01_16_061' THEN '2.'
 	    WHEN v."Číslo výzvy" = '01_17_101' THEN '3.'
 	    WHEN v."Číslo výzvy" = '01_18_183' THEN '4.'
 	    WHEN v."Číslo výzvy" = '01_19_251' THEN '5.'
 	    WHEN v."Číslo výzvy" = '01_20_370' THEN '6.'
	    END,
       v."Název výzvy",
       p."Registrační číslo projektu" ,
       hs.datumod
       -- p."Registrační číslo projektu",
       -- p.zadatel ,
       -- p."IČ",
       -- p.kodwfstav,
       -- p.wfstavdatum,

       -- v."Číslo výzvy" ,

       -- sr.id_ciszakladni,        
       -- ci."Název",

       -- sr.id ,       
       -- -- ci."Kód" ,
       -- polsk."Kód",
       -- polsk."Název",
       -- vp."Kombinace veřejné podpory" ,

       -- pr."Název",
       -- pr."Částka celkem",
       -- pr."Procento"




ORDER BY v."Číslo výzvy", p."Registrační číslo projektu" -- , polsk."Kód" 




------------------------------
SELECT p."Registrační číslo projektu",
       pr."Kód" ,
       pr."Název" ,
       pr."Částka celkem" ,
       vpo.*
       


FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UMZVyzvaMD sr ON sr.id_vyzva = v.id AND sr."Platnost" = 'A' AND sr.id_cisseznam = 198427 -- skupina rozpočtu 
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  sr.id_ciszakladni
INNER JOIN isum.v_bi_UMFROZSkupina skupina ON sr.id_ciszakladni = skupina.id
INNER JOIN isum.V_BI_UMFROZSkupinaPol polsk ON polsk.id_predpis = skupina.id AND polsk."Listová" = 'A' AND NOT regexp_like(polsk."Název", 'nezpusobile', 'i')INNER JOIN isum.V_BI_UMSCisMiryVP vp ON vp.id = polsk.id_verejnapodpora
INNER JOIN isum.v_bi_UMSRDMPodpora vpo ON vpo.id_projekt = p.id AND vpo.id_verejnapodpora = vp.id
INNER JOIN isum.v_bi_UMFROZHlavicka hr ON hr.id_nrozpocet = p.id AND hr."Aktuální" = 'A' AND hr.id_skupina = skupina.id 
INNER JOIN isum.v_bi_UMFROZPolozky pr ON pr.id_hlavicka = hr.id AND pr.id_rozpis = polsk.id 
-- INNER JOIN isum.v_bi_UMFPomerFinancovani pf ON pf.id_nositelpompf = vpo.id 

WHERE p."Registrační číslo projektu" IN 'CZ.01.3.10/0.0/0.0/19_251/0020441'
AND pr."Kód" IN ('1.2.1.01', '1.2.1.03')


------------------------------


SELECT *

FROM isum.v_bi_UMFPomerFinancovani

WHERE id_hlavicka = 765586709

-- WHERE id = (947447502, 947447504)


------------------------------


SELECT *
FROM isum.v_bi_UMFPomeryHlavicka

WHERE id = 765586709


------------------------------


SELECT *

-- FROM isum.v_bi_UMSBonifikaceVP
FROM isum.v_bi_UMSRdMBonifikace



-- WHERE id = 624142040


----------------------------------------
SELECT v."Číslo výzvy" ,
       CASE WHEN v."Číslo výzvy" = '01_15_010' THEN '1.'
       	    WHEN v."Číslo výzvy" = '01_16_061' THEN '2.'
 	    WHEN v."Číslo výzvy" = '01_17_101' THEN '3.'
 	    WHEN v."Číslo výzvy" = '01_18_183' THEN '4.'
 	    WHEN v."Číslo výzvy" = '01_19_251' THEN '5.'
 	    WHEN v."Číslo výzvy" = '01_20_370' THEN '6.'
	    END AS "Pořadí výzvy",
       p."Registrační číslo projektu" ,
       pl.datumcert AS "Datum  PP42",
       p.zadatel ,
       p.kodwfstav,
       pzf.PROC_EU ,
       pzf."Příspěvek Unie",
       pzf."Celkové způsobilé výdaje",
       -- pr."Kód" ,
       -- pr."Název" ,
       -- pr."Částka celkem",
       -- propl.castka "Schválené ZV na ŽoP",
       -- pzf.PROC_EU * propl.castka / 100.0  "Proplacená dotace"
       sum(CASE WHEN pr."Kód" = '1.2.1.1' OR REGEXP_LIKE(pr."Kód",'1\.2\.1\.0[1-3]') THEN pr."Částka celkem" 
	     END) AS "Stavby ZV rozpočet celkem",
       sum(CASE WHEN pr."Kód" = '1.2.1.1' OR REGEXP_LIKE(pr."Kód",'1\.2\.1\.0[1-3]') THEN pr."Částka celkem" * pzf.PROC_EU / 100
	     END) AS "Stavby EU dotace rozpočet",
       sum(CASE WHEN pr."Kód" = '1.2.1.1' OR REGEXP_LIKE(pr."Kód",'1\.2\.1\.0[1-3]') THEN propl.castka
	     END) AS "Stavby Schválené ZV ŽoP",
       sum(CASE WHEN pr."Kód" = '1.2.1.1' OR REGEXP_LIKE(pr."Kód",'1\.2\.1\.0[1-3]') THEN propl.castka * pzf.PROC_EU / 100
	     END) AS "Stavby EU dotace ŽoP",
       
       ----------
       sum(CASE WHEN pr."Kód" = '1.2.1.01' THEN pr."Částka celkem"
	     END) AS "Stavby ZV rozpočet čl. 38",

       sum(CASE WHEN pr."Kód" = '1.2.1.02' THEN pr."Částka celkem"
	     END) AS "Stavby ZV rozpočet čl. 40",

       sum(CASE WHEN pr."Kód" = '1.2.1.03' THEN pr."Částka celkem"
	     END) AS "Stavby ZV rozpočet čl. 41" ,

       sum(CASE WHEN pr."Kód" = '1.2.1.01' THEN pr."Částka celkem" * pzf.PROC_EU / 100
	     END) AS "Stavby EU dotace rozpočet čl. 38",

       sum(CASE WHEN pr."Kód" = '1.2.1.02' THEN pr."Částka celkem" * pzf.PROC_EU / 100
	     END) AS "Stavby EU dotace rozpočet čl. 40",

       sum(CASE WHEN pr."Kód" = '1.2.1.03' THEN pr."Částka celkem" * pzf.PROC_EU / 100
	     END) AS "Stavby EU dotace rozpočet čl. 41" ,

       sum(CASE WHEN pr."Kód" = '1.2.1.01' THEN propl.castka
	     END) AS "Stavby Schválené ZV ŽoP čl. 38",

       sum(CASE WHEN pr."Kód" = '1.2.1.02' THEN propl.castka
	     END) AS "Stavby Schválené ZV ŽoP čl. 40",

       sum(CASE WHEN pr."Kód" = '1.2.1.03' THEN propl.castka
	     END) AS "Stavby Schválené ZV ŽoP čl. 41" ,

       sum(CASE WHEN pr."Kód" = '1.2.1.01' THEN propl.castka * pzf.PROC_EU / 100
	     END) AS "Stavby proplaceno EU čl. 38",

       sum(CASE WHEN pr."Kód" = '1.2.1.02' THEN propl.castka * pzf.PROC_EU / 100
	     END) AS "Stavby proplaceno EU čl. 40",

       sum(CASE WHEN pr."Kód" = '1.2.1.03' THEN propl.castka * pzf.PROC_EU / 100
	     END) AS "Stavby proplaceno EU čl. 41",

	     ----------
       sum(CASE WHEN pr."Kód" = '1.2.1.2' OR REGEXP_LIKE(pr."Kód",'1\.2\.1\.0[4-6]') THEN pr."Částka celkem" 
	     END) AS "Stroje ZV rozpočet celkem",
       sum(CASE WHEN pr."Kód" = '1.2.1.2' OR REGEXP_LIKE(pr."Kód",'1\.2\.1\.0[4-6]') THEN pr."Částka celkem" * pzf.PROC_EU / 100
	     END) AS "Stroje EU dotace rozpočet",
       sum(CASE WHEN pr."Kód" = '1.2.1.2' OR REGEXP_LIKE(pr."Kód",'1\.2\.1\.0[4-6]') THEN propl.castka
	     END) AS "Stroje Schválené ZV ŽoP",
       sum(CASE WHEN pr."Kód" = '1.2.1.2' OR REGEXP_LIKE(pr."Kód",'1\.2\.1\.0[4-6]') THEN propl.castka * pzf.PROC_EU / 100
	     END) AS "Stroje EU dotace ŽoP",
	     
	     ----------
	     
       sum(CASE WHEN pr."Kód" = '1.2.1.04' THEN pr."Částka celkem"
	     END) AS "Stroje ZV rozpočet čl. 38",

       sum(CASE WHEN pr."Kód" = '1.2.1.05' THEN pr."Částka celkem"
	     END) AS "Stroje ZV rozpočet čl. 40",

       sum(CASE WHEN pr."Kód" = '1.2.1.06' THEN pr."Částka celkem"
	     END) AS "Stroje ZV rozpočet čl. 41" ,

       sum(CASE WHEN pr."Kód" = '1.2.1.04' THEN pr."Částka celkem" * pzf.PROC_EU / 100
	     END) AS "Stroje EU dotace rozpočet čl. 38",

       sum(CASE WHEN pr."Kód" = '1.2.1.05' THEN pr."Částka celkem" * pzf.PROC_EU / 100
	     END) AS "Stroje EU dotace rozpočet čl. 40",

       sum(CASE WHEN pr."Kód" = '1.2.1.06' THEN pr."Částka celkem" * pzf.PROC_EU / 100
	     END) AS "Stroje EU dotace rozpočet čl. 41" ,

       sum(CASE WHEN pr."Kód" = '1.2.1.04' THEN propl.castka
	     END) AS "Stroje Schválené ZV ŽoP čl. 38",

       sum(CASE WHEN pr."Kód" = '1.2.1.05' THEN propl.castka
	     END) AS "Stroje Schválené ZV ŽoP čl. 40",

       sum(CASE WHEN pr."Kód" = '1.2.1.06' THEN propl.castka
	     END) AS "Stroje Schválené ZV ŽoP čl. 41" ,

       sum(CASE WHEN pr."Kód" = '1.2.1.04' THEN propl.castka * pzf.PROC_EU / 100
	     END) AS "Stroje proplaceno EU čl. 38",

       sum(CASE WHEN pr."Kód" = '1.2.1.05' THEN propl.castka * pzf.PROC_EU / 100
	     END) AS "Stroje proplaceno EU čl. 40",

       sum(CASE WHEN pr."Kód" = '1.2.1.06' THEN propl.castka * pzf.PROC_EU / 100
	     END) AS "Stroje proplaceno EU čl. 41"
	     


FROM isum.v_bi_UmzProjekt p
-- INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND hs.stavdo = 'PP42'
INNER JOIN isum.v_bi_UmzVyzva v ON v.id = p.id_vyzva
INNER JOIN isum.v_bi_UMFROZHlavicka hr ON hr.id_nrozpocet = p.id AND hr."Aktuální" = 'A'
INNER JOIN isum.v_bi_UMFROZPolozky pr ON pr.id_hlavicka = hr.id 
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 
INNER JOIN (SELECT max(platba.datumcertifikace) datumcert,
      	   	   platba.id_nositelplatby
            FROM isum.v_bi_UmpPlatbaPrj platba

	    GROUP BY platba.id_nositelplatby
	    ) pl ON pl.id_nositelplatby = p.id 
	    
LEFT JOIN (
      SELECT platba.id_NositelPlatby,
             sd.id_cispolozka,
             sum(sd.vydajeschval) castka

      FROM isum.v_bi_UmpPlatbaPrj platba
      INNER JOIN isum.v_bi_UMFSoupiskaDoklad sd ON sd.id_platba = platba.id
      WHERE platba.kodwfstav IN ('P10','P11')
      --- pro testování projekt CZ.01.3.10/0.0/0.0/20_370/0023983
       -- AND platba.id_NositelPlatby IN (1135247018, 370927007, 182014424, 1672783, 533711382)
      AND platba.id_NositelPlatby = 1737275 
      GROUP BY platba.id_NositelPlatby,
               sd.id_cispolozka
      ) propl ON propl.id_cispolozka = pr.id_rozpis AND propl.id_NositelPlatby = p.id



WHERE v."Číslo výzvy" IN ('01_20_370', '01_19_251', '01_18_183', '01_17_101', '01_16_061', '01_15_010')
AND NOT REGEXP_LIKE(pr."Název", 'Celkové', 'i')
AND pr."Částka celkem" > 0
-- AND p."Registrační číslo projektu" in ('CZ.01.3.10/0.0/0.0/15_010/0000640','CZ.01.3.10/0.0/0.0/15_010/0000787')
-- AND propl.datumcert >= DATE '2020-07-01'


GROUP BY v."Číslo výzvy" ,
       CASE WHEN v."Číslo výzvy" = '01_15_010' THEN '1.'
       	    WHEN v."Číslo výzvy" = '01_16_061' THEN '2.'
 	    WHEN v."Číslo výzvy" = '01_17_101' THEN '3.'
 	    WHEN v."Číslo výzvy" = '01_18_183' THEN '4.'
 	    WHEN v."Číslo výzvy" = '01_19_251' THEN '5.'
 	    WHEN v."Číslo výzvy" = '01_20_370' THEN '6.'
	    END,
       p."Registrační číslo projektu" ,
       pl.datumcert,
       p.zadatel ,
       p.kodwfstav,
       pzf.PROC_EU ,
       pzf."Příspěvek Unie",
       pzf."Celkové způsobilé výdaje"
