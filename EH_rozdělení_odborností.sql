SELECT 	count(hodnotitel."Kód") as "Počet hodnotitelů",
--	hodnotitel."SEZNAMPRGSCHV" as "SEZNAMPRGSCHV",
--	hodnotitel."Interní hodnotitel" as "Interní hodnotitel",

	
	-- uzivatel."EMAIL" as "EMAIL",
	-- uzivatel."MOBIL" as "MOBIL",
--	uzivatel."USERNAME" as "USERNAME",
--	uzivatel."UZIVATEL" as "UZIVATEL",
	listagg(hodnotitel."Kód", '; ') as "Číslo hodnotitele",
	cis."Název" AS Odbornost

FROM isum.v_bi_UMVHodnotitelPrg hodn
INNER JOIN isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id = hodn.id_hodnotitel
INNER JOIN isum.v_bi_UmvHodnOdbornost odb ON odb.id_HodnotitelPrg = hodn.id
INNER JOIN isum.v_bi_UMSCisOdbornost cis ON cis.id = odb.id_odbornost
-- INNER JOIN isum.v_bi_CUzivatel uzivatel ON uzivatel.id = hodnotitel.id_cuzivatel

WHERE hodnotitel."Interní hodnotitel" ='N'
AND   cis."Název" like 'CZ-NACE%'
AND hodn.id_priznakhodn = 198854

/* hodn.id_priznakhodn je takto:
   |      id | Stav                                 |
   |---------+--------------------------------------|
   |  198854 | Schválen                             |
   |  198857 | Činnost pozastavena                  |
   | 9172284 | Čekající na schválení po aktualizaci |
*/ 

GROUP BY cis."Název"

ORDER BY "Počet hodnotitelů"
