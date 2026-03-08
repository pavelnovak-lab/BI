CREATE or REPLACE view "RIS3_T3_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 

SELECT 
v."Èíslo výzvy", 
v."Název výzvy", 
p."Registraèní èíslo projektu", 
p."Název projektu CZ" AS "Název projektu", 
w.kod AS "Kód stavu", 
--s."Jméno a pøíjmení / Název",
s."Název subjektu", 
s."IÈ",

cts."Název" "Typ subjektu",
ciselnik_pravni_forma."Právní forma",

v_rav_umscisuzemnijednotky.kod as  "Kód územní jednotky",

va."Název kraj" AS "Název územní jednotky", 
v_rav_umscisuzemnijednotky.urovennazev as "Úroveò",
sum(vpo."Èástka poskytnuté veøejné podpory celkem v Kè") "CZV projektu celkem" ,
sum(vpo."Èástka poskytnuté veøejné podpory celkem - Pøíspìvek Unie v Kè") "Pøíspìvek EU",
null "Národní veøejné zdroje",
sum(vpo."Èástka poskytnuté veøejné podpory celkem v Kè") - sum(vpo."Èástka poskytnuté veøejné podpory celkem - Pøíspìvek Unie v Kè") "Národní soukromé zdroje",
 

-- pzf."Celkové zdroje pøipadající na zpùsobilé výdaje" AS "CZV projektu celkem", 
-- pzf."Pøíspìvek Unie" AS "Pøíspìvek EU", 
-- pzf."Národní veøejné zdroje", 
-- pzf."Národní soukromé zdroje" ,

vp."Velikost kategorie podniku" 



FROM vyzva AS v
INNER JOIN projekt AS p ON p.id_vyzva = v.id 
INNER JOIN v_rav_umscisstavwf AS w ON w.id = p.id_wfstav 
INNER JOIN programova_linie AS pl ON pl.id = v.id_program 
INNER JOIN projekt_specificky_cil AS psc ON psc.id_prjgg = p.id
INNER JOIN specificky_cil AS sc ON sc.id = psc.id_sc 
INNER JOIN prehled_zdroju_financovani AS pzf ON (pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005) 
INNER JOIN subjekt AS s ON (s.id_prjgg = p.id AND s.id_typsubjektuedit in (413462, 413467)) 
INNER JOIN ciselnik_typ_subjektu AS cts ON cts.id = s.id_typsubjektuedit  
INNER JOIN ciselnik_pravni_forma on s.id_hosppravforma=ciselnik_pravni_forma.id 
INNER JOIN verze_adresy AS va ON va.id = s.id_oficialniadresa
-- INNER JOIN projekt_ris3 AS pr ON pr.id_projekt = p.id  
INNER JOIN v_rav_umscisuzemnijednotky on va."Název kraj" = v_rav_umscisuzemnijednotky.nazev and urovennazev ='Kraj'
LEFT JOIN ciselnik_velikost_podniku vp ON vp.id = s.id_velikostpodniku
INNER JOIN verejna_podpora vpo ON vpo.id_nositel = s.id AND vpo.id_projekt = p.id

WHERE p."Registraèní èíslo projektu" is not null
AND (w.kod like ('PP3%') OR w.kod like ('PP4%') )
AND v."Výzva zamìøená na RIS3 strategie" = 'A'
AND p."Registraèní èíslo projektu" in ('CZ.01.01.01/01/22_002/0000082','CZ.01.01.01/01/22_002/0000303')



GROUP BY v."Èíslo výzvy", 
v."Název výzvy", 
p."Registraèní èíslo projektu", 
p."Název projektu CZ", 
w.kod , 
s."Název subjektu", 
s."IÈ",
"Typ subjektu",
ciselnik_pravni_forma."Právní forma",
"Kód územní jednotky",
"Název územní jednotky", 
v_rav_umscisuzemnijednotky.urovennazev ,
"Národní veøejné zdroje",
vp."Velikost kategorie podniku" 



ORDER BY "Èíslo výzvy", "Registraèní èíslo projektu", s."IÈ" asc 



----------------------------------------
SELECT 	v."Èíslo výzvy", 
	p."Registraèní èíslo projektu", 
	p."Název projektu CZ" AS "Název projektu", 
	-- w.kod AS "Kód stavu", 
	s."Název subjektu", 
	s."IÈ",

cts."Název" "Typ subjektu",
ciselnik_pravni_forma."Právní forma"




-- sum(vpo."Èástka poskytnuté veøejné podpory celkem v Kè") "CZV projektu celkem" ,
-- sum(vpo."Èástka poskytnuté veøejné podpory celkem - Pøíspìvek Unie v Kè") "Pøíspìvek EU",
-- null "Národní veøejné zdroje",
-- sum(vpo."Èástka poskytnuté veøejné podpory celkem v Kè") - sum(vpo."Èástka poskytnuté veøejné podpory celkem - Pøíspìvek Unie v Kè") "Národní soukromé zdroje


FROM vyzva AS v
INNER JOIN projekt AS p ON p.id_vyzva = v.id 
INNER JOIN subjekt AS s ON (s.id_prjgg = p.id AND s.id_typsubjektuedit in (413462, 413467)) 
INNER JOIN verejna_podpora vpo ON vpo.id_nositel = s.id AND vpo.id_projekt = p.id
INNER JOIN ciselnik_typ_subjektu AS cts ON cts.id = s.id_typsubjektuedit
INNER JOIN ciselnik_pravni_forma on s.id_hosppravforma=ciselnik_pravni_forma.id
INNER JOIN verze_adresy AS va ON va.id = s.id_oficialniadresa
-- INNER JOIN projekt_ris3 AS pr ON pr.id_projekt = p.id  
INNER JOIN v_rav_umscisuzemnijednotky on va."Název kraj" = v_rav_umscisuzemnijednotky.nazev and urovennazev ='Kraj'
INNER JOIN ciselnik_velikost_podniku vp ON vp.id = s.id_velikostpodniku

WHERE p."Registraèní èíslo projektu" is not null
AND v."Výzva zamìøená na RIS3 strategie" = 'A'
AND p."Registraèní èíslo projektu" in ('CZ.01.01.01/01/22_002/0000082','CZ.01.01.01/01/22_002/0000303')


ORDER BY "Èíslo výzvy", "Registraèní èíslo projektu", s."IÈ" asc
