SELECT op."Název specifického cíle/opatření" as "Opatření" ,
       p."Registrační číslo projektu" ,
       pf."Jiné peněžní příjmy připadající na nezpůsobilé výdaje",
       pf."Jiné peněžní příjmy připadající na způsobilé výdaje"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil 

WHERE
pf."Jiné peněžní příjmy připadající na nezpůsobilé výdaje" <> 0
OR pf."Jiné peněžní příjmy připadající na způsobilé výdaje" <> 0
OR pf."Příjmy z provozu" <> 0
