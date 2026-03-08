SELECT	p."Registraèní èíslo projektu" as rcp,
--	p."Název projektu CZ" as np,
	v."Èíslo výzvy",
	v."Název výzvy",
	hd.ciskod as KodH,
	c.username as jmh,
	c.uzivatel as uzivatel,
	h."Datum vyjádøení",
	h."Lhùta vyjádøení",
	h."Datum odeslání ¾ádosti",
	h."Náhradník",
	h."Nominace pøijata",
	h."Arbitr",
	h."Opravný hodnotitel",
	h."Øádný hodnotitel",
--	k."Název" as krok,
--	d."Název" as druh,
--	p."EU" AS "Po¾adovaná dotace",
	p."CZV" AS "Celkové zpùsobilé výdaje",
	case when czv < 10000000 then 9
	     when czv < 50000000 then 11
	     when czv < 100000000 then 13
	     else 15
	end as "Poèet hodin"		 


FROM 		 isum.v_bi_umvhodnotitelkompprj h
INNER JOIN 	 isum.v_bi_umzprjgg p on p.id=h.id_noshodnoceni
-- INNER JOIN 	 isum.v_bi_umzprjgg gg ON gg.id=p.id
INNER JOIN 	 isum.v_bi_umzvyzva v ON p.id_vyzva=v.id
INNER JOIN	 isum.v_bi_umvhodnotitel hd on hd.id=h.id_hodnotitel
INNER JOIN	 isum.v_bi_cuzivatel c on c.id=hd.id_cuzivatel
-- INNER JOIN	 isum.v_bi_umsciszakladni k on k.id=h.id_krokvechodn
-- INNER JOIN	 isum.v_bi_umsciszakladni d on d.id=h.id_druhhodn
-- INNER JOIN	 isum.v_bi_UMVHodnotitelKomp komp ON komp

/* Beru pouze ¾ádosti, u kterých bì¾í lhùta na vyjádøení a EH se nevyjádøil */

WHERE p."Registraèní èíslo projektu" is not null
-- AND   p.id_vyzva = '576949000' 
AND   hd."Externí hodnotitel" ='A'
-- AND   h."Datum odeslání ¾ádosti" is not null
-- AND   trunc(h."Lhùta vyjádøení") >= trunc(sysdate)
-- AND   h."Datum vyjádøení" is null
AND   h."Datum odeslání ¾ádosti" > to_date('2021-01-01','yyyy-mm-dd')

-- AND trunc(sysdate) - trunc(h."Datum odeslání ¾ádosti")<4

ORDER BY  substr(c.username,3,4)  ASC
