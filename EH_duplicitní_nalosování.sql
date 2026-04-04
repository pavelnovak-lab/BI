SELECT DISTINCT	p."Registrační číslo projektu",
	nominaci.pocet ,
	c.uzivatel as uzivatel

FROM 		 isum.v_bi_umvhodnotitelkompprj h
INNER JOIN 	 isum.v_bi_UmzProjekt p on p.id=h.id_noshodnoceni
INNER JOIN	 isum.v_bi_umvhodnotitel hd on hd.id=h.id_hodnotitel
INNER JOIN	 isum.v_bi_cuzivatel c on c.id=hd.id_cuzivatel
INNER JOIN (SELECT count(hd.ciskod) AS pocet,
      	   	   p.id,
		   hd.id AS id_hodnotitel
            FROM isum.v_bi_umvhodnotitelkompprj h
	    INNER JOIN isum.v_bi_UmzProjekt p on p.id=h.id_noshodnoceni
	    INNER JOIN isum.v_bi_umvhodnotitel hd on hd.id=h.id_hodnotitel

	    WHERE hd."Externí hodnotitel" ='A'
	    AND h.id_krokvechodn = 171214
	    
	    GROUP BY p.id, hd.id ) nominaci ON nominaci.id = p.id AND nominaci.id_hodnotitel = hd.id

WHERE   hd."Externí hodnotitel" ='A'
-- AND p."Registrační číslo projektu" = 'CZ.01.1.02/0.0/0.0/20_321/0024517'
AND h.id_krokvechodn = 171214
AND h."Datum vyjádření" is null
AND nominaci.pocet > 1

ORDER BY nominaci.pocet DESC

-- -- Byl nanominovaný před 13. 2. 2021
-- AND   trunc(h."Datum odeslání žádosti")<to_date('2021-02-25','yyyy-mm-dd')

-- -- EH přijal nominace a hodnocení není finalizováno (datum vyjádření bylo před dnem losování) NEBO datum vyjádření je prázdné (EH se tedy jeětě nevyjádřil) 
-- AND (  (h."Nominace přijata" = 'A' and h.finalizovano <> 'A' )
--     OR h."Datum vyjádření" is null )
    
-- -- 12. února měl platnou nominaci na projektu, podkud ne, tak datum do nastavili na PO1, protože se nevyjádřil v termínu. Toto ale zřejmě algoritmus losování neprověřuje. 
-- -- AND trunc(h."Platnost do") > to_date('2021-02-11','yyyy-mm-dd')

-- -- Schválení hodnotitelé s odborností CZ-NACE 28
-- -- AND hd.ciskod in ('89', '6647', '343', '4351', '6521', '364', '75', '4343', '4409', '6558', '1681', '4371', '6619', '6579', '372', '4306', '4309', '4280', '2022', '4265', '4429', '1675', '4256', '6596', '4322', '4375', '6659', '4304', '77', '418', '6654')

-- -- Schválení hodnotitelé s odborností CZ-NACE 26
-- AND hd.ciskod in ('63', '343', '364', '6654', '6529', '4371', '4387', '372', '3195', '697', '483', '418', '1522', '6604', '4379', '4343')

-- GROUP BY hd.ciskod, c.uzivatel

-- ORDER BY "Počet nominací" asc 

