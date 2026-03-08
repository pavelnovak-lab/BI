select v."Èíslo výzvy" ,
       v."Název výzvy" 

from vyzva v ON v.id = p.id_vyzva 
INNER JOIN v_rav_umvhodnsoubkritvyz sk ON sk.id_vyzva = v.id

where sk.id_souborkrit IN (21177955, 21177955) -- sk s jedním bodem 
