SELECT v."Číslo výzvy",
       v."Název výzvy" ,
       p."Registrační číslo projektu",
       p.zadatel "Příjemce",
       p."IČ",
       p.wfstav,
       p.kodWFStav,
       pzf."Celkové způsobilé výdaje" "Plánované celkové způsobilé výdaje" ,
       pzf."Příspěvek Unie" "Plánovaná dotace",
       pzf.PROC_EU "Procento dotace" ,
       zopky.propl "Skutečně proplacená dotace",
       part.partner "Partneři příjemce",
       part.icpartner "IČ partnerů příjemce",
       part.pocet "Počet partnerů",
       -- n."CZ NACE",
       -- n."Kód CZ NACE" ,
       h.poradi,
       hod."Kód" AS "Kód hodnotitele",
       h.arbiter "Arbitr",
       h.OPRAVNEHODNOCENI "Opravný hodnotitel",
       h.DATUM_FINALIZACE "Datum finalizace",
       h.pocetbodu "Počet bodů" ,
       h.RATINGHODNZNAMKA, 
       h.RATINGHODNPOPIS,
       h.STAVPOSUDKU,
       krit.pocetbodu "Bodů v kritériu D1 (max 18)" ,
       n.pocet_nace
/* INFORMACE O PROJEKTU, FINANCOVÁNÍ A PARTNERECH */

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id = p.id_vyzva
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 
/* Sčítání proplacených dotací ze všech proplacených ŽoP */
LEFT JOIN (SELECT sum(rf.CASTKASCHVALENA) propl,
      	   	   platba.id_nositelplatby
            FROM isum.v_bi_UmpPlatbaPrj platba 
	    INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- řádek 10a sloupec schváleno na F1-C)
	    WHERE platba.kodwfstav in ('P10','P11') 
	    GROUP BY platba.id_nositelplatby ) zopky ON zopky.id_nositelplatby = p.id 
/* LEFT JOIN kvůli případné neexistenci partnerů - paks INNER JOIN by projekt ve výstupu nebyl */
LEFT JOIN (SELECT LISTAGG( vs."Název subjektu", '; ') partner,
     	  	  LISTAGG( vs."IČ", '; ') icpartner,
		  count(vs.id) pocet,
		  vs.id_prjgg
           FROM isum.v_bi_UmzPrjGGvs vs
	   INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  vs.id_typsubjektuEdit 
 	   WHERE vs.neplatny is null
	   AND ci."Název" like 'Partner%'
	   GROUP BY vs.id_prjgg) part ON part.id_prjgg = p.id

/* CZ NACE */

-- můžu psát INNER JOIN - vyhodí projekty, které nejsou CZ NACE 20* nebo 21* 
INNER JOIN (SELECT count(n.id) pocet_nace,
			-- LISTAGG( ci."Název", '; ' on overflow truncate) AS "CZ NACE",
           	   -- LISTAGG( ci."Kód", '; ' on overflow truncate) AS "Kód CZ NACE",
		   n.id_subjekt
            FROM isum.v_bi_umsrscznace n 
	    INNER JOIN isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
	    WHERE n."Je součástí projektu?" = 'A'
	    -- AND (ci."Kód" like '20%' OR ci."Kód" like '21%')
	    GROUP BY n.id_subjekt
	    ) n ON n.id_subjekt=p.id_zadatel

/* ČÁST HODNOCENÍ */

INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
INNER JOIN isum.v_bi_UmvHodnotitel hod ON hod.id = h.id_hodnotitel
INNER JOIN isum.v_bi_UMVHodnotaKrit krit ON krit.id_hodnoceni = h.id 

WHERE v."Číslo výzvy" IN ('01_15_018','01_15_019')
AND h.id_kolohodnoceni=171212   /* hodnocení "ostré" žádosti */
AND h.id_KrokVecHodn = 171213 /* 1. krok VH */ 
AND h.platnost = 'A'
AND h.finalizovano = 'A'
AND krit.kod = 'D1'

-- AND p."Registrační číslo projektu"  = ('CZ.01.1.02/0.0/0.0/15_019/0002421','CZ.01.1.02/0.0/0.0/15_018/0004478')

ORDER BY pocet_nace DESC  -- substr(p."Registrační číslo projektu",-5,5) ASC , h.poradi

----------------------------------------


SELECT v."Číslo výzvy",
       v."Název výzvy" ,
       p."Registrační číslo projektu",
       p."Název projektu CZ" ,
       p.zadatel "Příjemce",
       p."IČ",
       p.wfstav,
       p.kodWFStav,
       pzf."Celkové způsobilé výdaje" "Plánované celkové způsobilé výdaje" ,
       pzf."Příspěvek Unie" "Plánovaná dotace",
       pzf.PROC_EU "Procento dotace" ,
       zopky.propl "Skutečně proplacená dotace",
       -- nesr.vymozeno,
       -- nesr.pocetnesr,
       -- zopky.propl - nesr.vymozeno AS  "Proplacená mínus vymožená dotace",
       -- nesr.uroven,
       part.partner "Partneři příjemce",
       part.icpartner "IČ partnerů příjemce",
       part.pocet "Počet partnerů",
       n."CZ NACE",
       n."Kód CZ NACE" ,
       n.prj "CZ NACE projektu" ,
       n.nehledanych_nace,
       n.id_subjekt ,
       h.poradi,
       hod."Kód" AS "Kód hodnotitele",
       h.arbiter "Arbitr",
       h.OPRAVNEHODNOCENI "Opravný hodnotitel",
       h.DATUM_FINALIZACE "Datum finalizace",
       h.pocetbodu "Počet bodů" ,
       h.RATINGHODNZNAMKA, 
       h.RATINGHODNPOPIS,
       h.STAVPOSUDKU,
       krit.pocetbodu "Bodů v kritériu D1 (max 18)" 

/* INFORMACE O PROJEKTU, FINANCOVÁNÍ A PARTNERECH */

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id = p.id_vyzva
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 
/* Sčítání proplacených dotací ze všech proplacených ŽoP */
LEFT JOIN (SELECT sum(rf.CASTKASCHVALENA) propl,
      	   	   platba.id_nositelplatby
            FROM isum.v_bi_UmpPlatbaPrj platba 
	    INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- řádek 10a sloupec schváleno na F1-C)
	    WHERE platba.kodwfstav in ('P10','P11') 
	    GROUP BY platba.id_nositelplatby ) zopky ON zopky.id_nositelplatby = p.id 
/* LEFT JOIN kvůli případné neexistenci partnerů - paks INNER JOIN by projekt ve výstupu nebyl */
LEFT JOIN (SELECT LISTAGG( vs."Název subjektu", '; ') partner,
     	  	  LISTAGG( vs."IČ", '; ') icpartner,
		  count(vs.id) pocet,
		  vs.id_prjgg
           FROM isum.v_bi_UmzPrjGGvs vs
	   INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  vs.id_typsubjektuEdit 
 	   WHERE vs.neplatny is null
	   AND ci."Název" like 'Partner%'
	   GROUP BY vs.id_prjgg) part ON part.id_prjgg = p.id

-- /* PŔÍPADNkÉ NESROVNALOSTI */
-- LEFT JOIN ( SELECT sum(fd.CASTKACZK) vymozeno,
--      	    	   count(nesr.id) pocetnesr,
-- 		   LISTAGG( DISTINCT nesr.UROVEN) uroven,
--        	    	   nesr.id_nositelnesr
-- 	    FROM isum.v_bi_UMZNesrovnalost nesr
-- 	    INNER JOIN isum.v_bi_UMZNesrFinDopad fd ON fd.id_nesrovnalost = nesr.id
-- 	    WHERE fd.soucet = 'A'
-- 	    GROUP BY nesr.id_nositelnesr) nesr ON nesr.id_nositelnesr = p.id

/* CZ NACE */

-- můžu psát INNER JOIN - vyhodí projekty, které nejsou CZ NACE 20* nebo 21* , bohužel -20 minut <= existují projekty bez CZ NACE
LEFT JOIN (SELECT LISTAGG(
			CASE WHEN (ci."Kód" like '20%' OR ci."Kód" like '21%') THEN ci."Název"
 			ELSE NULL END , '; '
			 ) AS "CZ NACE",
		  LISTAGG(
			CASE WHEN (ci."Kód" like '20%' OR ci."Kód" like '21%') THEN ci."Kód" 
 			ELSE NULL END , '; ' 
			 ) AS "Kód CZ NACE",
		  LISTAGG( DISTINCT 
			CASE WHEN (ci."Kód" like '20%' OR ci."Kód" like '21%') THEN n."Je součástí projektu?"
 			ELSE NULL END , '; ' 
			 ) prj, 
		  count (  
			CASE WHEN (ci."Kód" not like '20%' AND ci."Kód" not like '21%') THEN ci.id
 			ELSE NULL END 
			 ) nehledanych_nace ,
		  n.id_subjekt
		  
 	    FROM isum.v_bi_umsrscznace n 
	    INNER JOIN isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
	    -- WHERE n."Je součástí projektu?" = 'A'
	    -- AND (ci."Kód" like '20%' OR ci."Kód" like '21%')
	    GROUP BY n.id_subjekt
	    ) n ON n.id_subjekt = p.id_zadatel

/* ČÁST HODNOCENÍ */

INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
INNER JOIN isum.v_bi_UmvHodnotitel hod ON hod.id = h.id_hodnotitel
INNER JOIN isum.v_bi_UMVHodnotaKrit krit ON krit.id_hodnoceni = h.id 

WHERE v."Číslo výzvy" IN ('01_15_018','01_15_019')
AND h.id_kolohodnoceni=171212   /* hodnocení "ostré" žádosti */
AND h.id_KrokVecHodn = 171213 /* 1. krok VH */ 
AND h.platnost = 'A'
AND h.finalizovano = 'A'
AND krit.kod = 'D1'
AND (
    n.id_subjekt is null
    OR
    n."Kód CZ NACE" is not null 
    )

-- AND p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/15_019/0002421','CZ.01.1.02/0.0/0.0/15_018/0004478','CZ.01.1.02/0.0/0.0/15_018/0004231','CZ.01.1.02/0.0/0.0/15_018/0000727')

ORDER BY substr(p."Registrační číslo projektu",-5,5) ASC , h.poradi






----------------------------------------


SELECT v."Číslo výzvy",
       v."Název výzvy" ,
       p."Registrační číslo projektu",
       p.zadatel "Příjemce",
       p."IČ",
       p.wfstav,
       p.kodWFStav,
       pzf."Celkové způsobilé výdaje" "Plánované celkové způsobilé výdaje" ,
       pzf."Příspěvek Unie" "Plánovaná dotace",
       pzf.PROC_EU "Procento dotace" ,
       zopky.propl "Skutečně proplacená dotace",
       part.partner "Partneři příjemce",
       part.icpartner "IČ partnerů příjemce",
       part.pocet "Počet partnerů",
       n."CZ NACE",
       n."Kód CZ NACE" ,
       h.poradi,
       hod."Kód" AS "Kód hodnotitele",
       h.arbiter "Arbitr",
       h.OPRAVNEHODNOCENI "Opravný hodnotitel",
       h.DATUM_FINALIZACE "Datum finalizace",
       h.pocetbodu "Počet bodů" ,
       h.RATINGHODNZNAMKA, 
       h.RATINGHODNPOPIS,
       h.STAVPOSUDKU,
       krit.pocetbodu "Bodů v kritériu D1 (max 18)"

/* INFORMACE O PROJEKTU, FINANCOVÁNÍ A PARTNERECH */

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id = p.id_vyzva
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 
/* Sčítání proplacených dotací ze všech proplacených ŽoP */
LEFT JOIN (SELECT sum(rf.CASTKASCHVALENA) propl,
      	   	   platba.id_nositelplatby
            FROM isum.v_bi_UmpPlatbaPrj platba 
	    INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- řádek 10a sloupec schváleno na F1-C)
	    WHERE platba.kodwfstav in ('P10','P11') 
	    GROUP BY platba.id_nositelplatby ) zopky ON zopky.id_nositelplatby = p.id 
/* LEFT JOIN kvůli případné neexistenci partnerů - paks INNER JOIN by projekt ve výstupu nebyl */
LEFT JOIN (SELECT LISTAGG( vs."Název subjektu", '; ') partner,
     	  	  LISTAGG( vs."IČ", '; ') icpartner,
		  count(vs.id) pocet,
		  vs.id_prjgg
           FROM isum.v_bi_UmzPrjGGvs vs
	   INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  vs.id_typsubjektuEdit 
 	   WHERE vs.neplatny is null
	   AND ci."Název" like 'Partner%'
	   GROUP BY vs.id_prjgg) part ON part.id_prjgg = p.id

/* CZ NACE */

-- můžu psát INNER JOIN - vyhodí projekty, které nejsou CZ NACE 20* nebo 21* 
INNER JOIN ( SELECT LISTAGG( ci."Název", '; ' on overflow truncate) AS "CZ NACE",
           	   LISTAGG( ci."Kód", '; ' on overflow truncate) AS "Kód CZ NACE",
		   n.id_subjekt
            FROM isum.v_bi_umsrscznace n 
	    INNER JOIN isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
	    WHERE n."Je součástí projektu?" = 'A'
	    -- AND (ci."Kód" like '20%' OR ci."Kód" like '21%')
	    GROUP BY n.id_subjekt
	    ) n ON n.id_subjekt=p.id_zadatel

/* ČÁST HODNOCENÍ */

INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
INNER JOIN isum.v_bi_UmvHodnotitel hod ON hod.id = h.id_hodnotitel
INNER JOIN isum.v_bi_UMVHodnotaKrit krit ON krit.id_hodnoceni = h.id 

WHERE v."Číslo výzvy" IN ('01_15_018','01_15_019')
AND h.id_kolohodnoceni=171212   /* hodnocení "ostré" žádosti */
AND h.id_KrokVecHodn = 171213 /* 1. krok VH */ 
AND h.platnost = 'A'
AND h.finalizovano = 'A'
AND krit.kod = 'D1'

-- AND p."Registrační číslo projektu"  = ('CZ.01.1.02/0.0/0.0/15_019/0002421','CZ.01.1.02/0.0/0.0/15_018/0004478')

-- and p."Registrační číslo projektu" not IN ('CZ.01.1.02/0.0/0.0/15_019/0005057','CZ.01.1.02/0.0/0.0/15_019/0005057','CZ.01.1.02/0.0/0.0/15_018/0004373','CZ.01.1.02/0.0/0.0/15_019/0005057')


ORDER BY substr(p."Registrační číslo projektu",-5,5) ASC , h.poradi






----------------------------------------


REGISTRAČNÍ_ČÍSLO_PROJEKTU (CZ.01.1.02/0.0/0.0/15_018/0000727)
IČ (46900098)
KODWFSTAV (PP43)
WFSTAV (Projekt finálně uzavřen)
ČÍSLO_VÝZVY (01_15_018)
NÁZEV_VÝZVY (APLIKACE I. VÝZVA - BEZ ÚČINNÉ SPOLUPRÁCE)
PŘÍJEMCE (SPUR a.s.)
PLÁNOVANÉ_CELKOVÉ_ZPŮSOBILÉ_VÝDAJE (35390108)
PLÁNOVANÁ_DOTACE (14216206.38)
PROCENTO_DOTACE (40.17)
SKUTEČNĚ_PROPLACENÁ_DOTACE (14215226.8)
KÓD_CZ_NACE (72.19; 22.21; 22.29)
PORADI (7)
KÓD_HODNOTITELE (3366)
ARBITR (N)
OPRAVNÝ_HODNOTITEL (N)
DATUM_FINALIZACE (2016-09-14T15:15:54.000+02:00)
POČET_BODŮ (70)
RATINGHODNZNAMKA (5)
RATINGHODNPOPIS (Kvalitní posudek erudovaného hodnotitele.)
STAVPOSUDKU (Vyhověl)
BODŮ_V_KRITÉRIU_D1__MAX_18_ (18)
CZ_NACE (Ostatní výzkum a vývoj v oblasti příro
