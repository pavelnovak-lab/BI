CREATE or REPLACE view "RIS3_T1_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 

SELECT pl."Kód" "Operaèní program (Kód)",
       pl."Název" "Operaèní program (Název)",
       /* Myslet na více SC v jiných OP, v OP TAK platí, ¾e na projektu je v¾dy jediný SC. */
       sc."Èíslo SC/opatøení ØO formát" "Kód SC",
       sc."Název specifického cíle/opatøení" "Název SC",
       v."Èíslo výzvy",
       v."Název výzvy",
       p."Registraèní èíslo projektu",
       p."Název projektu CZ" "Název projektu",
       p."Anotace projektu CZ" "Anotace projektu",
       w.kod "Kód stavu",
       w.nazev "Název stavu",
       
       GROUP_CONCAT(DISTINCT cn."Kód") "Kód CZ NACE",
       GROUP_CONCAT(DISTINCT cn."Název") "Název CZ NACE",


       pzf."Celkové zdroje pøipadající na zpùsobilé výdaje" "CZV projektu celkem",
       pzf."Pøíspìvek Unie" "Pøíspìvek EU",
       pzf."Národní veøejné zdroje",
       pzf."Soukromé zdroje" AS "Národní soukromé zdroje",

       -- s."Název subjektu",
       -- s."IÈ",
       -- cts."Název" "Typ subjektu",
       -- vp."Velikost kategorie podniku",
       
       sc."Specifický cíl RIS3 (Kód)",
       sc."Specifický cíl RIS3 (Název)",
       sc."Procento" "Specifický cíl RIS3 (Procento)",

       ds."Doména specializace (Kód)",
       ds."Doména specializace (Název)",
       ds."Procento" "Doména specializace (Procento)",

       vavai."VaVaI téma k DS (Kód)",    
       vavai."VaVaI téme k DS (Název)",

       ket."RIS3 KET (Kód)",    
       ket."RIS3 KET (Název)",

       shuv."Témata VaVaI v SHUV (Kód)",    
       shuv."Témata VaVaI v SHUV (Název)",

       cm."Cíle mise (Kód)",    
       cm."Cíle mise (Název)",       
       cm."Procento" "Cíle mise (Procento)",

       dsk."Krajské DS (Kód)",   
       dsk."Krajské DS (Název)",
       dsk."Krajské DS (Název územní jednotky)",
       dsk."Procento" "Krajské DS (Procento)"

FROM projekt p
INNER JOIN v_rav_umscisstavwf w ON w.id = p.id_wfstav
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN programova_linie pl ON pl.id = v.id_program
INNER JOIN specificky_cil sc ON sc."Èíslo SC/opatøení ØO formát" = substr(p."Registraèní èíslo projektu",4,8)
INNER JOIN projekt_cznace pn ON pn.id_projekt = p.id
INNER JOIN ciselnik_cznace cn ON cn.id = pn.id_cznace
INNER JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005
LEFT JOIN  (SELECT pr.id_projekt
     	    FROM projekt_ris3 pr ON pr.id_projekt = p.id
	    INNER JOIN (
	     SELECT rsc."Kód" "Specifický cíl RIS3 (Kód)",    
		    rsc."Název" "Specifický cíl RIS3 (Název)",
		    pr.id_projekt,
		    pr."Procento"
	     FROM projekt_ris3 pr 
	     INNER JOIN ciselnik_ris3_specificky_cil rsc ON pr.id_ris3 = rsc.id) sc ON sc.id_projekt = p.id
	    LEFT JOIN (
	     SELECT rds."Kód" "Doména specializace (Kód)",    
		    rds."Název" "Doména specializace (Název)",
		    pr.id_projekt,
		    pr."Procento",
		    pr.id AS id_ds
	     FROM projekt_ris3 pr 
	     INNER JOIN ciselnik_ris3_domeny_specializace rds ON pr.id_ris3 = rds.id) ds ON ds.id_projekt = p.id
	    LEFT JOIN (
	     SELECT vvi."Kód" "VaVaI téma k DS (Kód)",    
		    vvi."Název" "VaVaI téme k DS (Název)",
		    pr.id_projekt,
		    pr.id_hierarchie
	     FROM projekt_ris3 pr 
	     INNER JOIN ciselnik_ris3_vavai_tema_k_domene_specializace vvi ON pr.id_ris3 = vvi.id) vavai ON vavai.id_projekt = p.id AND vavai.id_hierarchie = ds.id_ds
	    LEFT JOIN (
	     SELECT k."Kód" "RIS3 KET (Kód)",    
		    k."Název" "RIS3 KET (Název)",
		    pr.id_projekt,
		    pr.id_hierarchie
	     FROM projekt_ris3 pr 
	     INNER JOIN ciselnik_ris3_ket k ON pr.id_ris3 = k.id) ket ON ket.id_projekt = p.id AND ket.id_hierarchie = ds.id_ds
	    LEFT JOIN (
	     SELECT s."Kód" "Témata VaVaI v SHUV (Kód)",    
		    s."Název" "Témata VaVaI v SHUV (Název)",
		    pr.id_projekt,
		    pr.id_hierarchie
	     FROM projekt_ris3 pr 
	     INNER JOIN ciselnik_ris3_temata_vavai_v_oblasti_shuv s ON pr.id_ris3 = s.id) shuv ON shuv.id_projekt = p.id AND shuv.id_hierarchie = ds.id_ds
	    LEFT JOIN (
	     SELECT c."Kód" "Cíle mise (Kód)",    
		    c."Název" "Cíle mise (Název)",
		    pr.id_projekt,
		    pr."Procento"
	     FROM projekt_ris3 pr 
	     INNER JOIN ciselnik_ris3_cile_mise c ON pr.id_ris3 = c.id) cm ON cm.id_projekt = p.id
	    LEFT JOIN (
	     SELECT kds."Kód" "Krajské DS (Kód)",    
		    kds."Název" "Krajské DS (Název)",
		    u."Název" "Krajské DS (Název územní jednotky)",
		    pr."Procento",
		    pr.id_projekt
	     FROM projekt_ris3 pr 
	     INNER JOIN ciselnik_ris3_krajske_domeny_specializace kds ON pr.id_ris3 = kds.id
	     INNER JOIN ciselnik_uzemni_jednotky u ON u.id = kds.id_uzemnijednotky) dsk ON dsk.id_projekt = p.id

	     ) riska ON riska.id_projekt = p.id

/* Tady pøipojuji pomocné view kriterium bytvoøené v klauzuli WITH v záhlaví, jedostranný join, proto¾e v OPTAK máme i RIS3 výzvy bez VH */
-- LEFT JOIN kriterium k ON k.id_projekt = p.id

WHERE p."Registraèní èíslo projektu" is not null
-- Filtr na stavy po vydání Rozhodnutí, neobsahuje negativní stavy. 
AND w.kod in ('PP30','PP31','PP40','PP41','PP42','PP43','PU30') 
AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/07/23_013/0001301'
-- AND p."Registraèní èíslo projektu" in ('CZ.01.01.01/02/22_003/0000242', 'CZ.01.01.01/08/22_005/0000150','CZ.01.01.01/08/22_001/0000349','CZ.01.01.01/01/22_002/0000523','CZ.01.01.01/01/22_002/0000011','CZ.01.01.01/01/22_002/0000120')


GROUP BY "Operaèní program (Kód)",
       "Operaèní program (Název)",
       "Kód SC",
       sc."Název specifického cíle/opatøení",
       v."Èíslo výzvy",
       v."Název výzvy",
       p."Registraèní èíslo projektu",
       p."Název projektu CZ" ,
       "Anotace projektu",
       "Kód stavu",
       "Název stavu",
       -- "Procento SC RIS3",
       -- "Kód SC RIS3",
       -- "Název SC RIS3",

       pzf."Celkové zdroje pøipadající na zpùsobilé výdaje" ,
       pzf."Pøíspìvek Unie" ,
       pzf."Národní veøejné zdroje",
       pzf."Soukromé zdroje",  -- pzf."Národní soukromé zdroje",
       -- s."Název subjektu",
       -- s."IÈ",
       -- cts."Název",
       -- vp."Velikost kategorie podniku",

       -- "Název územní jednotky",
       -- "Kód územní jednotky",
       -- "Úroveò",

       sc."Specifický cíl RIS3 (Kód)",
       sc."Specifický cíl RIS3 (Název)",
       sc."Procento" ,

       ds."Doména specializace (Kód)",
       ds."Doména specializace (Název)",
       ds."Procento",

       vavai."VaVaI téma k DS (Kód)",    
       vavai."VaVaI téme k DS (Název)",

       ket."RIS3 KET (Kód)",    
       ket."RIS3 KET (Název)",

       shuv."Témata VaVaI v SHUV (Kód)",    
       shuv."Témata VaVaI v SHUV (Název)",
       
       cm."Cíle mise (Kód)",    
       cm."Cíle mise (Název)",       
       cm."Procento", 

       dsk."Krajské DS (Kód)",   
       dsk."Krajské DS (Název)",
       dsk."Krajské DS (Název územní jednotky)",
       dsk."Procento"

       -- "RIS3 VaVaI téma k DS (body)",
       -- "RIS3 KET (body)",
       -- "RIS3 témata VaVaI v SHUV (body)",
       -- "RIS3 krajské DS (body)",
       -- "RIS3 cíle mise (body)"
       -- -- "Souètový pro OPTAK (VaVaI + KET)"


ORDER BY v."Èíslo výzvy" , p."Registraèní èíslo projektu" ,  sc."Specifický cíl RIS3 (Kód)", ds."Doména specializace (Kód)", vavai."VaVaI téma k DS (Kód)", ket."RIS3 KET (Kód)"
