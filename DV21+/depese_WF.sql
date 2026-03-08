SELECT p."Registraèní èíslo projektu" ,
       p."Identifikace ¾ádosti (hash)" ,
       p."Název projektu CZ" 

FROM projekt 
-- INNER JOIN historie_stavu hs ON hs.nositelid = p.id
-- INNER JOIN ciselnik_stav_workflow swf ON swf.id = hs.id_stavdo

WHERE  p."Název projektu CZ" like '%Faulhammer%'
