/* Kvùli pøehlednosti zaèínám pomocným view kriterium - vytahuje body v kritériích relevantních pro RIS3 za OPTAK. Garantni na¹ich výzev nedr¾í v modelech hodnocení ani stejný kód, ani stejné pojmenování. Tento DM tak bude tøeba pravidelnì aktualizovat a dr¾et seznam kritérií aktuální. :-( Ale bodová kritéria pro RIS3 mají jen OP TAK a OP JAK. Pro ostatní OP se dá toto CTE view ostranit.  */
WITH kriterium AS (
SELECT p.id id_projekt,
       h."Arbitr",
       AVG(k."Poèet bodù") "Poèet bodù"
FROM projekt p
/* Výzvu bych mohl joinovat jen zde, mám ji pak i mimo toto view, ale co u¾... */
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id
INNER JOIN hodnota_kriteria k ON k.id_hodnoceni = h.id 
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
AND p."Registraèní èíslo projektu" is not null 
AND h."Schváleno schvalovatelem" = 'A'
/* Následující podmínka je specifická pro OP TAK (podle èísla výzvy nahlí¾ím do kriteria pro RIS3), v OP TAK mù¾e a nebo nemusí VH být, pokud je, mù¾e mít jeden nebo dva kroky, proto to rozdìlení v id_krokvechodn */
AND (
    (h.id_krokvechodn = 488854 AND k."Kód" = 'B 7.' AND v."Èíslo výzvy" = '01_22_003') -- Inovace
    OR
    (h.id_krokvechodn = 488854 AND k."Kód" = 'B1.' AND v."Èíslo výzvy" IN ('01_22_001','01_22_002','01_22_005','01_23_12','01_23_13','01_23_014','01_23_035','01_23_36')) -- PoC, Aplikace, Klastry, PZT, 
    OR
    (h.id_krokvechodn = 488854 AND k."Kód" = 'B1' AND v."Èíslo výzvy" IN ('01_23_024','01_23_030','01_23_031','01_23_041')) -- Potenciál, SI
    OR -- 1. krok VH
    (h.id_krokvechodn = 488849 AND k."Kód" = 'B1.' AND v."Èíslo výzvy" IN ('01_23_010','01_23_11')) -- Technologické platformy, Klastry
   /* Bez VH jsou výzvy - Potenciál 01_22_004, 01_23_009, 01_23_015  */
   /* S VH ale bez bodovaného kritéria pro RIS3 jsou výzvy 01_23_016, 01_23_017, 01_23_021, 01_23_023, 01_23_027 */
   )
/* Následující podmínka odstraní duplicitní výpis projektu, kdy¾ rozhodoval arbitr a nezasahuje do tìch, kde nerozhodoval. Dùmyslnì tahám do GROUP BY h."Arbitr", tím zamezím prùmìru na v¹ech tøech posudcích (øádní hodnotitelé + arbitr)   */
AND  (a.id_noshodnoceni is null OR (a.id_noshodnoceni is not null AND h."Arbitr" = 'A')) 
GROUP BY  p.id , h."Arbitr"
)

SELECT DISTINCT pl."Kód" "Operaèní program (Kód)",
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

       /* Území - po konzultaci s kolegy z odd. RIS3 dotahuji z oficiální adresy ¾adatele/pøíjemce a to na úrovni kraje. Pøedpokládám, ¾e je unikátní. Naivnì. Dotahuje se validací subjektu v ISKP. Dá se ale na i ruènì pøiøadit duplicitní adresa. Míst realizace mù¾e být v OP PIK i víc ne¾ deset, proto radìji oficiální adresa. OP TAK podporuje jen MRR a PR a oficiální adresa subjeku mù¾e být i v Praze. Kolegové jsou s tím smíøeni. :-) */
       va."Název kraj" "Název územní jednotky",
       /* Asi bych umìl pøiøadit kód kraje podle subselectem s vyu¾itím v_rav_umscisuzemnijednotky, ale co u¾... */
       CASE WHEN va."Název kraj" = 'Hlavní mìsto Praha' THEN 'CZ010'
       	    WHEN va."Název kraj" = 'Støedoèeský kraj' THEN 'CZ020'
	    WHEN va."Název kraj" = 'Jihoèeský kraj' THEN 'CZ031'
	    WHEN va."Název kraj" = 'Plzeòský kraj' THEN 'CZ032'
	    WHEN va."Název kraj" = 'Karlovarský kraj' THEN 'CZ041'
	    WHEN va."Název kraj" = 'Ústecký kraj' THEN 'CZ042'
	    WHEN va."Název kraj" = 'Liberecký kraj' THEN 'CZ051'
	    WHEN va."Název kraj" = 'Královéhradecký kraj' THEN 'CZ052'
	    WHEN va."Název kraj" = 'Pardubický kraj' THEN 'CZ053'
	    WHEN va."Název kraj" = 'Kraj Vysoèina' THEN 'CZ063'
	    WHEN va."Název kraj" = 'Jihomoravský kraj' THEN 'CZ064'
	    WHEN va."Název kraj" = 'Olomoucký kraj' THEN 'CZ071'
	    WHEN va."Název kraj" = 'Zlínský kraj' THEN 'CZ072'
	    WHEN va."Název kraj" = 'Moravskoslezský kraj' THEN 'CZ080'
	ELSE NULL END "Kód územní jednotky",
       'Kraj' "Úroveò",

       pzf."Celkové zdroje pøipadající na zpùsobilé výdaje" "CZV projektu celkem",
       pzf."Pøíspìvek Unie" "Pøíspìvek EU",
       pzf."Národní veøejné zdroje",
       pzf."Soukromé zdroje" AS "Národní soukromé zdroje",

       s."Název subjektu",
       s."IÈ",
       cts."Název" "Typ subjektu",
       vp."Velikost kategorie podniku",
       
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
       dsk."Procento" "Krajské DS (Procento)",

       /* (Zatím) Nerevantní bodová kritéria pro OPTAK plním nulami a pøeji pøíjemnou závavu :-) */
       null "RIS3 VaVaI téma k DS (body)",
       null "RIS3 KET (body)",
       null "RIS3 témata VaVaI v SHUV (body)",
       null "RIS3 krajské DS (body)",
       null "RIS3 cíle mise (body)",
       /* Toto je z dùvodu, ¾e garantni výzev OP TAK slili dvì po¾adovaná kritéria pro RIS3 pod jediné */
       k."Poèet bodù" "Souètový pro OPTAK (VaVaI + KET)"


FROM projekt p
INNER JOIN v_rav_umscisstavwf w ON w.id = p.id_wfstav
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN programova_linie pl ON pl.id = v.id_program
INNER JOIN specificky_cil sc ON sc."Èíslo SC/opatøení ØO formát" = substr(p."Registraèní èíslo projektu",4,8)
INNER JOIN projekt_cznace pn ON pn.id_projekt = p.id
INNER JOIN ciselnik_cznace cn ON cn.id = pn.id_cznace
INNER JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462 -- omezení na ¾adatele/pøíjemce ostatní subjekty budou v jiné tabulce
INNER JOIN ciselnik_typ_subjektu cts ON s.id_typsubjektuedit = cts.id 
INNER JOIN verze_adresy va ON va.id = s.id_oficialniadresa
INNER JOIN ciselnik_velikost_podniku vp ON vp.id = s.id_velikostpodniku
INNER JOIN projekt_ris3 pr ON pr.id_projekt = p.id
/* Ve druhém ètení, kdy po sobì ètu kód mi ty následující podselecty moc smysl nedávají ... */
/* Následující inner join by mìly zajistit jen plnìní u projektù s vazbou na RIS3, platí, ¾e ka¾dý musí mít naplnìný specifický cíl RIS3. Neberu tedy check RIS3 z výzvy */
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
LEFT JOIN (
 SELECT kds."Kód" "Krajské DS (Kód)",    
	kds."Název" "Krajské DS (Název)",
	u."Název" "Krajské DS (Název územní jednotky)",
 	pr."Procento",
	pr.id_projekt
 FROM projekt_ris3 pr 
 INNER JOIN ciselnik_ris3_krajske_domeny_specializace kds ON pr.id_ris3 = kds.id
 INNER JOIN ciselnik_uzemni_jednotky u ON u.id = kds.id_uzemnijednotky) dsk ON dsk.id_projekt = p.id
/* Tady pøipojuji pomocné view kriterium bytvoøené v klauzuli WITH v záhlaví, jedostranný join, proto¾e v OPTAK máme i RIS3 výzvy bez VH */
LEFT JOIN kriterium k ON k.id_projekt = p.id

WHERE p."Registraèní èíslo projektu" is not null
AND w.kod NOT IN ('PP20','PN20a','PN20b','PP22','PU22','PN22','Z1','Z2','Z3','PU22a') -- jen PP30 a dál
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
       s."Název subjektu",
       s."IÈ",
       cts."Název",
       vp."Velikost kategorie podniku",

       "Název územní jednotky",
       "Kód územní jednotky",
       "Úroveò",

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
       dsk."Procento",

       "RIS3 VaVaI téma k DS (body)",
       "RIS3 KET (body)",
       "RIS3 témata VaVaI v SHUV (body)",
       "RIS3 krajské DS (body)",
       "RIS3 cíle mise (body)",
       "Souètový pro OPTAK (VaVaI + KET)"


ORDER BY v."Èíslo výzvy" , p."Registraèní èíslo projektu" , s."IÈ", sc."Specifický cíl RIS3 (Kód)", ds."Doména specializace (Kód)", vavai."VaVaI téma k DS (Kód)", ket."RIS3 KET (Kód)"
