SELECT
	count(p."Registrační číslo projektu") as "Počet nominací",
	listagg(p."Registrační číslo projektu", '; ') as Projekty ,	
	
	-- substr(p.KodPrioritniOsa,4,1) ,
	hd.ciskod as KodH,
	c.uzivatel as uzivatel
--	c.username as jmh,
	-- h."Datum vyjádření",
	-- h."Lhůta vyjádření",
	-- h."Datum odeslání žádosti",
	-- h."Náhradník",
	-- h."Platnost do",
	-- trunc(h."Platnost do") - trunc(h."Datum odeslání žádosti") as "Platnost nominace dní",
	-- trunc(h."Lhůta vyjádření") - trunc(h."Datum odeslání žádosti") as "Dní na vyjádření"

FROM 		 isum.v_bi_umvhodnotitelkompprj h
INNER JOIN 	 isum.v_bi_UmzProjekt p on p.id=h.id_noshodnoceni
INNER JOIN	 isum.v_bi_umvhodnotitel hd on hd.id=h.id_hodnotitel
INNER JOIN	 isum.v_bi_cuzivatel c on c.id=hd.id_cuzivatel


WHERE   hd."Externí hodnotitel" ='A'
-- p."Registrační číslo projektu" is not null


-- Byl nanominovaný před 13. 2. 2021
AND   trunc(h."Datum odeslání žádosti")<to_date('2021-02-13','yyyy-mm-dd')


-- Měl platnou nominaci na projektu
AND trunc(h."Platnost do") > to_date('2021-02-11','yyyy-mm-dd')

-- Datum vyjádření je prázdné nebo nominace přijata nebo se vyjádřil po 12. 2. 2021
AND   (h."Datum vyjádření" is null or trunc(h."Datum vyjádření")>to_date('2021-02-12','yyyy-mm-dd') or 	h."Nominace přijata" = 'A'  )

-- hodnotitel na CZ-NACE 28
AND hd.ciskod in ('89', '6647', '4351', '6521', '364', '75', '4343', '4409', '6558', '1681', '4281', '4371', '6619', '6579', '372', '4306', '4309', '4280', '2022', '4265', '4429', '1675', '4256', '6596', '4322', '4375', '4360', '4304', '77', '418')

GROUP BY hd.ciskod, c.uzivatel
