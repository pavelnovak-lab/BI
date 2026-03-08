SELECT min(CASE WHEN neinv.urovenneinv = srp."Úroveň" AND srp."Investice / Neinvestice" = 0 THEN srp."Název"
       	    END) AS "CZV NEINV Název",
       min(CASE    WHEN inv.uroveninv = srp."Úroveň" AND srp."Investice / Neinvestice" = 1 THEN srp."Název"
	    ELSE NULL END) AS "CZV INV Název"

FROM rozpocet_skupina sr 
JOIN (SELECT min("Úroveň") urovenneinv,
     	     id_predpis
      FROM rozpocet_skupina_polozka
      WHERE "Investice / Neinvestice" = 0
      GROUP BY id_predpis) neinv ON neinv.id_predpis = sr.id 
JOIN (SELECT min("Úroveň") uroveninv,
     	     id_predpis
      FROM rozpocet_skupina_polozka 
      WHERE "Investice / Neinvestice" = 1
      GROUP BY id_predpis) inv ON inv.id_predpis = sr.id 
JOIN rozpocet_skupina_polozka srp ON srp.id_predpis = sr.id


WHERE sr.id = 264655744
