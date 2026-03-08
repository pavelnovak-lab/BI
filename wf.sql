SELECT p."Registraèní èíslo projektu",
       p."Název projektu CZ" 

FROM isum.v_bi.UMSSablonyStavu s
INNER JOIN isum.v_bi_UmzProjekt p ON p.id_sablonystavu = s.id


WHERE s.id <> 1214524
AND p."Registraèní èíslo projektu" is not null 

