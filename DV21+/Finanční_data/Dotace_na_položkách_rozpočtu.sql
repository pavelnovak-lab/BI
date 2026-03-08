SELECT op.nazev as "Opatření" ,
	vpo."Částka poskytnuté veřejné podpory celkem - Příspěvek Unie v Kč" / vpo."Částka poskytnuté veřejné podpory celkem v Kč" * 100 AS "Procento podpory",
       (CASE WHEN rp."Kód" REGEXP_LIKE '1\.1\.1\.[12]\.[2]\.[1-9]'  -- 2 - osobní náklady, 3 - materiál, 5 - Ostatní režie, vše PV i EV
           THEN sd."Schválené způsobilé výdaje" --- * pzf.PROC_EU / 100 
           ELSE 0 END) "Osobní výdaje – NINV" ,

       rp."Kód" 

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN soupiska_doklad sd ON pl.id = sd.id_platba
INNER JOIN rozpocet_polozka rp ON rp.id = id_polozka

WHERE v."Číslo výzvy" IN ('01_22_002','01_23_027')
AND pl."Číslo platby" = 'CZ.01.01.01/01/22_002/0000447/2024/001/POST'
AND rp."Kód" REGEXP_LIKE '1\.1\.1\.[12]\.[2]\.[1]'  -- 2 - osobní náklady, 3 - materiál, 5 - Ostatní režie, vše PV i EV

GROUP BY "Opatření"

----------------------------------------

select	p."Registrační číslo projektu" ,

	vpo."Částka poskytnuté veřejné podpory celkem - Příspěvek Unie v Kč" / vpo."Částka poskytnuté veřejné podpory celkem v Kč" * 100 AS "Procento podpory",
	vpo.*


FROM projekt p
INNER JOIN verejna_podpora vpo ON vpo.id_projekt = p.id
-- INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462 -- žadatel 
-- INNER JOIN verejna_podpora_bonifikace vpob ON bpob.id_podpora = vpo.id 
-- INNER JOIN bonifikace b ON b.id = bpob.id_bonifikace

WHERE p."Registrační číslo projektu" = 'CZ.01.01.01/01/22_002/0000447'



('01_23_014','01_24_045','01_23_011','01_23_012','01_23_013','01_24_046','01_24_048','01_23_021')


('01_23_014','01_23_011','01_23_012','01_23_013','01_23_021')


----------------------------------------
SELECT -- v."Číslo výzvy" ,
       p."Registrační číslo projektu" ,
       pl."Číslo platby" ,
       rhc.id hlavicka_id,
       rpc.*

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id  
INNER JOIN rozpocet_hlavicka_cerpani rhc ON rhc.id_ncerpani = pl.id
INNER JOIN rozpocet_polozka_cerpani rpc ON rpc.id_hlavicka = rhc.id

WHERE v."Číslo výzvy" = '01_22_002' -- Aplikace I
AND w."Kód" IN ('P10','P11')
AND p."Registrační číslo projektu" IN ( 'CZ.01.01.01/01/22_002/0000447', 'CZ.01.01.01/01/22_002/0000106')

----------------------------------------
CREATE or REPLACE view "Položka rozpočtu na projektu" FOLDER= AS 
SELECT p."Registrační číslo projektu" ,
       w."Kód" "Kód stavu" ,
       max(CASE WHEN rp."Kód" = '1.1.2' THEN rp."Částka celkem"
       	    ELSE null END) "CZV - NEINV",
       max(CASE WHEN rp."Kód" = '1.1.2' THEN rp."Procento"
       	    ELSE null END) "Procento NEINV",
       max(CASE WHEN rp."Kód" = '1.1.1' THEN rp."Částka celkem"
       	    ELSE null END) "CZV - INV",
       max(CASE WHEN rp."Kód" = '1.1.1' THEN rp."Procento"
       	    ELSE null END) "Procento INV",
       min(CASE WHEN (rp."Kód" = '1.1.2' AND rp."Procento" = '100') THEN 'Ano'
       	    ELSE 'Ne'  END) "Všechny ZV NEINV"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN rozpocet_hlavicka rh ON rh.id_nrozpocet = p.id
INNER JOIN rozpocet_polozka rp ON rp.id_hlavicka = rh.id

WHERE v."Číslo výzvy" = '01_24_054' 
AND rh."Aktuální" = 'A'
AND p."Registrační číslo projektu" IN ( 'CZ.01.01.02/01/24_054/0006296','CZ.01.01.02/01/24_054/0004862')
AND w."Kód" not like 'PN%'

GROUP BY p."Registrační číslo projektu" ,
       	 w."Kód"
