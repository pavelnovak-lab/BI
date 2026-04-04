SELECT	hodnotitel.id ,
	hodn.RATINGZNAMKANAPOCETH, 
 	hodnotitel."Kód",
	hodnotitel."Externí hodnotitel" ,
	LISTAGG(DISTINCT vs."Název subjektu", '; ' on overflow truncate) "Název zaměstnavatele",
	LISTAGG(DISTINCT cis."Název", '; ' on overflow truncate) "Odbornost",
	LISTAGG(DISTINCT vs."IČ",  '; ' on overflow truncate) "IČ zaměstnavatele" ,
 	-- listagg(DISTINCT cise."Název",'; ') "Odbornost projektu"
	max(komp."Datum vyjádření") "Poslední datum přijetí nom."

FROM isum.v_bi_UmvHodnotitel hodnotitel -- ON hodnotitel.id = h.id_hodnotitel -- AND h.id_KrokVecHodn = 171214 /* 2. krok VH */ AND h.id_kolohodnoceni= 171212
INNER JOIN isum.v_bi_UMVHodnotitelPrg hodn ON hodn.id_hodnotitel = hodnotitel.id
INNER JOIN isum.v_bi_UMVHodnotitelKomp komp ON komp.id_hodnotitel = hodnotitel.id AND komp.id_kolohodn = 171212 -- AND komp.ID_NOSHODNOC
LEFT JOIN isum.v_bi_UMVHodnVerzeSubjektu vs  ON vs.id_hodnotitel = hodnotitel.id
LEFT JOIN isum.v_bi_UmvHodnOdbornost odbornost ON odbornost.id_HodnotitelPrg = hodn.id
LEFT JOIN isum.v_bi_UMSCisOdbornost cis ON cis.id = odbornost.id_odbornost

WHERE (cis."Název" like 'CZ-NACE%' OR UPPER(cis."Název") like 'PO3%%' OR cis."Název" like 'PO2%' OR cis."Název" like 'PO4%')

GROUP BY hodnotitel.id ,
	hodn.RATINGZNAMKANAPOCETH, 
 	hodnotitel."Kód",
	hodnotitel."Externí hodnotitel" 

-- ORDER BY hodnotitel."Kód"
