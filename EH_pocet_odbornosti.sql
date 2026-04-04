SELECT
	hodnotitel."Kód" as "Kód",
	uzivatel."USERNAME" as "USERNAME",
	uzivatel."UZIVATEL" as "UZIVATEL",
 	po1."Počet PO1",
 	po2."Počet PO2",
	po3."Počet PO3",   	
	po4."Počet PO4"
	
FROM isum.v_bi_UMVHodnotitelPrg hodn
INNER JOIN isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id = hodn.id_hodnotitel
INNER JOIN isum.v_bi_CUzivatel uzivatel ON uzivatel.id = hodnotitel.id_cuzivatel

LEFT JOIN (
  SELECT odb.id_HodnotitelPrg,
  	count(cis.id) AS "Počet PO1"
  FROM isum.v_bi_UmvHodnOdbornost odb
  INNER JOIN isum.v_bi_UMSCisOdbornost cis ON cis.id = odb.id_odbornost
  WHERE cis."Název" like 'CZ-NACE%'
  AND odb.id_HodnotitelPrg is not null
  GROUP BY odb.id_HodnotitelPrg ) po1 ON po1.id_HodnotitelPrg = hodn.id

LEFT JOIN (
  SELECT odb.id_HodnotitelPrg,
	count(cis.id) AS "Počet PO2"
  FROM isum.v_bi_UmvHodnOdbornost odb
  INNER JOIN isum.v_bi_UMSCisOdbornost cis ON cis.id = odb.id_odbornost
  WHERE cis."Název" like 'PO2%'
  AND odb.id_HodnotitelPrg is not null
  GROUP BY odb.id_HodnotitelPrg ) po2 ON po2.id_HodnotitelPrg = hodn.id


LEFT JOIN (
  SELECT odb.id_HodnotitelPrg,
	count(cis.id) AS "Počet PO3"
  FROM isum.v_bi_UmvHodnOdbornost odb
  INNER JOIN isum.v_bi_UMSCisOdbornost cis ON cis.id = odb.id_odbornost
  WHERE cis."Název" like 'PO3%'
  AND odb.id_HodnotitelPrg is not null
  GROUP BY odb.id_HodnotitelPrg ) po3 ON po3.id_HodnotitelPrg = hodn.id


LEFT JOIN (
  SELECT odb.id_HodnotitelPrg,
	count(cis.id) AS "Počet PO4"
  FROM isum.v_bi_UmvHodnOdbornost odb
  INNER JOIN isum.v_bi_UMSCisOdbornost cis ON cis.id = odb.id_odbornost
  WHERE cis."Název" like 'PO4%'
  AND odb.id_HodnotitelPrg is not null
  GROUP BY odb.id_HodnotitelPrg ) po4 ON po4.id_HodnotitelPrg = hodn.id



WHERE hodnotitel."Interní hodnotitel" ='N'
-- AND "V_BI_UMVHODNOTITEL"."SEZNAMPRGSCHV" like '%OP PIK%'
-- AND hodnotitel."Kód" = '7100'

AND ( ( po1."Počet PO1" is not null ) OR ( po2."Počet PO2" is not null ) OR ( po3."Počet PO3" is not null ) OR ( po4."Počet PO4" is not null ) )

ORDER BY po1."Počet PO1" DESC
