SELECT p."Registraèní èíslo projektu" ,
       p.kodwfstav        
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.V_BI_UMFROZHlavicka hl ON p.id_nrozpocet
-- INNER JOIN isum.V_BI_UMFROZSkupina sk ON sk.

WHERE p."Registraèní èíslo projektu" is not null
--AND p.id_skupina = 552027579
--AND hl.id = 1086586316
