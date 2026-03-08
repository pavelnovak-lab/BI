SELECT p."Registraèní èíslo projektu",
       rez."Re¾im podpory",
       clanek."Podkategorie" "Èlánek GBER",
       vpo."Èástka poskytnuté veøejné podpory celkem - Pøíspìvek Unie v Kè" "Èástka",
       pf."Doporuèený pomìr financování (%)" AS "EU podíl max",
       100 - pf."Doporuèený pomìr financování (%)" AS "Vlastní podíl min"

FROM projekt p
INNER JOIN verejna_podpora vpo ON vpo.id_projekt = p.id
INNER JOIN ciselnik_rezim_podpory rez ON rez.id = vpo.id_rezimpodpory
LEFT JOIN (SELECT gber."Podkategorie",
     	  	  vpo.id_projekt,
		  vpo.id
     	   FROM verejna_podpora vpo
     	   INNER JOIN ciselnik_podkategorie_podpory gber ON gber.id = vpo.id_podkategorie )
	   AS clanek ON clanek.id_projekt = p.id AND vpo.id = clanek.id
INNER JOIN pomery_financovani pf ON vpo.id = pf.id_nositelpompf AND pf.id_zdrojfin = 415432

WHERE p."Registraèní èíslo projektu" = 'CZ.01.04.01/01/24_049/0004874'
AND vpo."Platnost" = 'A'

ORDER BY res."Re¾im podpory", clanek."Podkategorie" desc

----------------------------------------
SELECT pf.* , vpo.*

from pomery_financovani pf
INNER JOIN verejna_podpora vpo ON vpo.id = pf.id_nositelpompf

where pf.id = 370488932
