SELECT	p."Registrační číslo projektu" as rcp,
	substr(p.KodPrioritniOsa,4,1) ,
	hd.ciskod as KodH,
	c.username as jmh,
	c.uzivatel as uzivatel,
	h."Datum vyjádření",
	h."Lhůta vyjádření",
	h."Datum odeslání žádosti",
	h."Náhradník",
	h."Platnost do",
	trunc(h."Platnost do") - trunc(h."Datum odeslání žádosti") as "Platnost nominace dní",
	trunc(h."Lhůta vyjádření") - trunc(h."Datum odeslání žádosti") as "Dní na vyjádření"

FROM 		 isum.v_bi_umvhodnotitelkompprj h
INNER JOIN 	 isum.v_bi_UmzProjekt p on p.id=h.id_noshodnoceni
INNER JOIN	 isum.v_bi_umvhodnotitel hd on hd.id=h.id_hodnotitel
INNER JOIN	 isum.v_bi_cuzivatel c on c.id=hd.id_cuzivatel

/* Beru pouze žádosti, u kterých běží lhůta na vyjádření a EH se nevyjádřil */

WHERE p."Registrační číslo projektu" is not null
-- AND   p.id_vyzva = '576949000' 
AND   hd."Externí hodnotitel" ='A'
AND   h."Datum odeslání žádosti" is not null
-- AND     trunc(sysdate) - trunc(h."Lhůta vyjádření") 
AND   h."Datum vyjádření" is null
-- AND   h."Lhůta vyjádření" is null

AND trunc(sysdate) - trunc(h."Datum odeslání žádosti") > 7

ORDER BY  "Platnost nominace dní"
