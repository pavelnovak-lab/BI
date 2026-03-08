SELECT op."Název specifického cíle/opatření" as "Opatření",
       p."Registrační číslo projektu" ,
       w."Kód" ,
       p."Předpokládané datum ukončení" ,
       pl.dp,
       pl.dp - p."Předpokládané datum ukončení" "Rozdíl datumů"


FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil 
INNER JOIN (SELECT max("Datum předložení") dp,
      	   	  id_nositelplatby
      	   FROM platba
	   GROUP BY id_nositelplatby) pl ON pl.id_nositelplatby = p.id 	   

WHERE w."Kód" like 'PP%'
AND pl.dp - p."Předpokládané datum ukončení" > 63
