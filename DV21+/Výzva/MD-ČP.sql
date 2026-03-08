-- CREATE or REPLACE view "RIS3_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 

WITH stav_statistiky AS (
    SELECT 
        hs.nositelid,
        COUNT(CASE WHEN pwf."Kód" = 'PP20' THEN 1 END) AS pocet_pp20,
        MAX(CASE WHEN pwf."Kód" = 'PP22' THEN 1 ELSE 0 END) AS byl_pp22,
        MAX(CASE WHEN pwf."Kód" IN ('PP30', 'PP31', 'PU30') THEN 1 ELSE 0 END) AS byl_pp30_plus,
        MAX(CASE WHEN pwf."Kód" LIKE 'PN%' THEN 1 ELSE 0 END) AS byl_negativni
    FROM historie_stavu hs
    INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
    GROUP BY hs.nositelid
)

SELECT SUBSTR(prg."Kód",5) "Kód Priority",
       op.kod,
	op.nazev as "Opatření" ,
	v."Název výzvy",
 	v."Číslo výzvy",
 	w."Název" "Název stavu výzvy",
	v."Datum zahájení příjmu žádostí o podporu",
       	v."Datum ukončení příjmu žádostí o podporu",
	listina_zp.datum "ČP Listina ZP na výzvě od",
	CASE WHEN listina_zp.datum > v."Datum zahájení příjmu žádostí o podporu" THEN 'Ano'
	     ELSE NULL END "ČP listina ZP přidáno dodatečně",
	cp_dnsh.datum "ČP DNSH na výzvě od",
	CASE WHEN cp_dnsh.datum > v."Datum zahájení příjmu žádostí o podporu" THEN 'Ano'
	     ELSE NULL END "ČP DNSH přidáno dodatečně" ,
	cp_zelena_legislativa.datum "ČP Zelená legislativa od",
	CASE WHEN cp_zelena_legislativa.datum > v."Datum zahájení příjmu žádostí o podporu" THEN 'Ano'
	     ELSE NULL END "ČP Zelená legislativa přidáno dodatečně" ,
	jurisdikce.datum "ČP Jurisdikce od",
	CASE WHEN jurisdikce.datum > v."Datum zahájení příjmu žádostí o podporu" THEN 'Ano'
	     ELSE NULL END "ČP Jurisdikce přidáno dodatečně",
 	stavy."Fáze FNaP (≤ 2x PP20)",
	stavy."Po FNaP, před RoPD",
	stavy."Realizace",
	stavy."Udržitelnost",
 	stavy."Fáze FNaP (≤ 2x PP20)" + stavy."Po FNaP, před RoPD" + stavy."Realizace" + stavy."Udržitelnost" AS "Celkem projektů v pozitivní stavu"
	
FROM vyzva v 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN ciselnik_stav_workflow w ON v.id_wfstav = w.id  
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN v_rav_umshisc sc on sc.id=op.id_hierarchie
INNER JOIN programova_linie prg ON prg.id = sc.id_osa
LEFT JOIN (SELECT md.id_vyzva,
     	  	  max(md."Datum změny") datum
     	   FROM vyzva_matricni_data md
	   INNER JOIN ciselnik_cestne_prohlaseni cp ON cp.id = md.id_ciszakladni
	   WHERE cp."Kód" = 'OPTAK_ŽoPo_11' /* Soulad s listinou základních práv */ 
	   AND md."Platný" = 'A'
	   AND md."Pro plnou žádost" = 'A'
	   GROUP BY md.id_vyzva) listina_zp ON listina_zp.id_vyzva = v.id
LEFT JOIN (SELECT md.id_vyzva,
     	  	  max(md."Datum změny") datum
     	   FROM vyzva_matricni_data md
	   INNER JOIN ciselnik_cestne_prohlaseni cp ON cp.id = md.id_ciszakladni
	   WHERE cp."Kód" IN ('OPTAK_ŽoPo_13', 'OPTAK_ŽoPo_13_Digi') /* Čestné prohlášení k "Formuláři posouzení DNSH" */
	   AND md."Platný" = 'A'
	   AND md."Pro plnou žádost" = 'A'
	   GROUP BY md.id_vyzva) cp_dnsh ON cp_dnsh.id_vyzva = v.id
LEFT JOIN (SELECT md.id_vyzva,
     	  	  max(md."Datum změny") datum
     	   FROM vyzva_matricni_data md
	   INNER JOIN ciselnik_cestne_prohlaseni cp ON cp.id = md.id_ciszakladni
	   WHERE cp."Kód" IN ('OPTAK_ŽoPo_14') /* Soulad s legislativou v oblasti ochrany životního prostředí */
	   AND md."Platný" = 'A'
	   AND md."Pro plnou žádost" = 'A'
	   GROUP BY md.id_vyzva) cp_zelena_legislativa ON cp_zelena_legislativa.id_vyzva = v.id
LEFT JOIN (SELECT md.id_vyzva,
     	  	  max(md."Datum změny") datum
     	   FROM vyzva_matricni_data md
	   INNER JOIN ciselnik_cestne_prohlaseni cp ON cp.id = md.id_ciszakladni
	   WHERE cp."Kód" IN ('OPTAK_ŽoPo_17') /* Jurisdikce nespolupracující v daňové oblasti */
	   AND md."Platný" = 'A'
	   AND md."Pro plnou žádost" = 'A'
	   GROUP BY md.id_vyzva) jurisdikce ON jurisdikce.id_vyzva = v.id
INNER JOIN (SELECT p.id_vyzva,
		   COUNT(CASE 
		       WHEN w."Kód" NOT LIKE 'PN%' 
		       AND ss.byl_negativni = 0
		       AND ss.byl_pp22 = 0 
		       AND ss.pocet_pp20 <= 2 
		       THEN 1 
		   END) AS "Fáze FNaP (≤ 2x PP20)",
		   COUNT(CASE 
		       WHEN w."Kód" NOT LIKE 'PN%' 
		       AND ss.byl_pp30_plus = 0 
		       AND ss.byl_pp22 = 1 
		       THEN 1 
		   END) AS "Po FNaP, před RoPD",
		   COUNT(CASE 
		       WHEN w."Kód" IN ('PP30', 'PP31', 'PP36', 'PU30') 
		       THEN 1 
		   END) AS "Realizace" ,
		   COUNT(CASE 
		       WHEN w."Kód" IN ('PP40', 'PP41', 'PP42', 'PP43') 
		       THEN 1 
		   END) AS "Udržitelnost"
		   FROM projekt p
		   INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
		   INNER JOIN stav_statistiky ss ON ss.nositelid = p.id
		   WHERE p."Registrační číslo projektu" is not null 
		   GROUP BY p.id_vyzva
	    	   ) stavy ON stavy.id_vyzva = v.id 
WHERE w."Název" <> 'Zrušená'
AND (v."Číslo výzvy" not like 'ITI%' and v."Číslo výzvy" not like 'CLLD%' )


ORDER BY op.kod ,v."Číslo výzvy" 



----------------------------------------

WITH stav_statistiky AS (
    SELECT 
        hs.nositelid,
        COUNT(CASE WHEN pwf."Kód" = 'PP20' THEN 1 END) AS pocet_pp20,
        MAX(CASE WHEN pwf."Kód" = 'PP22' THEN 1 ELSE 0 END) AS byl_pp22,
        MAX(CASE WHEN pwf."Kód" IN ('PP30', 'PP31', 'PU30') THEN 1 ELSE 0 END) AS byl_pp30_plus,
        MAX(CASE WHEN pwf."Kód" LIKE 'PN%' THEN 1 ELSE 0 END) AS byl_negativni
    FROM historie_stavu hs
    INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
    GROUP BY hs.nositelid
)

SELECT 
    COUNT(CASE 
        WHEN w."Kód" NOT LIKE 'PN%' 
        AND ss.byl_negativni = 0
        AND ss.byl_pp22 = 0 
        AND ss.pocet_pp20 <= 2 
        THEN 1 
    END) AS "a) Formální hodnocení (≤2x PP20)",
    
    COUNT(CASE 
        WHEN w."Kód" NOT LIKE 'PN%' 
        AND ss.byl_pp30_plus = 0 
        AND ss.byl_pp22 = 1 
        THEN 1 
    END) AS "Po FNaP, před RoPD",
    
    COUNT(CASE 
        WHEN w."Kód" IN ('PP40', 'PP41', 'PP42', 'PP43') 
        THEN 1 
    END) AS "Realizace (PP40-PP43)" ,

    COUNT(CASE 
        WHEN w."Kód" IN ('PP40', 'PP41', 'PP42', 'PP43') 
        THEN 1 
    END) AS "Udržitelnost (PP40-PP43)"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
INNER JOIN stav_statistiky ss ON ss.nositelid = p.id
WHERE -- p."Registrační číslo projektu" = 'CZ.01.01.01/01/22_002/0000539'
p."Registrační číslo projektu" is not null  
AND v."Číslo výzvy" = '01_22_002'



------------------------------
SELECT  SUBSTR(prg."Kód",5) "Kód Priority",
        op.kod,
	op.nazev as "Opatření" ,
	v."Název výzvy",
 	v."Číslo výzvy",
 	p."Registrační číslo projektu",
	p."Datum registrace žádosti",
	w."Kód" "Stav projektu",
	listina.ano "Souhlas s listinou ZP",
	cp_dnsh.ano "Souhlas s ČP k DNSH",
	cp_zelena_legislativa.ano "Souhlas se zelenou legislativou",
	jurisdikce.ano "Souhlas s Jurisdikcí"



FROM vyzva v 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN v_rav_umshisc sc on sc.id=op.id_hierarchie
INNER JOIN programova_linie prg ON prg.id = sc.id_osa
INNER JOIN projekt p ON p.id_vyzva = v.id
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id   
LEFT JOIN (SELECT cp."Souhlasím s čestným prohlášením" ano ,
     	  	  cp.id_noscestprohl
 	   FROM cestne_prohlaseni cp 
	   INNER JOIN ciselnik_cestne_prohlaseni ccp ON ccp.id = cp.id_cestprohlaseni
	   WHERE ccp."Kód" = 'OPTAK_ŽoPo_11'
	   ) listina ON listina.id_noscestprohl = p.id
LEFT JOIN (SELECT cp."Souhlasím s čestným prohlášením" ano ,
     	  	  cp.id_noscestprohl
 	   FROM cestne_prohlaseni cp 
	   INNER JOIN ciselnik_cestne_prohlaseni ccp ON ccp.id = cp.id_cestprohlaseni
	   WHERE ccp."Kód" =  ('OPTAK_ŽoPo_14') /* Soulad s legislativou v oblasti ochrany životního prostředí */
	   ) cp_zelena_legislativa ON cp_zelena_legislativa.id_noscestprohl = p.id
LEFT JOIN (SELECT cp."Souhlasím s čestným prohlášením" ano ,
     	  	  cp.id_noscestprohl
 	   FROM cestne_prohlaseni cp 
	   INNER JOIN ciselnik_cestne_prohlaseni ccp ON ccp.id = cp.id_cestprohlaseni
	   WHERE ccp."Kód" IN ('OPTAK_ŽoPo_13', 'OPTAK_ŽoPo_13_Digi') /* Čestné prohlášení k "Formuláři posouzení DNSH" */
	   ) cp_dnsh ON cp_dnsh.id_noscestprohl = p.id
LEFT JOIN (SELECT cp."Souhlasím s čestným prohlášením" ano ,
     	  	  cp.id_noscestprohl
 	   FROM cestne_prohlaseni cp 
	   INNER JOIN ciselnik_cestne_prohlaseni ccp ON ccp.id = cp.id_cestprohlaseni
	   WHERE ccp."Kód" = ('OPTAK_ŽoPo_17') /* Jurisdikce nespolupracující v daňové oblasti */
	   ) jurisdikce ON jurisdikce.id_noscestprohl = p.id

WHERE p."Registrační číslo projektu" = 'CZ.01.01.01/02/25_064/0006514'
p."Registrační číslo projektu" is not null
AND w."Kód" not like 'PN%'

ORDER BY op.kod, v."Číslo výzvy" , p."Datum registrace žádosti"
