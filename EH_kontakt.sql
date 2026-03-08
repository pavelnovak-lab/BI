SELECT uzivatel.email,
       uzivatel.mobil,
       uzivatel.username,
       uzivatel.uzivatel,
       hodnotitel."Kód",
       hodn.registraceschvalena,
       hodn.vyrazenzdatabaze,
       linie.KODDLENARIZ OP,
       listagg(cis."Kód", '; ' ON overflow truncate) within group (order by cis."Kód")  AS "Kód odbornosti",
       listagg(cis."Název", '; ' ON overflow truncate) within group (order by cis."Kód")  AS Odbornosti
       
FROM isum.V_BI_UMVHODNOTITEL hodnotitel
INNER JOIN ISUM.V_BI_CUZIVATEL uzivatel ON uzivatel.id = hodnotitel.id_cuzivatel
INNER JOIN isum.v_bi_UMVHodnotitelPrg hodn ON hodnotitel.id = hodn.id_hodnotitel
INNER JOIN isum.v_bi_UMSHIPLinie linie ON linie.id = hodn.id_program
INNER JOIN isum.v_bi_UmvHodnOdbornost odb ON odb.id_HodnotitelPrg = hodn.id
INNER JOIN isum.v_bi_UMSCisOdbornost cis ON cis.id = odb.id_odbornost

WHERE hodnotitel."Interní hodnotitel" = 'N'

GROUP BY uzivatel.email,
       uzivatel.mobil,
       uzivatel.username,
       uzivatel.uzivatel,
       hodnotitel."Kód",
       hodn.registraceschvalena,
       hodn.vyrazenzdatabaze,
       linie.KODDLENARIZ

ORDER BY "Kód"
