
SELECT distinct op.nazev AS "Opatření",
       p."Registrační číslo projektu" ,
       s."Název subjektu" ,
       s."IČ" ,
       pa."IČ" "IČ poradenky",
       pa."Název" "Název poradenky"
       
FROM projekt AS p
JOIN vyzva AS v ON v.id = p.id_vyzva
JOIN vyzva_hierarchie AS vh ON vh.id_vyzva = v.id
JOIN v_rav_umshisc AS op ON op.id = vh.id_speccil
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null -- AND s.id_typsubjektuedit IN (413462, 413467) -- žadatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 

LEFT JOIN (SELECT GROUP_CONCAT( s."IČ" ) "IČ" ,
     	  	  GROUP_CONCAT( s."Název subjektu" ) "Název" ,
		  s.id_prjgg		  
	   FROM subjekt s
	   WHERE s."Neplatný od" is null
	   AND s.id_typsubjektuedit = 413437 -- zástupce žadatele, tedy poradenka)
	   GROUP BY s.id_prjgg) pa ON pa.id_prjgg = p.id

JOIN platba AS pl ON pl.id_nositelplatby = p.id
LEFT JOIN (
    SELECT DISTINCT id_platba
    FROM soupiska_doklad
    WHERE "ID z externího systému" > 0 OR "ID z externího systému" IS NOT NULL
) AS sd_xml ON sd_xml.id_platba = pl.id

WHERE pl."Číslo platby" IS NOT NULL
AND sd_xml.id_platba IS NOT NULL 
