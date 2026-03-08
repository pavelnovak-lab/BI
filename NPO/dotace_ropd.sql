SELECT p."Registraèní èíslo projektu" ,
       -- pzf."Pøíspìvek Unie" 
       pzf.*

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav

WHERE p."Registraèní èíslo projektu" = 'CZ.31.3.0/0.0/0.0/22_001/0003145'
