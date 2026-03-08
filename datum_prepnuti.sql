SELECT p.wfstavdatum,
       p."Registraèní èíslo projektu"

FROM isum.v_bi_UmzProjekt p

WHERE p.kodwfstav in ('PN40a','PN40b')
