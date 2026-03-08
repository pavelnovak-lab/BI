SELECT p.*

FROM isum.v_bi_UmzProjekt p

WHERE p.kodwfstav  = 'PP43'
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/17_115/0012775'
