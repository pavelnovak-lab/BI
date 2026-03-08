select p."Registraèní èíslo projektu", 
       p."Název projektu CZ",
       w."Kód" "Stav projektu",
       sd.*
       
FROM projekt_sdileni sd 
INNER JOIN projekt p on p.id = sd.id_nositelsdil
INNER JOIN vyzva v on v.id = p.id_vyzva
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id   


where v."Èíslo výzvy" = '01_24_001'
