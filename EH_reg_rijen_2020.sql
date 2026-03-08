select	 "V_BI_UMVHODNOTITEL"."Kód" as "Kód",
	 "V_BI_UMVHODNOTITEL"."SEZNAMPRGSCHV" as "SEZNAMPRGSCHV",
	 "V_BI_CUZIVATEL"."UZIVATEL" as "UZIVATEL",
	 "V_BI_UMVHODNOTITEL"."Platí do" as "Platí do",
	 "V_BI_UMVHODNOTITEL"."Platí od" as "Platí od",
	 "V_BI_UMVHODNOTITEL"."Externí hodnotitel" as "Externí hodnotitel",
	 "V_BI_UMVHODNNEPRITOMNOST"."Nepøítomnost do" as "Nepøítomnost do",
	 "V_BI_UMVHODNNEPRITOMNOST"."Nepøítomnost od" as "Nepøítomnost od",
	 "V_BI_UMVHODNOTITEL"."CREATE_CAS" as "CREATE_CAS",
	 "V_BI_UMVHODNOTITEL"."Aktivní" as "Aktivní" 
 from	"ISUM"."V_BI_UMVHODNNEPRITOMNOST" "V_BI_UMVHODNNEPRITOMNOST",
	"ISUM"."V_BI_CUZIVATEL" "V_BI_CUZIVATEL",
	"ISUM"."V_BI_UMVHODNOTITEL" "V_BI_UMVHODNOTITEL" 
 where   "V_BI_UMVHODNOTITEL"."ID_CUZIVATEL"="V_BI_CUZIVATEL"."ID"
 and	 "V_BI_UMVHODNNEPRITOMNOST"."ID_HODNOTITEL"(+) ="V_BI_UMVHODNOTITEL"."ID"
  and 	 "V_BI_UMVHODNOTITEL"."SEZNAMPRGSCHV" like '%OP PIK%' 
   and	 "V_BI_UMVHODNOTITEL"."Externí hodnotitel" ='A'
order by "V_BI_UMVHODNOTITEL"."Kód" DESC



SELECT u.uzivatel,
       h.create_cas,
       h.last_modif_cas,	
       h."Kód"

FROM isum.v_bi_UmvHodnotitel h
-- INNER JOIN isum.v_bi_UmsCisZakladni c ON c.id=h.id_hierarchie
INNER JOIN isum.v_bi_cuzivatel u ON u.id=h.id_cuzivatel

WHERE
-- h.id = 1482363 AND
h."Externí hodnotitel" = 'A'

ORDER BY h.last_modif_cas DESC




SELECT * FROM isum.v_bi_UmvHodnotitelPRG 
