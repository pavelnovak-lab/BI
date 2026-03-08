SELECT p."Registrační číslo projektu",
       pocetzp.*,
       z.*
       hs.*

FROM projekt p 
INNER JOIN zakazka_projekt zp ON zp.id_projekt = p.id -- AND zp."Platné přiřazení" = 'A'
INNER JOIN (SELECT count(id) pocet,
	           id_projekt
	    FROM zakazka_projekt
	    WHERE "Platné přiřazení" = 'A'
	    GROUP BY id_projekt) pocetzp ON pocetzp.id_projekt = p.id  
INNER JOIN zakazka z ON zp.id_vz = z.id
INNER JOIN zakazka_historie_stavu hs ON hs.id_vz = z.id 

WHERE p."Registrační číslo projektu" = 'CZ.01.04.01/01/22_006/0000318', 'CZ.01.04.01/01/22_006/0002314'
