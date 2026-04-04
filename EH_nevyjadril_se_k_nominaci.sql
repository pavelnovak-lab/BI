SELECT	p."Registrační číslo projektu" as rcp,
--	p."Název projektu CZ" as np,
	v."Číslo výzvy",
	v."Název výzvy",
	hd.ciskod as KodH,
	c.username as jmh,
	c.uzivatel as uzivatel,
	h."Datum vyjádření",
	h."Lhůta vyjádření",
	h."Datum odeslání žádosti",
	h."Náhradník",
	h."Nominace přijata",
	h."Arbitr",
	h."Opravný hodnotitel",
	h."Řádný hodnotitel",
--	k."Název" as krok,
--	d."Název" as druh,
--	p."EU" AS "Požadovaná dotace",
	p."CZV" AS "Celkové způsobilé výdaje",
	case when czv < 10000000 then 9
	     when czv < 50000000 then 11
	     when czv < 100000000 then 13
	     else 15
	end as "Počet hodin"		 


FROM 		 isum.v_bi_umvhodnotitelkompprj h
INNER JOIN 	 isum.v_bi_umzprjgg p on p.id=h.id_noshodnoceni
-- INNER JOIN 	 isum.v_bi_umzprjgg gg ON gg.id=p.id
INNER JOIN 	 isum.v_bi_umzvyzva v ON p.id_vyzva=v.id
INNER JOIN	 isum.v_bi_umvhodnotitel hd on hd.id=h.id_hodnotitel
INNER JOIN	 isum.v_bi_cuzivatel c on c.id=hd.id_cuzivatel
-- INNER JOIN	 isum.v_bi_umsciszakladni k on k.id=h.id_krokvechodn
-- INNER JOIN	 isum.v_bi_umsciszakladni d on d.id=h.id_druhhodn
-- INNER JOIN	 isum.v_bi_UMVHodnotitelKomp komp ON komp

/* Beru pouze žádosti, u kterých běží lhůta na vyjádření a EH se nevyjádřil */

WHERE p."Registrační číslo projektu" is not null
-- AND   p.id_vyzva = '576949000' 
AND   hd."Externí hodnotitel" ='A'
AND   h."Datum odeslání žádosti" is not null
AND   trunc(h."Lhůta vyjádření") >= trunc(sysdate)
AND   h."Datum vyjádření" is null


-- AND trunc(sysdate) - trunc(h."Datum odeslání žádosti")<4

ORDER BY  substr(c.username,3,4)  ASC
