-- CREATE or REPLACE view "tak-novak-doba-hodnoceni-aplikace" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Hodnoceni' AS 

SELECT CASE WHEN v."Èíslo výzvy" = '01_22_002' THEN 'Aplikace I'
            WHEN v."Èíslo výzvy" = '01_24_063' THEN 'Deep Tech'
       END "Výzva",
       p."Registraèní èíslo projektu",
       substr(p."Registraèní èíslo projektu",25) "Zkrácené èílso projektu" , 
       w."Kód" "Aktuální stav",
       pf."Pøíspìvek Unie" "Dotace",
       p."Datum registrace ¾ádosti",
       p."Datum zmìny stavu" "Datum aktuálního stavu", 

       ---- FNaP ----
       CASE WHEN w."Kód" IN ('PN20a','PN20b') AND pn20_fnap.id IS NOT NULL THEN p."Datum zmìny stavu" - p."Datum registrace ¾ádosti"
       	    ELSE fnap."Datum pøepnutí" - p."Datum registrace ¾ádosti"
       END "Dní ve FNaP",

       fnap."Datum pøepnutí" "Datum prvního pøepnutí po FNaP",
       
       vraceni.pocet "Poèet vrácení ve FNaP",

       CASE WHEN w."Kód" = 'PN22' OR pn20_fnap.id IS NOT NULL THEN 1
            ELSE 0
       END "Vyøazen ve FNaP",

       CASE WHEN pn20_vh.id IS NOT NULL THEN 1
	    ELSE 0
	    END "Odstoupil po FNaP pøed VH",

       ----- VH -----
       CASE WHEN w."Kód" IN ('PN20a','PN20b') AND pn20_vh.id IS NOT NULL THEN p."Datum zmìny stavu" - fnap."Datum pøepnutí"
       	    ELSE vh.datumvh  - fnap."Datum pøepnutí"
	    END "Dní ve VH",

       pk."Pøezkum proti hodnocení dní" ,
       
       vh.datumvh "Datum ukonèení VH",

       vh."Arbitr",
       vh."Opravný hodnotitel",


       ----- VK -----
       CASE WHEN w."Kód" IN ('PN20a','PN20b') AND pn20_vh.id IS NOT NULL THEN p."Datum zmìny stavu" - vh.datumvh
       	    ELSE vk."Datum pøepnutí" - vh.datumvh
	    END "Dní k pøípravì VK",

       vk."Datum pøepnutí" "Datum prvního pøepnutí po VK" ,

       CASE WHEN pn20_vk.id IS NOT NULL THEN 1
	    ELSE 0
	    END "Odstoupil po VH pøed VK",

       CASE WHEN pkvk.id_noshodnoceni IS NOT NULL THEN 1
       	    ELSE NULL
	    END "®oPø proti VK",

       CASE WHEN pkvk.id_noshodnoceni IS NOT NULL THEN  zoprvk."Datum pøepnutí" - vk."Datum pøepnutí"
       	    ELSE NULL
	    END "Dní mezi dvìma stavy P*25", 


       ---- RoPD -----
       CASE WHEN w."Kód" IN ('PN20a','PN20b') AND pn20_ropd.id IS NOT NULL THEN p."Datum zmìny stavu" - vk."Datum pøepnutí" 
            ELSE ropd."Datum pøepnutí" - vk."Datum pøepnutí" 
	    END "Dní od VK po vydání RoPD",

       CASE WHEN pn20_ropd.id IS NOT NULL THEN 1
       	    ELSE 0
	    END "Odstoupil po VK pøed RoPD",

       ropd."Datum pøepnutí" "Datum vydání RoPD"


FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005

LEFT JOIN (
     SELECT p.id,
            count(hs2.id) pocet
     FROM projekt p
     INNER JOIN historie_stavu hs2 ON hs2.nositelid = p.id
     INNER JOIN ciselnik_stav_workflow pwf_vraceni ON pwf_vraceni.id = hs2.id_stavdo
     WHERE pwf_vraceni."Kód" = 'PU22a'
     GROUP BY p.id
) vraceni ON vraceni.id = p.id

LEFT JOIN (
     SELECT p.id
     FROM projekt p
     WHERE p."Registraèní èíslo projektu" IS NOT NULL
     AND NOT EXISTS (
         SELECT 1
         FROM historie_stavu h2
         INNER JOIN ciselnik_stav_workflow pwf_fnap ON pwf_fnap.id = h2.id_stavdo
         WHERE pwf_fnap."Kód" IN ('PP22','PN22')
         AND h2.nositelid = p.id
     )
     -- AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000344'
) pn20_fnap ON pn20_fnap.id = p.id

LEFT JOIN (
     SELECT p.id,
     	    sum(CASE WHEN h."Arbitr" = 'A' THEN 1
	    	 ELSE 0
		 END) "Arbitr",
     	    sum(CASE WHEN h."Opravný posudek" = 'A' THEN 1
	    	 ELSE 0
		 END) "Opravný hodnotitel",
	    max(hsvh."Datum pøepnutí") datumvh
 		 
     FROM projekt p
     INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id
     INNER JOIN historie_stavu hsvh ON hsvh.nositelid = p.id 
     INNER JOIN ciselnik_stav_workflow pwf_vh ON pwf_vh.id = hsvh.id_stavdo     
     WHERE p."Registraèní èíslo projektu" IS NOT NULL
     AND h."Platný" = 'A'
     AND h."Finalizováno" = 'A'
     AND h."Schváleno schvalovatelem" = 'A'
     AND h.id_krokvechodn = 488854
     AND pwf_vh."Kód"  IN ('PP23a','PP23b','PN23')
     -- AND h."Arbitr" = 'N'
     -- AND h."Opravný posudek" = 'N'
     GROUP BY p.id 
     ) vh ON vh.id = p.id

LEFT JOIN (
     SELECT p.id
     FROM projekt p
     INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id   
     WHERE w."Kód" IN ('PN20a','PN20b')
     AND EXISTS (
         SELECT 1
         FROM historie_stavu h4
         INNER JOIN ciselnik_stav_workflow pwf_v ON pwf_v.id = h4.id_stavdo
         WHERE pwf_v."Kód" IN ('PP22','PN22')
         AND h4.nositelid = p.id
     	 )

     AND NOT EXISTS (
         SELECT 1
         FROM historie_stavu h5
         INNER JOIN ciselnik_stav_workflow pwf_v ON pwf_v.id = h5.id_stavdo
         WHERE pwf_v."Kód" IN ('PN23','PP23a','PP23b')
         AND h5.nositelid = p.id
     	 )
     ) pn20_vh ON pn20_vh.id = p.id


LEFT JOIN (
     SELECT p.id
     FROM projekt p
     INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id   
     WHERE w."Kód" IN ('PN20a','PN20b')
     AND EXISTS (
         SELECT 1
         FROM historie_stavu h5
         INNER JOIN ciselnik_stav_workflow pwf_1 ON pwf_1.id = h5.id_stavdo
         WHERE pwf_1."Kód" IN ('PN23','PP23a','PP23b')
         AND h5.nositelid = p.id
     	 )
     AND NOT EXISTS (
         SELECT 1
         FROM historie_stavu h4
         INNER JOIN ciselnik_stav_workflow pwf_2 ON pwf_2.id = h4.id_stavdo
         WHERE pwf_2."Kód" IN ('PP25a','PP25b','PN25','PU26')
         AND h4.nositelid = p.id
     	 )

     ) pn20_vk ON pn20_vk.id = p.id


LEFT JOIN (
     SELECT p.id,
            min(hs6."Datum pøepnutí") "Datum pøepnutí"
     FROM projekt p
     INNER JOIN historie_stavu hs6 ON hs6.nositelid = p.id
     INNER JOIN ciselnik_stav_workflow pwf_fn ON pwf_fn.id = hs6.id_stavdo
     WHERE pwf_fn."Kód" in ('PP22','PN22') 
     GROUP BY p.id
) fnap ON fnap.id = p.id

LEFT JOIN (
     SELECT p.id,
            min(hs7."Datum pøepnutí") "Datum pøepnutí" 
     FROM projekt p
     INNER JOIN historie_stavu hs7 ON hs7.nositelid = p.id
     INNER JOIN ciselnik_stav_workflow pwf_vk ON pwf_vk.id = hs7.id_stavdo
     WHERE pwf_vk."Kód" in ('PP25a','PP25b','PN25','PU26') 
     GROUP BY p.id
) vk ON vk.id = p.id

LEFT JOIN (
     SELECT p.id,
            max(hs8."Datum pøepnutí") "Datum pøepnutí" 
     FROM projekt p
     INNER JOIN historie_stavu hs8 ON hs8.nositelid = p.id
     INNER JOIN ciselnik_stav_workflow pwf_ropd ON pwf_ropd.id = hs8.id_stavdo
     WHERE pwf_ropd."Kód" in ('PP30') 
     GROUP BY p.id
) ropd ON ropd.id = p.id


LEFT JOIN (
     SELECT p.id
     FROM projekt p
     INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id   
     WHERE w."Kód" IN ('PN20a','PN20b')
     AND EXISTS (
         SELECT 1
         FROM historie_stavu h9
         INNER JOIN ciselnik_stav_workflow pwf_3 ON pwf_3.id = h9.id_stavdo
         WHERE pwf_3."Kód" in ('PP25a','PP25b','PN23','PU26','Z1','Z2','Z3') 
         AND h9.nositelid = p.id
     	 )
     ) pn20_ropd ON pn20_ropd.id = p.id

LEFT JOIN (
     SELECT n."Datum vypoøádání ¾ádosti o pøezkum rozhodnutí" - n."Datum podání ¾ádosti o pøezkum rozhodnutí" "Pøezkum proti hodnocení dní",
     	    n.id_noshodnoceni	    
     FROM namitka n
     WHERE n."Platný" = 'A'
     ) pk ON pk.id_noshodnoceni = p.id 

LEFT JOIN namitka_vyberova_komise pkvk ON pkvk.id_noshodnoceni = p.id AND pkvk."Platný" = 'A'

LEFT JOIN (SELECT hs.nositelid,
     	  	  -- hs."Poøadí",
		  max(hs."Datum pøepnutí") "Datum pøepnutí"
		  -- z."Kód" as "Ze stavu",
        	  -- do."Kód" as "Do stavu"

	   FROM historie_stavu hs
	   INNER JOIN ciselnik_stav_workflow  z on z.id = hs.id_stavz
	   INNER JOIN ciselnik_stav_workflow do on do.id = hs.id_stavdo     	   

	   WHERE z."Kód" IN ('PP25b','PN25','PU25')
	   AND do."Kód" IN ('PP25a','PP25b','PN25','PU25')
	   GROUP BY hs.nositelid
	   ) zoprvk ON zoprvk.nositelid = p.id

WHERE p."Registraèní èíslo projektu" IS NOT NULL
AND v."Èíslo výzvy" IN ('01_22_002','01_24_063')
-- AND p."Registraèní èíslo projektu" IN ('CZ.01.01.01/01/22_002/0000344', 'CZ.01.01.01/01/24_063/0006952')



