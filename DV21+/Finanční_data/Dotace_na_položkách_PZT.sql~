SELECT op.nazev as "Opatření" ,
       -- p."Registrační číslo projektu" ,
       -- pf."Doporučený poměr financování (%)" ,
       -- sd."Schválené způsobilé výdaje" ,
       -- sd."Schválené způsobilé výdaje" * pf."Doporučený poměr financování (%)" /100 AS "Dotace" ,
       -- rp."Název"        

       sum(CASE WHEN UPPER(rp."Název") like '%REŽIJNÍ%'
           THEN sd."Schválené způsobilé výdaje" * pf."Doporučený poměr financování (%)" /100
           ELSE 0 END) "Paušály (NN)" ,

       sum(CASE WHEN UPPER(rp."Název") like '%MATERIÁL%'
	   THEN sd."Schválené způsobilé výdaje" * pf."Doporučený poměr financování (%)" /100
	   ELSE 0 END) "Hmotný majetek a materiál - NINV",

       sum(CASE WHEN (rp."Název" =  '%Stavební úpravy%' OR rp."Název" = 'Nákup staveb')

	   THEN sd."Schválené způsobilé výdaje" * pf."Doporučený poměr financování (%)" /100
	   ELSE 0 END) "Stavby - INV",


       sum(CASE WHEN UPPER(rp."Název") like 'OSOBNÍ NÁKLADY%'

           THEN sd."Schválené způsobilé výdaje" * pf."Doporučený poměr financování (%)" /100
           ELSE 0 END) "Osobní výdaje – NINV"




FROM projekt p 
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN ciselnik_stav_workflow wpl ON pl.id_wfstav = wpl.id   
INNER JOIN pomery_financovani pf ON pf.id_nositelpompf = p.id AND pf.id_zdrojfin = 415432 -- ERDF
INNER JOIN soupiska_doklad sd ON pl.id = sd.id_platba 
INNER JOIN rozpocet_polozka rp ON rp.id = sd.id_polozka

WHERE -- p."Registrační číslo projektu" = ('CZ.01.01.01/07/23_012/0001298','CZ.01.02.01/07/23_021/0002243')
-- AND
v."Číslo výzvy" IN ('01_23_011','01_23_012','01_23_013','01_23_021') -- bez PZT '01_23_014'
AND wpl."Kód" IN ('P10','P11')

GROUP BY op.nazev -- , p."Registrační číslo projektu" 






----------------------------------------
SELECT	v."Číslo výzvy" ,
	v."Název výzvy" ,
	spol."Kód" ,
	spol."Název" 


FROM vyzva v
INNER JOIN v_rav_umzvyzvamd AS md ON md.id_vyzva = v.id AND md.platnost = 'A' AND md.id_cisseznam = 278210  -- platná skupina rozpočtu 
INNER JOIN rozpocet_skupina_polozka spol ON spol.id_predpis = md.id_ciszakladni --  sr.id --  AND UPPER(spol."Název") like ('%PAUŠ%') OR UPPER(spol."Název") like ('%NEPŘÍM%')

WHERE v."Číslo výzvy" IN ('01_23_014','01_23_011','01_23_012','01_23_013','01_23_021')

ORDER BY v."Číslo výzvy" , spol."Kód" 


----------------------------------------

-- Na položce najdu míru podpdy , VPo je i přímo na soupisce dokladů

SELECT op.nazev as "Opatření" ,

       sum(CASE WHEN spol."Kód" REGEXP_LIKE '1\.1\.1\.[12]\.[2]'  -- 2 - osobní náklady, 3 - materiál, 5 - Ostatní režie, vše PV i EV [12], v úrovni bez *.X (partner X)
           THEN vpo."Částka poskytnuté veřejné podpory celkem - Příspěvek Unie v Kč" / vpo."Částka poskytnuté veřejné podpory celkem v Kč" * sd."Schválené způsobilé výdaje"
           ELSE 0 END) "Osobní výdaje – NINV" ,


       sum(CASE WHEN spol."Kód" REGEXP_LIKE '1\.1\.1\.[12]\.[5]'  -- 2 - osobní náklady, 3 - materiál, 5 - Ostatní režie, vše PV i EV [12], v úrovni bez *.X (partner X)
           THEN vpo."Částka poskytnuté veřejné podpory celkem - Příspěvek Unie v Kč" / vpo."Částka poskytnuté veřejné podpory celkem v Kč" * sd."Schválené způsobilé výdaje"
           ELSE 0 END) "Paušály (NN)" ,

       sum(CASE WHEN spol."Kód" REGEXP_LIKE '1\.1\.1\.[12]\.[3]'  -- 2 - osobní náklady, 3 - materiál, 5 - Ostatní režie, vše PV i EV [12], v úrovni bez *.X (partner X)
           THEN vpo."Částka poskytnuté veřejné podpory celkem - Příspěvek Unie v Kč" / vpo."Částka poskytnuté veřejné podpory celkem v Kč" * sd."Schválené způsobilé výdaje"
	   ELSE 0 END) "Hmotný majetek a materiál - NINV"




       -- p."Registrační číslo projektu" ,
       -- w."Kód" "Stav projektu" ,
       -- spol."Kód" ,
       -- spol."Název",
       -- vpo."Částka poskytnuté veřejné podpory celkem - Příspěvek Unie v Kč" / vpo."Částka poskytnuté veřejné podpory celkem v Kč" * 100 AS "Procento podpory",
       -- vpo."Částka poskytnuté veřejné podpory celkem - Příspěvek Unie v Kč" / vpo."Částka poskytnuté veřejné podpory celkem v Kč" * sd."Schválené způsobilé výdaje" AS "Dotace na soupisce",
       -- vpo.id_nositel,
       -- s."Název subjektu" ,
       -- sd."Schválené způsobilé výdaje" ,
       -- pl."Číslo platby"     ,
       -- wpl."Kód" "Kód platby" 



FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN v_rav_umzvyzvamd AS md ON md.id_vyzva = v.id AND md.platnost = 'A' AND md.id_cisseznam = 278210  
INNER JOIN rozpocet_skupina_polozka spol ON spol.id_predpis = md.id_ciszakladni --  sr.id --  AND UPPER(spol."Název") like ('%PAUŠ%') OR UPPER(spol."Název") like ('%NEPŘÍM%')
INNER JOIN ciselnik_kombinace_verejne_podpory kvpo ON kvpo.id = spol.id_verejnapodpora
INNER JOIN verejna_podpora vpo ON vpo.id_projekt = p.id AND vpo."Platnost" = 'A' AND vpo.id_verejnapodpora = kvpo.id  AND vpo."Částka poskytnuté veřejné podpory celkem v Kč" > 0
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  

INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN ciselnik_stav_workflow wpl ON pl.id_wfstav = wpl.id  
INNER JOIN soupiska_doklad sd ON pl.id = sd.id_platba AND sd.id_subjekt = vpo.id_nositel 
INNER JOIN rozpocet_polozka rp ON rp.id = sd.id_polozka AND spol."Kód" = substring(rp."Kód" , 0, len(rp."Kód") - 2) -- sparovani položek rozpočtu ze SR na výzvě a ze SD na ní bohužel není uvedena VPo, navíc pokud se rozpadá na partnery , pak odebírám poslední dva znaky (např. ".1")
INNER JOIN subjekt s ON s.id = sd.id_subjekt 



-- INNER JOIN ciselnik_stav_workflow w ON v.id_wfstav = w.id  
-- INNER JOIN projekt p ON p.id_vyzva = v.id
-- INNER JOIN pomery_financovani_hlavicka pfh ON pfh.id_nositelpompf = v.id
-- INNER JOIN pomery_financovani pf ON pf.id_hlavicka = pfh.id

WHERE v."Číslo výzvy" = '01_22_002'
-- AND p."Registrační číslo projektu" IN ( 'CZ.01.01.01/01/22_002/0000447')
-- AND spol."Kód" REGEXP_LIKE '1\.1\.1\.[12]\.[2]'  -- 2 - osobní náklady, 3 - materiál, 5 - Ostatní režie, vše PV i EV [12]
AND wpl."Kód" IN ('P10','P11')
-- AND p."Registrační číslo projektu" IN ( 'CZ.01.01.01/01/22_002/0000447', 'CZ.01.01.01/01/22_002/0000106')
-- AND spol."Kód" REGEXP_LIKE '1\.1\.1\.[12]\.[235]'  -- 2 - osobní náklady, 3 - materiál, 5 - Ostatní režie, vše PV i EV

GROUP BY op.nazev



----------------------------------------

-- CREATE VIEW "tak-novak-dotace-na-položce-rozpočtu-rozpad-na-partnery" FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/finanční_data' AS
SELECT v."Číslo výzvy",
       v."Název výzvy",
       p."Registrační číslo projektu",
       s."IČ",
       s."Název subjektu",
       w."Kód" AS "Kód stavu",
       pr."Kód",
       pr."Název",
       pr."Částka celkem"
FROM projekt AS p
INNER JOIN subjekt AS s ON (s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462)
INNER JOIN ciselnik_stav_workflow AS w ON p.id_wfstav = w.id
INNER JOIN vyzva AS v ON v.id = p.id_vyzva
INNER JOIN rozpocet_hlavicka AS hr ON hr.id_nrozpocet = p.id
INNER JOIN rozpocet_polozka AS pr ON pr.id_hlavicka = hr.id

WHERE (
              hr."Aktuální" = 'A'
              AND w."Kód" NOT LIKE 'PN%'
              AND p."Registrační číslo projektu" IS NOT NULL
              AND pr."Kód" = '1.1.1.5'
              AND v."Číslo výzvy" IN ('01_22_001', '01_22_005')
          )
    ORDER BY "Číslo výzvy" ASC,
             "Registrační číslo projektu" ASC;






