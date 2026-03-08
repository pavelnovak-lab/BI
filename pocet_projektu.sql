SELECT count(p.id)

FROM isum.v_bi_UmzProjekt p

WHERE p."Registraèní èíslo projektu" is not null
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PU30') 
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 

-- AND p.kodwfstav in ('PN40a','PN40b')
