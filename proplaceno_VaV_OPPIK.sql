SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,

       sum(CASE WHEN (UPPER(TRANSLATE(pol."Název", 'žťůčýňíá', 'ztucynia')) like '%REZIJE%'
       	    	  OR
    		  UPPER(TRANSLATE(pol."Název", 'žťůčýňíá', 'ztucynia')) like '%REZIE%'
    		  OR
    		  UPPER(TRANSLATE(pol."Název", 'žťůčýňíá', 'ztucynia')) like '%REZIJNI%')
           THEN s.VYDAJESCHVAL * pzf.PROC_EU / 100 
           ELSE 0 END) "Paušály (NN)" ,

       sum(CASE WHEN (UPPER(TRANSLATE(pol."Název", 'žťůčýňíá', 'ztucynia')) like '%MATERIAL%')
	   THEN s.VYDAJESCHVAL * pzf.PROC_EU / 100 
	   ELSE 0 END) "Hmotný majetek a materiál - NINV",

       sum(CASE WHEN (UPPER(pol."Název") like '%MZDY%'
       		OR UPPER(pol."Název") like '%POJISTN%'
    		OR UPPER(pol."Název") like '%POJIŠT')
           THEN s.VYDAJESCHVAL * pzf.PROC_EU / 100 
           ELSE 0 END) "Osobní výdaje – NINV"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.V_BI_UMFSOUPISKADOKLADPRJ s ON s.id_platba = platba.id
INNER JOIN isum.V_BI_UMFROZPolozky pol ON pol.id = s.id_polozka
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 

WHERE platba.kodwfstav IN ('P10','P11')
-- AND platba."Číslo žádosti o platbu"  = 'CZ.01.1.02/0.0/0.0/21_374/0026305/2023/002/POST'
AND v."Číslo výzvy" IN ('01_15_007','01_15_018','01_15_019','01_16_053','01_16_056','01_16_079','01_16_083','01_16_084','01_17_103','01_17_106','01_17_107','01_17_125','01_17_147','01_17_166','01_17_173','01_17_174','01_17_175','01_17_176','01_18_212','01_19_262','01_19_263','01_19_274','01_19_275','01_20_321','01_20_336','01_21_374') -- výzvy z CEP (obsahuje i ty s dvoupoložkovým rozpočtem, ale ty vyloučí filtr na název položky 

GROUP BY SUBSTR(p.kompetencniutvar, 6)   



----------------------------------------
SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       sum(CASE WHEN (UPPER(TRANSLATE(s."Popis příjmu", 'žťůčýňíá', 'ztucynia')) like '%REZIJE%'
       	    	  OR
    		  UPPER(TRANSLATE(s."Popis příjmu", 'žťůčýňíá', 'ztucynia')) like '%REZIE%'
    		  OR
    		  UPPER(TRANSLATE(s."Popis příjmu", 'žťůčýňíá', 'ztucynia')) like '%REZIJNI%')
           THEN s.VYDAJESCHVAL * pzf.PROC_EU / 100 
           ELSE 0 END) "Paušály (NN)" ,


       sum(CASE WHEN (UPPER(TRANSLATE(s."Popis příjmu", 'žťůčýňíá', 'ztucynia')) like '%MATERIAL%')
	   THEN s.VYDAJESCHVAL * pzf.PROC_EU / 100 
	   ELSE 0 END) "Hmotný majetek a materiál - NINV",

       sum(CASE WHEN (UPPER(s."Popis příjmu") like '%MZDY%'
       		OR UPPER(s."Popis příjmu") like '%POJISTN%'
    		OR UPPER(s."Popis příjmu") like '%POJIŠT')
           THEN s.VYDAJESCHVAL * pzf.PROC_EU / 100 
           ELSE 0 END) "Osobní výdaje – NINV"

       -- pol."Název"
       -- platba."Číslo žádosti o platbu",
       -- platba.kodwfstav ,
       -- TRANSLATE(s."Popis příjmu", 'žťůčýňíá', 'ztucynia') "Popis"
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.V_BI_UMFSOUPISKADOKLADPRJ s ON s.id_platba = platba.id
-- INNER JOIN isum.V_BI_UMFROZPolozky pol ON pol.id = s.id_polozka
-- INNER JOIN isum.v_bi_UMPKorekce k ON k.id_platba = platba.id 
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav

WHERE v."Číslo výzvy" IN ('01_15_019','01_16_084','01_17_106','01_17_107','01_17_125','01_17_174','01_17_175','01_17_176','01_17_147','01_19_274','01_16_053','01_19_275','01_16_083','01_15_018','01_17_173','01_17_166') -- výzvy s rozpočtem CZV a NV
AND p.kodwfstav like ('PP4%')
AND platba.kodwfstav IN ('P10','P11')
-- AND platba."Číslo žádosti o platbu" = 'CZ.01.1.02/0.0/0.0/17_176/0015739/2021/002/POST'

GROUP BY SUBSTR(p.kompetencniutvar, 6) 


----------------------------------------
/* Výzvy s rozumným ropzpočtem rozpočtových položek */
SELECT DISTINCT   -- SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       -- s.VYDAJESCHVAL ,
       v."Název výzvy",
       v."Číslo výzvy" ,
       ci."Kód" kod_SR,
       ci."Název" nazev_SR ,
       pol."Kód" kod_pol,
       pol."Název" nazev_pol
       -- platba."Číslo žádosti o platbu",
       -- platba.kodwfstav ,
      -- sum(k.vyse)
FROM
-- isum.v_bi_UmzProjekt p
-- INNER JOIN
isum.v_bi_UmzVyzva v --ON v.id=p.id_vyzva
-- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
-- INNER JOIN isum.V_BI_UMFSOUPISKADOKLADPRJ s ON s.id_platba = platba.id
-- INNER JOIN isum.V_BI_UMFROZHlavicka rh ON rh
INNER JOIN isum.v_bi_UMZVyzvaMD md ON md.id_vyzva= v.id  AND md."Platnost" = 'A' AND md.id_cisseznam = 198427 AND (md."Pro předběžnou žádost" is null OR md."Pro předběžnou žádost" <> 'A')  -- skupina rozpočtu

INNER JOIN isum.v_bi_UMFROZSkupina sr ON sr.id = md.id_ciszakladni
INNER JOIN isum.V_BI_UMFROZHLAVICKA rh ON rh.id_skupina = sr.id
INNER JOIN isum.V_BI_UMFROZPOLOZKY pol ON pol.id_hlavicka = rh.id


-- INNER JOIN isum.V_BI_UMFROZPolozky pol ON pol.id = s.id_polozka
-- INNER JOIN isum.v_bi_UMPKorekce k ON k.id_platba = platba.id 

INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = md.id_ciszakladni


WHERE v."Číslo výzvy" IN ('01_15_007','01_16_056','01_16_079','01_17_103','01_18_212','01_19_262','01_19_263','01_20_321','01_20_336','01_21_374')



ORDER BY v."Číslo výzvy",
      	 ci."Kód"
      	  ,pol."Kód"
----------------------------------------
SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
       sum(rf.CASTKASCHVALENA "Částka schválená" ) "Proplacená dotace" 

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- řádky cis.


WHERE v."Číslo výzvy" IN ('01_15_007','01_15_018','01_15_019','01_16_053','01_16_056','01_16_079','01_16_083','01_16_084','01_17_103','01_17_106','01_17_107','01_17_125','01_17_147','01_17_166','01_17_173','01_17_174','01_17_175','01_17_176','01_18_212','01_19_262','01_19_263','01_19_274','01_19_275','01_20_321','01_20_336','01_21_374')
AND platba.kodwfstav in ('P10','P11')

GROUP BY SUBSTR(P.KOMPETENCNIUTVAR, 6) 




----------------------------------------
SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
       p.kodwfstav ,
       replace(replace(p."Registrační číslo projektu",CHR(10), ' --- '), Chr(13), ' --- ') AS "Registrační číslo projektu",
       replace(replace(p."Anotace projektu",CHR(10), ' --- '), Chr(13), ' --- ') AS "Anotace projektu",
       replace(replace(p."Jaký problém projekt řeší?",CHR(10), ' --- '), Chr(13), ' --- ') AS "Jaký problém projekt řeší?",
       replace(replace(p."Jaké jsou příčiny problému?",CHR(10), ' --- '), Chr(13), ' --- ') AS "Jaké jsou příčiny problému?",
       replace(replace(p."Co je cílem projektu?",CHR(10), ' --- '), Chr(13), ' --- ') AS "Co je cílem projektu?",
       replace(replace(p."Jaká změna/y je/jsou v důsledk",CHR(10), ' --- '), Chr(13), ' --- ') AS "Jaká změna/y je/jsou v důsledk",
       replace(replace(p."Jaké aktivity v projektu budou",CHR(10), ' --- '), Chr(13), ' --- ') AS "Jaké aktivity v projektu budou"
       

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
-- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
-- INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- řádky cis.


WHERE v."Číslo výzvy" IN ('01_15_007','01_15_018','01_15_019','01_16_053','01_16_056','01_16_079','01_16_083','01_16_084','01_17_103','01_17_106','01_17_107','01_17_125','01_17_147','01_17_166','01_17_173','01_17_174','01_17_175','01_17_176','01_18_212','01_19_262','01_19_263','01_19_274','01_19_275','01_20_321','01_20_336','01_21_374')
-- AND platba.kodwfstav in ('P10','P11')

ORDER BY substr(p."Registrační číslo projektu",-5,5) ASC 
