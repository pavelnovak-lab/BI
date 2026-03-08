-- CREATE OR replace VIEW "kraceni-podle-14f-rozhodnuti-ministra" FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/finanèní_data' AS
SELECT op.nazev AS "Opatøení",
       pl."Èíslo platby" "Èíslo ®oP",
       -- s."Název subjektu" AS "Pøíjemce",
       -- rf."Schválená záloha ZS/ØO v této ®oP" AS "Schválená záloha",
       pwf."Kód" "Stav ®oP",
       pl."Datum zmìny stavu" "Datum pøepnutí stavu ®oP" ,
       rf."Pøedlo¾ené vyúètování v toto ®oP" "Po¾adovaná EU dotace" ,
       rf."Schválené vyúètování ZS/ØO v této ®oP" AS "Schválená EU dotace",
       rf."Pøedlo¾ené vyúètování v toto ®oP" - rf."Schválené vyúètování ZS/ØO v této ®oP" "Kráceno celkem (rozdíl pøedchozích sloupcù)" ,
       CASE WHEN pril."Název pøíloh" is not null then 'Ano'
       	    ELSE 'Ne' END AS "Rozhodnutí ministra" ,
       GROUP_CONCAT(DISTINCT '; ',  k."Charakter nezpùsobilých výdajù") "Dùvod krácení"
FROM projekt AS p
INNER JOIN vyzva AS v ON v.id = p.id_vyzva
INNER JOIN platba AS pl ON pl.id_nositelplatby = p.id
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null AND s.id_typsubjektuedit = 413462
INNER JOIN vyzva_hierarchie AS vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc AS op ON op.id = vh.id_speccil
INNER JOIN ciselnik_stav_workflow AS pwf ON pwf.id = pl.id_wfstav
INNER JOIN rozpis_financovani AS rf ON rf.id_platba = pl.id
INNER JOIN ciselnik_ukazatel_rozpis_financovani AS cu ON (rf.id_ukazatel = cu.id AND cu."Kód" = '7')
INNER JOIN historie_stavu AS hs ON hs.nositelid = pl.id
INNER JOIN ciselnik_stav_workflow AS plwf ON (plwf.id = hs.id_stavdo AND plwf."Kód" IN ('P6T', 'P9T'))
LEFT JOIN korekce k ON k.id_platba = pl.id -- AND k."Typ krácení" = 2  -- krácení jiné 
INNER JOIN ( SELECT GROUP_CONCAT(priloha."Název dokumentu") "Název pøíloh" ,
		   priloha.id_nositelpril
	    FROM platba_priloha priloha
	    WHERE UPPER(priloha."Název dokumentu") like '%MINISTR%'
	    AND UPPER(priloha."Název dokumentu") not like '%ADMINISTR%'
	    GROUP BY priloha.id_nositelpril) pril ON pril.id_nositelpril = pl.id

WHERE pwf."Kód" REGEXP_LIKE ('P1[0-4][T]?') -- stavy po P11 jsou ®oP vrácené z PO 



GROUP BY op.nazev,
       pl."Èíslo platby",
       pwf."Kód",
       pl."Datum zmìny stavu",
       rf."Pøedlo¾ené vyúètování v toto ®oP",
       rf."Schválené vyúètování ZS/ØO v této ®oP",
       rf."Pøedlo¾ené vyúètování v toto ®oP" - rf."Schválené vyúètování ZS/ØO v této ®oP",
       CASE WHEN pril."Název pøíloh" is not null then 'Ano'
       	    ELSE 'Ne' END


ORDER BY pl."Èíslo platby",  pl."Datum zmìny stavu"  DESC
