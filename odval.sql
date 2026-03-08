SELECT p."Registraèní èíslo projektu",
       p.zadatel,
       p."Název projektu CZ" 

FROM isum.v_bi_UmzProjekt p

WHERE p."Registraèní èíslo projektu" is not null
-- AND p."Anotace projektu" like '%odval%'
-- AND p."Anotace projektu" like '%Heøma%'
AND p.zadatel like '%Ostravsk
