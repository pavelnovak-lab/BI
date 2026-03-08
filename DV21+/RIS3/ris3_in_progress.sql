WITH -- V tomto view si pøipravuji rozpady CZV a EU podle VPo, v OP TAK se dotace rozpadá na ¾adatele a partnera s FP pouze v Aplikacích - proto ta natvrdo zadrátovaná podmínka ve WHERE. Taky dále pøedpokládám, ¾e na projektu je pøiøazený jediný SC.
vpo AS (SELECT p."Registraèní èíslo projektu" ,
       p.id "id_projekt",
       s.id "id_subjekt",
       sum(vpo.castkacelk_kc) "CZV",
       sum(vpo.castka_kc) "EU"
       
FROM projekt p
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit IN (413462, 413467)
INNER JOIN v_rav_umsrdmpodpora vpo ON vpo.id_projekt = p.id  AND vpo.id_nositel = s.id
INNER JOIN projekt_specificky_cil psc ON p.id=psc.id_prjgg
INNER JOIN specificky_cil sc ON psc.id_sc = sc.id


WHERE sc."Název specifického cíle/opatøení" = 'Aplikace'
-- AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000880'

GROUP BY p."Registraèní èíslo projektu" , s.id, p.id)

SELECT DISTINCT pl."Kód" "Operaèní program (Kód)",
       pl."Název" "Operaèní program (Název)",
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

       -- GROUP_CONCAT(DISTINCT uj."Kód") "Kód územní jednotky",
       -- GROUP_CONCAT(DISTINCT uj."Název") "Název územní jednotky",
       -- GROUP_CONCAT(DISTINCT uj."Název úrovnì") "Úroveò",

       kraj."Kód kraje" "Kód územní jednotky",
       kraj."Název kraje" "Název územní jednotky",
       'Kraj' AS "Úroveò",


       CASE WHEN sc2."Název specifického cíle/opatøení" = 'Aplikace' AND s.id = vpo.id_subjekt AND p.id = vpo.id_projekt THEN vpo."CZV"
       	    ELSE pzf."Celkové zdroje pøipadající na zpùsobilé výdaje"
	    END	AS "CZV projektu celkem",

       CASE WHEN sc2."Název specifického cíle/opatøení" = 'Aplikace' AND s.id = vpo.id_subjekt AND p.id = vpo.id_projekt THEN vpo."EU"
       	    ELSE pzf."Pøíspìvek Unie"
	    END	AS "Pøíspìvek EU",

       pzf."Národní veøejné zdroje",
       pzf."Národní soukromé zdroje",

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
       
       null "RIS3 VaVaI téma k DS (body)",
       null "RIS3 KET (body)",
       null "RIS3 témata VaVaI v SHUV (body)",
       null "RIS3 krajské DS (body)",
       null "RIS3 cíle mise (body)",
       apl."Body B1" "Souètový pro OPTAK (VaVaI + KET)"


FROM projekt p
INNER JOIN v_rav_umscisstavwf w ON w.id = p.id_wfstav
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN programova_linie pl ON pl.id = v.id_program
INNER JOIN specificky_cil sc ON sc."Èíslo SC/opatøení ØO formát" = substr(p."Registraèní èíslo projektu",4,8)
INNER JOIN projekt_cznace pn ON pn.id_projekt = p.id
INNER JOIN ciselnik_cznace cn ON cn.id = pn.id_cznace
-- INNER JOIN umisteni u ON p.id = u.id_projekt
-- INNER JOIN ciselnik_uzemni_jednotky uj ON uj.id = u.id_uzemnijednotky
INNER JOIN ciselnik_uzemi_kraje kraj ON kraj.id_projekt = p.id
INNER JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit IN (413462, 413467)
INNER JOIN ciselnik_typ_subjektu cts ON s.id_typsubjektuedit = cts.id 
INNER JOIN ciselnik_velikost_podniku vp ON vp.id = s.id_velikostpodniku

INNER JOIN projekt_specificky_cil psc ON p.id=psc.id_prjgg
INNER JOIN specificky_cil sc2 ON psc.id_sc = sc2.id
LEFT JOIN vpo ON vpo.id_projekt = p.id AND vpo.id_subjekt = s.id


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
LEFT JOIN (
 SELECT kds."Kód" "Krajské DS (Kód)",    
	kds."Název" "Krajské DS (Název)",
	u."Název" "Krajské DS (Název územní jednotky)",
 	pr."Procento",
	pr.id_projekt
 FROM projekt_ris3 pr 
 INNER JOIN ciselnik_ris3_krajske_domeny_specializace kds ON pr.id_ris3 = kds.id
 INNER JOIN ciselnik_uzemni_jednotky u ON u.id = kds.id_uzemnijednotky) dsk ON dsk.id_projekt = p.id
LEFT JOIN (
 SELECT avg(hk."Poèet bodù") "Body B1",
	h.id_noshodnoceni
 FROM projekt p
 INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id
 INNER JOIN hodnota_kriteria hk ON hk.id_hodnoceni = h.id 
 WHERE h."Platný" = 'A'
 AND h."Finalizováno" = 'A'
 AND h."Schváleno schvalovatelem" = 'A'
 --AND (v."Èíslo výzvy" = '01_22_002'
 AND ( (hk."Kód" = 'B1.' AND p.id_vyzva in (18990672, 18995356) ) OR -- vyzva 01_22_001, 01_22_002 Aplikace I, PoC
       (hk."Kód" = 'B 7.' AND p.id_vyzva = 19009827 ) ) -- vyzva 01_22_003 Inovace I
       
 AND h.id_krokvechodn = 488854 -- 2. krok VH
 GROUP BY h.id_noshodnoceni) apl ON apl.id_noshodnoceni = p.id -- AND p.id_vyzva = 18995356 


WHERE p."Registraèní èíslo projektu" in ('CZ.01.01.01/01/22_002/0000322','CZ.01.01.01/02/22_003/0000181','CZ.01.01.01/08/22_001/0000163')

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

       kraj."Kód kraje",
       kraj."Název kraje",
       "Úroveò",

       "CZV projektu celkem",
       "Pøíspìvek EU",       

       pzf."Národní veøejné zdroje",
       pzf."Národní soukromé zdroje",
       s."Název subjektu",
       s."IÈ",
       cts."Název",
       vp."Velikost kategorie podniku",

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



