SELECT v."Název výzvy" ,
       v."Èíslo výzvy" ,
       w."Kód" "Kód stavu" ,
       w."Název" 

FROM vyzva v
INNER JOIN ciselnik_stav_workflow w ON v.id_wfstav = w.id  


WHERE not exists
      (SELECT 1
       FROM soubor_kriterii_vyzvy skv
       WHERE skv."Poèet hodnotitelù" = 2
       AND skv."Platnost do" is null
       AND skv.id_vyzva = v.id)
AND w."Název" IN ('Uzavøená','Otevøená')
