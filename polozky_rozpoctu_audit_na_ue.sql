SELECT v."Číslo výzvy" ,
       CASE WHEN v."Číslo výzvy" = '01_15_010' THEN '1.'
       	    WHEN v."Číslo výzvy" = '01_16_061' THEN '2.'
 	    WHEN v."Číslo výzvy" = '01_17_101' THEN '3.'
 	    WHEN v."Číslo výzvy" = '01_18_183' THEN '4.'
 	    WHEN v."Číslo výzvy" = '01_19_251' THEN '5.'
 	    WHEN v."Číslo výzvy" = '01_20_370' THEN '6.'
	    END AS "Pořadí výzvy",
       p."Registrační číslo projektu" ,
       hs.datumod AS "Datum  PP42",
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
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND hs.stavdo = 'PP42'
INNER JOIN isum.v_bi_UmzVyzva v ON v.id = p.id_vyzva
INNER JOIN isum.v_bi_UMFROZHlavicka hr ON hr.id_nrozpocet = p.id AND hr."Aktuální" = 'A'
INNER JOIN isum.v_bi_UMFROZPolozky pr ON pr.id_hlavicka = hr.id 
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 
INNER JOIN (
      SELECT platba.id_NositelPlatby,
             sd.id_cispolozka,
             sum(sd.vydajeschval) castka
      FROM isum.v_bi_UmpPlatbaPrj platba
      INNER JOIN isum.v_bi_UMFSoupiskaDoklad sd ON sd.id_platba = platba.id
      WHERE platba.kodwfstav IN ('P10','P11')
      --- pro testování projekt CZ.01.3.10/0.0/0.0/20_370/0023983
       -- AND platba.id_NositelPlatby IN (1135247018, 370927007, 182014424, 1672783, 533711382)
      GROUP BY platba.id_NositelPlatby,
               sd.id_cispolozka
) propl ON propl.id_cispolozka = pr.id_rozpis AND propl.id_NositelPlatby = p.id

WHERE v."Číslo výzvy" IN ('01_20_370', '01_19_251', '01_18_183', '01_17_101', '01_16_061', '01_15_010')
AND NOT REGEXP_LIKE(pr."Název", 'Celkové', 'i')
AND pr."Částka celkem" > 0
-- AND p."Registrační číslo projektu" IN ('CZ.01.3.10/0.0/0.0/20_370/0023983', 'CZ.01.3.10/0.0/0.0/19_251/0018931','CZ.01.3.10/0.0/0.0/17_101/0012206','CZ.01.3.10/0.0/0.0/16_061/0008388','CZ.01.3.10/0.0/0.0/15_010/0001465','CZ.01.3.10/0.0/0.0/18_183/0014636')


GROUP BY v."Číslo výzvy" ,
       CASE WHEN v."Číslo výzvy" = '01_15_010' THEN '1.'
       	    WHEN v."Číslo výzvy" = '01_16_061' THEN '2.'
 	    WHEN v."Číslo výzvy" = '01_17_101' THEN '3.'
 	    WHEN v."Číslo výzvy" = '01_18_183' THEN '4.'
 	    WHEN v."Číslo výzvy" = '01_19_251' THEN '5.'
 	    WHEN v."Číslo výzvy" = '01_20_370' THEN '6.'
	    END,
       p."Registrační číslo projektu" ,
       hs.datumod,
       p.zadatel ,
       p.kodwfstav,
       pzf.PROC_EU ,
       pzf."Příspěvek Unie",
       pzf."Celkové způsobilé výdaje"
       
