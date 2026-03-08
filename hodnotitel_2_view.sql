SELECT	hodnotitel.id ,
	hodn.RATINGZNAMKANAPOCETH, 
 	hodnotitel."Kód",
	hodnotitel."Externí hodnotitel" ,
	LISTAGG(DISTINCT vs."Název subjektu", '; ' on overflow truncate) "Název zamìstnavatele",
	LISTAGG(DISTINCT cis."Název", '; ' on overflow truncate) "Odbornost",
	LISTAGG(DISTINCT vs."IÈ",  '; ' on overflow truncate) "IÈ zamìstnavatele" ,
 	-- listagg(DISTINCT cise."Název",'; ') "Odbornost projektu"
	max(komp."Datum vyjádøení") "Poslední datum pøijetí nom."

FROM isum.v_bi_UmvHodnotitel hodnotitel -- ON hodnotitel.id = h.id_hodnotitel 
INNER JOIN isum.v_bi_UMVHodnotitelPrg hodn ON hodn.id_hodnotitel = hodnotitel.id
INNER JOIN isum.v_bi_UMVHodnotitelKomp komp ON komp.id_hodnotitel = hodnotitel.id AND komp.id_kolohodn = 171212 -- AND komp.ID_NOSHODNOC
LEFT JOIN isum.v_bi_UMVHodnVerzeSubjektu vs  ON vs.id_hodnotitel = hodnotitel.id
LEFT JOIN isum.v_bi_UmvHodnOdbornost odbornost ON odbornost.id_HodnotitelPrg = hodn.id
LEFT JOIN isum.v_bi_UMSCisOdbornost cis ON cis.id = odbornost.id_odbornost

WHERE (cis."Název" like 'CZ-NACE%' OR UPPER(cis."Název") like 'PO3%%' OR cis."Název" like 'PO2%' OR cis."Název" like 'PO4%')
-- AND h.id_KrokVecHodn in (171213, 171214) /* 1. a 2. krok VH */
-- AND h.id_kolohodnoceni= 171212
AND hodnotitel.SEZNAMPRGREGIST like '%OP PIK%' 
AND hodnotitel.SEZNAMPRGSCHV like '%OP PIK%'


GROUP BY hodnotitel.id ,
	hodn.RATINGZNAMKANAPOCETH, 
 	hodnotitel."Kód",
	hodnotitel."Externí hodnotitel" 

-- ORDER BY hodnotitel."Kód"

----------------------------------------
SELECT *

FROM isum.v_bi_cuzivatel
