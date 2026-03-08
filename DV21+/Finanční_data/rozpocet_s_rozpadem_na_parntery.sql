SELECT DISTINCT  v."Číslo výzvy" ,
       v."Název výzvy" ,
	c."Kód" ,
       c."Název" 

FROM vyzva AS v
INNER JOIN vyzva_matricni_data AS md ON md.id_vyzva = v.id AND md."Platný" = 'A'
INNER JOIN ciselnik_skupina_rozpoctu AS c ON c.id = md.id_ciszakladni
-- INNER JOIN rozpocet_skupina sk ON sk.id = md.id_ciszakladni -- dá se vyhodit pryč
INNER JOIN rozpocet_skupina_polozka rsp ON rsp.id_predpis = md.id_ciszakladni

WHERE EXISTS (SELECT 1
    	    FROM rozpocet_skupina_polozka
	    WHERE "Rozpad položky pro partnery s finančním příspěvkem" = 'A'
	    AND id_predpis = md.id_ciszakladni)
AND ms.id_ciszakladni = 19688663
