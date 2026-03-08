SELECT p."Registraèní èíslo projektu" ,
       p."Anotace projektu",
       p.kodwfstav ,
       p."Název projektu CZ"

FROM isum.v_bi_UmzProjekt p

WHERE p."Registraèní èíslo projektu" is not null
AND   p."Anotace projektu" like '%zku¹ební provoz%'
