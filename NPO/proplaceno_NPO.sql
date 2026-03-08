SELECT SUBSTR(ci."Kód" , 1, 4 ) || SUBSTR(ci."Kód" , 7, 1 ) AS "2.3.1 / 2.3.2" ,
	ci."Kód" "ID M/T",
       p."Registraèní èíslo projektu" ,
       p."Název projektu CZ" "Název operace",
       hs.datumod "Datum vydání právního aktu",
       pzf."Pøíspìvek Unie" "Celková po¾adovaná podpora v Kè (dle právního aktu)",
       sum(rf.CASTKASCHVALENA)  "Proplacená podpora - skuteènì po¾adovaná èástka z RRF v Kè" ,
       sum(CASE WHEN ( TRUNC(platba."Datum zmìny stavu") >=  to_date('2021-01-31','yyyy-mm-dd')
		       AND
		       TRUNC(platba."Datum zmìny stavu") <=  to_date('2021-12-31','yyyy-mm-dd')
		      )
            	THEN rf.CASTKASCHVALENA 
	    	END) "2021" ,
       sum(CASE WHEN ( TRUNC(platba."Datum zmìny stavu") >=  to_date('2022-01-31','yyyy-mm-dd')
		       AND
		       TRUNC(platba."Datum zmìny stavu") <=  to_date('2022-12-31','yyyy-mm-dd')
		      )
            	THEN rf.CASTKASCHVALENA 
	    	END) "2022",
       sum(CASE WHEN ( TRUNC(platba."Datum zmìny stavu") >=  to_date('2023-01-31','yyyy-mm-dd')
		       AND
		       TRUNC(platba."Datum zmìny stavu") <=  to_date('2023-12-31','yyyy-mm-dd')
		      )
            	THEN rf.CASTKASCHVALENA 
	    	END) "2023",
       sum(CASE WHEN ( TRUNC(platba."Datum zmìny stavu") >=  to_date('2024-01-31','yyyy-mm-dd')
		       AND
		       TRUNC(platba."Datum zmìny stavu") <=  to_date('2024-12-31','yyyy-mm-dd')
		      )
            	THEN rf.CASTKASCHVALENA 
	    	END) "2024",
	0 "Podpora z jiných zdrojù EU v Kè",
	null "Celková vý¹e veøejného financování v Kè",
	p.zadatel "Koneèný pøíjemce - název" ,
	CASE WHEN p."IÈ" IS NULL THEN vs."RÈ"
	     ELSE p."IÈ" END "Koneèný pøíjemce - IÈO" ,
	platba."Datum zmìny stavu"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND hs.stavdo = 'PP30'
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel 
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = p.id_micil
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.kodwfstav in ('P10','P11') 
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- øádky cis.


WHERE -- p."Registraèní èíslo projektu"  IN ('CZ.31.3.0/0.0/0.0/22_001/0000004','CZ.31.3.0/0.0/0.0/22_006/0004795')
v."Èíslo výzvy" IN ('31_22_001','31_22_005','31_22_006')
-- AND p."Registraèní èíslo projektu" = 'CZ.31.3.0/0.0/0.0/22_001/0003145'

GROUP BY SUBSTR(ci."Kód" , 1, 4 ) || SUBSTR(ci."Kód" , 7, 1 ),
       ci."Kód",
       p."Registraèní èíslo projektu" ,
       p."Název projektu CZ",
       hs.datumod,
       pzf."Pøíspìvek Unie",
       -- platba."Datum zmìny stavu"
	-- 0 "Podpora z jiných zdrojù EU v Kè",
	-- null "Celková vý¹e veøejného financování v Kè"
	p.zadatel ,
	CASE WHEN p."IÈ" is null then vs."RÈ"
	     ELSE p."IÈ" END,
	platba."Datum zmìny stavu"
