SELECT DISTINCT  v."Číslo výzvy" ,
       v."Název výzvy" ,
	-- c."Kód" ,
       -- c."Název" 
       wv."Název" "Stav výzvy",
       pocty."Počet projektů" "Projektů v pozitivních stavech před RoPD"
FROM vyzva AS v
INNER JOIN vyzva_matricni_data AS md ON md.id_vyzva = v.id AND md."Platný" = 'A'
-- INNER JOIN ciselnik_skupina_rozpoctu AS c ON c.id = md.id_ciszakladni
INNER JOIN ciselnik_stav_workflow wv ON v.id_wfstav = wv.id   
-- INNER JOIN rozpocet_skupina sk ON sk.id = md.id_ciszakladni -- dá se vyhodit pryč
INNER JOIN rozpocet_skupina_polozka rsp ON rsp.id_predpis = md.id_ciszakladni
LEFT JOIN (SELECT count(p.id) "Počet projektů" ,
     	  	  p.id_vyzva
		  
           FROM projekt p
	   INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
	   WHERE NOT w."Kód" REGEXP_LIKE 'PP[34].*|PN.*' -- pozitivní stavy před PP30
	   GROUP BY p.id_vyzva
	   ) pocty ON pocty.id_vyzva = v.id



WHERE EXISTS (SELECT 1
    	    FROM rozpocet_skupina_polozka
	    WHERE "Rozpad položky pro partnery s finančním příspěvkem" = 'A'
	    AND id_predpis = md.id_ciszakladni)
-- AND ms.id_ciszakladni = 19688663


----------------------------------------

Číslo výzvy
Název výzvy
Kód
Název
01_22_002
Aplikace - výzva I.
OP TAK 01
Rozpočet Aplikace
01_23_036
Proof of Concept - Výzva II - aktivita b)
OP TAK 29
Rozpočet Proof of Concept - výzva II. b)
01_25_079
Proof of Concept - výzva III. - přechodové regiony - aktivita b)
OP TAK Proof III. B
Rozpočet Proof of Concept - aktivita B) - III. výzva
01_25_071
Proof of Concept - výzva III. - méně rozvinuté regiony - aktivita a)
OP TAK Proof III. A
Rozpočet Proof of Concept - aktivita A) - III. výzva
01_25_078
Proof of Concept - výzva III. - přechodové regiony - aktivita a)
OP TAK Proof III. A
Rozpočet Proof of Concept - aktivita A) - III. výzva
01_24_063
Aplikace – výzva III. – DEEP TECH
OP TAK 01 - DEEP TECH
Rozpočet Aplikace - DEEP TECH
01_23_027
Aplikace – speciální výzva
OP TAK 01 - Speciální výzva
Rozpočet Aplikace - speciální výzva
01_24_056
Aplikace - Mezinárodní spolupráce
OP TAK 01 - Mezinárodní spolupráce - detail
Rozpočet Aplikace - Mezinárodní spolupráce
01_25_072
Proof of Concept - výzva III. - méně rozvinuté regiony - aktivita b)
OP TAK Proof III. B
Rozpočet Proof of Concept - aktivita B) - III. výzva
01_24_062
Aplikace – výzva II. – VÝVOJ DIGITÁLNÍCH ŘEŠENÍ
OP TAK APL DIGI (partner)
Rozpočet Aplikace - vývoj digi řešení (včetně partnerů
