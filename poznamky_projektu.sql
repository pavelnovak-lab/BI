SELECT p."Registraèní èíslo projektu" ,
       poz.*

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UMSDBPoznamky poz ON poz.id_nositel = p.id

WHERE p."Registraèní èíslo projektu" in ('CZ.31.5.0/0.0/0.0/22_010/0003065', 'CZ.31.5.0/0.0/0.0/22_010/0003063', 'CZ.31.5.0/0.0/0.0/22_010/0003038')




SELECT *

FROM isum.v_bi_UMSDBPoznamky

WHERE id = 1668169044



SELECT p."Registraèní èíslo projektu" ,
       pzf."Národní veøejné zdroje"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UMFPFCelkem pzf  ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav

WHERE --  p."Registraèní èíslo projektu" in ('CZ.31.5.0/0.0/0.0/22_010/0003065', 'CZ.31.5.0/0.0/0.0/22_010/0003063', 'CZ.31.5.0/0.0/0.0/22_010/0003038')
       pzf."Národní veøejné zdroje" > 0
AND p."Registraèní èíslo projektu" is not null
AND p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.4','31.5','31.9','31.14','31.22','31.26') 
