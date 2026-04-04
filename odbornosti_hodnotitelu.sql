SELECT  
--	hodnotitel."Interní hodnotitel" as "Interní hodnotitel",
	uzivatel."EMAIL" as "EMAIL",
	uzivatel."MOBIL" as "MOBIL",
	uzivatel."USERNAME" as "USERNAME",
	uzivatel."UZIVATEL" as "UZIVATEL",
	cis."Název" AS Odbornost,
	hodnotitel.*
	
FROM isum.v_bi_UMVHodnotitelPrg hodn
INNER JOIN isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id = hodn.id_hodnotitel
INNER JOIN isum.v_bi_UmvHodnOdbornost odb ON odb.id_HodnotitelPrg = hodn.id
INNER JOIN isum.v_bi_UMSCisOdbornost cis ON cis.id = odb.id_odbornost
INNER JOIN isum.v_bi_CUzivatel uzivatel ON uzivatel.id = hodnotitel.id_cuzivatel

WHERE hodnotitel."Interní hodnotitel" ='N'
-- AND   cis."Název" like 'PO4%'
-- AND hodn.id = 1117038306
--  AND "V_BI_UMVHODNOTITEL"."SEZNAMPRGSCHV" like '%OP PIK%' 
AND  hodnotitel."Kód" in ('2392','7108','7142')


ORDER BY hodnotitel."Kód"




