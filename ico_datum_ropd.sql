SELECT p."Registraèní èíslo projektu",
       hs.datumod AS "Datum vydání RoPD",
       p.kodwfstav ,
       p.zadatel ,
       p."IÈ"
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id

WHERE hs.stavdo = 'PP30'
AND p."IÈ" = 72070382
AND p."Registraèní èíslo projektu" is not null 

