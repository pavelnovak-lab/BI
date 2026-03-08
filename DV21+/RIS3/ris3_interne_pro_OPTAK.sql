WITH kriterium AS (
SELECT v."Číslo výzvy" ,
       v."Název výzvy" ,
       p.id id_projekt, 
       v.id id_vyzva,
       h.id id_hodnoceni,
       k.id id_kriterium,
       h."Arbitr",
       hdntl."Kód uživatele" "Kód hodnotitele",
       k."Kód",
       k."Počet bodů",
       k."Popis",
       st."Celkový výsledek - v bodech" "VH bodů projekt",
       cis."Název" "Status VH",
       h."Výsledek (v bodech)" "VH bodů posudek",
       CASE WHEN a.id_noshodnoceni is null THEN 'N'
       	    ELSE 'A' END AS "Rozhodoval arbitr"
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id
INNER JOIN hodnotitel hdntl ON hdntl.id = h.id_hodnotitel
INNER JOIN hodnota_kriteria k ON k.id_hodnoceni = h.id 
INNER JOIN hodnoceni_status st ON st.id_noshodnoceni = p.id AND (st.id_krokvechodn = 488854 OR (st.id_krokvechodn = 488849 AND v."Číslo výzvy" IN ('01_23_011')))
INNER JOIN ciselnik_status_hodnoceni cis on cis.id = st.id_statushodn
LEFT JOIN (
     SELECT h.id_noshodnoceni
     FROM hodnoceni h
     WHERE h."Platný" = 'A'
     AND h."Finalizováno" = 'A'
     AND h."Schváleno schvalovatelem" = 'A'
     AND h.id_krokvechodn = 488854 /* 2. krok VH */
     AND h."Arbitr" = 'A') a ON a.id_noshodnoceni = p.id

WHERE h."Platný" = 'A'
AND h."Finalizováno" = 'A'
AND h."Schváleno schvalovatelem" = 'A'
-- AND h.id_krokvechodn = 488854 /* 2. krok VH */
AND (
    (h.id_krokvechodn = 488854 AND k."Kód" = 'B 7.' AND v."Číslo výzvy" = '01_22_003')
    OR
    (h.id_krokvechodn = 488854 AND k."Kód" = 'B1.' AND v."Číslo výzvy" IN ('01_22_001', '01_22_002','01_22_005','01_23_014','01_23_012','01_23_013'))
    OR
    (h.id_krokvechodn = 488849 AND k."Kód" = 'B1.' AND v."Číslo výzvy" IN ('01_23_011'))
    )
),

WITH biris AS (
SELECT v."Číslo výzvy" ,
       v."Název výzvy" ,
       p.id id_projekt, 
       v.id id_vyzva,
       h.id id_hodnoceni,
       k.id id_kriterium,
       h."Arbitr",
       hdntl."Kód uživatele" "Kód hodnotitele",
       k."Kód",
       k."Počet bodů",
       k."Popis",
       st."Celkový výsledek - v bodech" "VH bodů projekt",
       cis."Název" "Status VH",
       h."Výsledek (v bodech)" "VH bodů posudek",
       CASE WHEN a.id_noshodnoceni is null THEN 'N'
       	    ELSE 'A' END AS "Rozhodoval arbitr"
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id
INNER JOIN hodnotitel hdntl ON hdntl.id = h.id_hodnotitel
INNER JOIN hodnota_kriteria k ON k.id_hodnoceni = h.id 
INNER JOIN hodnoceni_status st ON st.id_noshodnoceni = p.id AND (st.id_krokvechodn = 488854 OR (st.id_krokvechodn = 488849 AND v."Číslo výzvy" IN ('01_23_011')))
INNER JOIN ciselnik_status_hodnoceni cis on cis.id = st.id_statushodn
LEFT JOIN (
     SELECT h.id_noshodnoceni
     FROM hodnoceni h
     WHERE h."Platný" = 'A'
     AND h."Finalizováno" = 'A'
     AND h."Schváleno schvalovatelem" = 'A'
     AND h.id_krokvechodn = 488854 /* 2. krok VH */
     AND h."Arbitr" = 'A') a ON a.id_noshodnoceni = p.id

WHERE h."Platný" = 'A'
AND h."Finalizováno" = 'A'
AND h."Schváleno schvalovatelem" = 'A'
-- AND h.id_krokvechodn = 488854 /* 2. krok VH */
AND (
    (h.id_krokvechodn = 488854 AND k."Kód" = 'A 4.' AND v."Číslo výzvy" = '01_22_003')
    OR
    (h.id_krokvechodn = 488854 AND k."Kód" = 'A5.' AND v."Číslo výzvy" IN ('01_22_001','01_22_005','01_23_013'))
    OR
    (h.id_krokvechodn = 488854 AND k."Kód" = 'A3.' AND v."Číslo výzvy" IN ('01_22_002'))
    OR
    (h.id_krokvechodn = 488854 AND k."Kód" = 'A4.' AND v."Číslo výzvy" IN ('01_23_014', '01_23_012'))
    OR 
    (h.id_krokvechodn = 488849 AND k."Kód" = 'B1.' AND v."Číslo výzvy" IN ('01_23_011'))
    )
)






SELECT op.nazev AS "Opatření" ,
       k."Číslo výzvy" ,
       k."Název výzvy" ,
       p."Registrační číslo projektu" ,
       w.kod "Kód stavu",
       pzf."Příspěvek Unie" "Příspěvek EU",
       vp."Velikost kategorie podniku",

       k."Kód hodnotitele" ,
       k."Rozhodoval arbitr",
       k."VH bodů projekt",
       k."Status VH" "Celkový výsledek VH projekt",
       k."VH bodů posudek",

       CASE WHEN k."Rozhodoval arbitr" = 'A' AND k."Arbitr" = 'A' THEN k."Počet bodů"
	    WHEN k."Rozhodoval arbitr" = 'N' AND k."Arbitr" = 'N' THEN k."Počet bodů"
	    END AS "Bodů RIS3 (VaVaI + KET) - max 6 bodů",
       CASE WHEN k."Rozhodoval arbitr" = 'A' AND k."Arbitr" = 'A' THEN k."Popis"
	    WHEN k."Rozhodoval arbitr" = 'N' AND k."Arbitr" = 'N' THEN k."Popis"
	    END AS "Komentář" ,

       GROUP_CONCAT(DISTINCT  sc."Specifický cíl RIS3 (Kód)") "Specifický cíl RIS3 (Kód)",
       GROUP_CONCAT(DISTINCT  sc."Specifický cíl RIS3 (Název)") "Specifický cíl RIS3 (Název)",
       GROUP_CONCAT(DISTINCT  sc."Procento") "Specifický cíl RIS3 (Procento)",

       GROUP_CONCAT(DISTINCT  ds."Doména specializace (Kód)") "Doména specializace (Kód)",
       GROUP_CONCAT(DISTINCT  ds."Doména specializace (Název)") "Doména specializace (Název)",
       GROUP_CONCAT(DISTINCT  ds."Procento") "Doména specializace (Procento)",

       GROUP_CONCAT(DISTINCT  vavai."VaVaI téma k DS (Kód)" ) "VaVaI téma k DS (Kód)",    
       GROUP_CONCAT(DISTINCT  vavai."VaVaI téme k DS (Název)") "VaVaI téme k DS (Název)",

       GROUP_CONCAT(DISTINCT  ket."RIS3 KET (Kód)" ) "RIS3 KET (Kód)",    
       GROUP_CONCAT(DISTINCT  ket."RIS3 KET (Název)") "RIS3 KET (Název)",

       GROUP_CONCAT(DISTINCT  shuv."Témata VaVaI v SHUV (Kód)" ) "Témata VaVaI v SHUV (Kód)",    
       GROUP_CONCAT(DISTINCT  shuv."Témata VaVaI v SHUV (Název)") "Témata VaVaI v SHUV (Název)",

       GROUP_CONCAT(DISTINCT  cm."Cíle mise (Kód)") "Cíle mise (Kód)",    
       GROUP_CONCAT(DISTINCT  cm."Cíle mise (Název)") "Cíle mise (Název)",       
       GROUP_CONCAT(DISTINCT  cm."Procento" ) "Cíle mise (Procento)"



FROM projekt p
INNER JOIN kriterium k ON k.id_projekt = p.id
INNER JOIN v_rav_umscisstavwf w ON w.id = p.id_wfstav
INNER JOIN vyzva_hierarchie AS vh ON vh.id_vyzva = k.id_vyzva
INNER JOIN v_rav_umshisc AS op ON op.id = vh.id_speccil
INNER JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit IN (413462) -- zadatel, 413467)
INNER JOIN ciselnik_typ_subjektu cts ON s.id_typsubjektuedit = cts.id 
INNER JOIN ciselnik_velikost_podniku vp ON vp.id = s.id_velikostpodniku
INNER JOIN projekt_ris3 pr ON pr.id_projekt = p.id
INNER JOIN (
 SELECT rsc."Kód" "Specifický cíl RIS3 (Kód)",    
	rsc."Název" "Specifický cíl RIS3 (Název)",
	pr.id_projekt,
	pr."Procento"
 FROM projekt_ris3 pr -- ON pr.id_projekt = p.id
 INNER JOIN ciselnik_ris3_specificky_cil rsc ON pr.id_ris3 = rsc.id) sc ON sc.id_projekt = p.id
LEFT JOIN (
 SELECT rds."Kód" "Doména specializace (Kód)",    
	rds."Název" "Doména specializace (Název)",
	pr.id_projekt,
	pr."Procento"
 FROM projekt_ris3 pr 
 INNER JOIN ciselnik_ris3_domeny_specializace rds ON pr.id_ris3 = rds.id) ds ON ds.id_projekt = p.id
LEFT JOIN (
 SELECT vvi."Kód" "VaVaI téma k DS (Kód)",    
	vvi."Název" "VaVaI téme k DS (Název)",
	pr.id_projekt
 FROM projekt_ris3 pr 
 INNER JOIN ciselnik_ris3_vavai_tema_k_domene_specializace vvi ON pr.id_ris3 = vvi.id) vavai ON vavai.id_projekt = p.id
LEFT JOIN (
 SELECT k."Kód" "RIS3 KET (Kód)",    
	k."Název" "RIS3 KET (Název)",
	pr.id_projekt
 FROM projekt_ris3 pr 
 INNER JOIN ciselnik_ris3_ket k ON pr.id_ris3 = k.id) ket ON ket.id_projekt = p.id
LEFT JOIN (
 SELECT s."Kód" "Témata VaVaI v SHUV (Kód)",    
	s."Název" "Témata VaVaI v SHUV (Název)",
	pr.id_projekt
 FROM projekt_ris3 pr 
 INNER JOIN ciselnik_ris3_temata_vavai_v_oblasti_shuv s ON pr.id_ris3 = s.id) shuv ON shuv.id_projekt = p.id
LEFT JOIN (
 SELECT c."Kód" "Cíle mise (Kód)",    
	c."Název" "Cíle mise (Název)",
	pr.id_projekt,
	pr."Procento"
 FROM projekt_ris3 pr 
 INNER JOIN ciselnik_ris3_cile_mise c ON pr.id_ris3 = c.id) cm ON cm.id_projekt = p.id


WHERE
-- p."Registrační číslo projektu" in ('CZ.01.01.01/01/22_002/0000322','CZ.01.01.01/02/22_003/0000181','CZ.01.01.01/08/22_001/0000163','CZ.01.01.01/02/22_003/0000187','CZ.01.01.01/07/23_011/0001299')
-- AND
CASE WHEN k."Rozhodoval arbitr" = 'A' AND k."Arbitr" = 'A' THEN k."Počet bodů"
    	 WHEN k."Rozhodoval arbitr" = 'N' AND k."Arbitr" = 'N' THEN k."Počet bodů"
 	 END is not null

GROUP BY op.nazev  ,
       k."Číslo výzvy" ,
       k."Název výzvy" ,
       p."Registrační číslo projektu" ,
       w.kod ,
       pzf."Příspěvek Unie",
       vp."Velikost kategorie podniku",

       k."Kód hodnotitele" ,
       k."Rozhodoval arbitr",
       k."VH bodů projekt",
       k."Status VH" ,
       k."VH bodů posudek",

       CASE WHEN k."Rozhodoval arbitr" = 'A' AND k."Arbitr" = 'A' THEN k."Počet bodů"
	    WHEN k."Rozhodoval arbitr" = 'N' AND k."Arbitr" = 'N' THEN k."Počet bodů"
	    END ,
       CASE WHEN k."Rozhodoval arbitr" = 'A' AND k."Arbitr" = 'A' THEN k."Popis"
	    WHEN k."Rozhodoval arbitr" = 'N' AND k."Arbitr" = 'N' THEN k."Popis"
	    END 

ORDER BY p."Registrační číslo projektu" 



