SELECT	uzivatel,
	LISTAGG(substr(rcp,-5,5),'; ') AS "Hodnocené projekty",
        count(rcp) AS "Počet hodnocených projektů",
	sum(hodiny)
       
FROM
(SELECT substr(gg."Registrační číslo projektu",-5,5) as rcp,
	-- v."Číslo výzvy",
	-- v."Název výzvy",
--	hd.ciskod as KodH,
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
	gg."CZV" AS "Celkové způsobilé výdaje",
	case when czv < 10000000 then 9
	     when czv < 50000000 then 11
	     when czv < 100000000 then 13
	     else 15
	end as hodiny		 


  FROM 		 isum.v_bi_umvhodnotitelkompprj h
  INNER JOIN 	 isum.v_bi_umzprjgg gg ON gg.id=h.id_noshodnoceni
  -- INNER JOIN 	 isum.v_bi_umzvyzva v ON gg.id_vyzva=v.id
  INNER JOIN	 isum.v_bi_umvhodnotitel hd on hd.id=h.id_hodnotitel
  INNER JOIN	 isum.v_bi_cuzivatel c on c.id=hd.id_cuzivatel

  WHERE gg."Registrační číslo projektu" is not null
  AND   hd."Externí hodnotitel" ='A'
  AND   h."Datum odeslání žádosti" is not null
  --AND   c.username = 'FNSOUVLA'
  AND   h."Nominace přijata" = 'A'
  AND   h."Datum odeslání žádosti" > to_date('2021-01-01','yyyy-mm-dd')
)

GROUP BY uzivatel,jmh

ORDER BY substr(jmh,3,4)  ASC
