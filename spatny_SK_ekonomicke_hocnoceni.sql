SELECT DISTINCT v."Číslo výzvy" ,
       v."Název výzvy",
       sk."Název souboru kritérií",
       p."Registrační číslo projektu" ,
       w."Kód" "Kód stavu" ,
       h."Výsledek (v bodech)"
              
	      
FROM vyzva v 
INNER JOIN soubor_kriterii_vyzvy skv ON skv.id_vyzva = v.id
INNER JOIN soubor_kriterii sk ON sk.id = skv.id_souborkrit
INNER JOIN projekt p ON p.id_vyzva = v.id AND p."Registrační číslo projektu" is not null 
INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id AND h.id_souborkrit = sk.id AND h.id_statushodn = 488649 -- nevyhověl 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  

WHERE skv.id_souborkrit IN (21177955, 21177955) -- sk s jedním bodem 


