SELECT ak.nazev "Mana¾er projektu",
       SUBSTR(ut."Celá hierarchie", 1, INSTR(ut."Celá hierarchie", '/') - 1) "Organizace" ,
       ut."Název organizaèní jednotky" "Oddìlení",
       sum(platba."VYUCTPLAN#Vyúètování plán") "ZV ®oP celkem",
       count(platba.id) "Poèet ®oP",
       zou.pocet "Poèet ZoU"
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMZProjOdpovedn ak ON ak.ID_PRJGG = p.id AND ak.PLATNYUZIVATEL = 'A' AND ak.DATUMDO is null 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.V_BI_UMSZamestnanec z ON z.INTEGRACNI_KLIC = ak.username
INNER JOIN isum.v_bi_UMSOsobaUtvar os ON os.id_zamestnanec = z.id AND os.do is null 
INNER JOIN isum.V_BI_UMSOrgUtvar ut ON ut.id = os.ID_ORGUTVAR

LEFT JOIN (SELECT count(zou.id) pocet,
		  ak.nazev
	   FROM isum.v_bi_UmzProjekt p
	   INNER JOIN isum.v_bi_UMZProjOdpovedn ak ON ak.ID_PRJGG = p.id AND ak.PLATNYUZIVATEL = 'A' AND ak.DATUMDO is null 
	   INNER JOIN isum.v_bi_UMZZIProjekt zou ON zou.id_zad = p.id
	   INNER JOIN isum.v_bi_UMZCisTypZI c ON c.id = zou.id_cistypzi 

	   WHERE zou."Datum pøedlo¾ení" < to_date('2026-01-01','yyyy-mm-dd')
	   AND zou."Datum pøedlo¾ení" > to_date('2025-01-01','yyyy-mm-dd')
	   AND p.KodPrioritniOsa in ('31.3', '31.26')
	   AND c.hop IN ('ZoU','ZZoU')


	   GROUP BY ak.nazev
	   ) zou ON zou.nazev = ak.nazev




WHERE p.KodPrioritniOsa in ('31.3', '31.26')
-- AND p.kodwfstav not like 'PN%' OR p.kodwfstav not like 'PP4%')
-- AND p."Registraèní èíslo projektu" = 'CZ.31.3.0/0.0/0.0/22_001/0000006'
AND platba.kodwfstav not IN ('P5','P5T','P6','P6T','P10','P11')
AND platba."Datum pøedlo¾ení" < to_date('2026-01-01','yyyy-mm-dd')
AND platba."Datum pøedlo¾ení" > to_date('2025-01-01','yyyy-mm-dd')
AND ak.nazev = 'Vybíral Patrik, Bc.'
-- AND ak.nazev like 'Cahová%'

GROUP BY ak.nazev,
      	 zou.pocet ,
       	 SUBSTR(ut."Celá hierarchie", 1, INSTR(ut."Celá hierarchie", '/') - 1),
       	 ut."Název organizaèní jednotky" 
 
ORDER BY ak.nazev


----------------------------------------

SELECT ut."Celá hierarchie" ,
       ut.platnost,
       z.*
       -- 	ak.nazev,
       -- ut."Název organizaèní jednotky" "Oddìlení",
       -- SUBSTR(ut."Celá hierarchie", 1, INSTR(ut."Celá hierarchie", '/') - 1) "Organizace"
       FROM isum.v_bi_UmzProjekt p
	   INNER JOIN isum.v_bi_UMZProjOdpovedn ak ON ak.ID_PRJGG = p.id AND ak.PLATNYUZIVATEL = 'A' AND ak.DATUMDO is null 
	   INNER JOIN isum.V_BI_UMSZamestnanec z ON z.INTEGRACNI_KLIC = ak.username
	   INNER JOIN isum.v_bi_UMSOsobaUtvar os ON os.id_zamestnanec = z.id
	   INNER JOIN isum.V_BI_UMSOrgUtvar ut ON ut.id = os.ID_ORGUTVAR



	   AND p.KodPrioritniOsa in ('31.3', '31.26')
	   AND ak.nazev = 'Vybíral Patrik, Bc.'


----------------------------------------
SELECT *

FROM isum.V_BI_UMSZamestnanec
