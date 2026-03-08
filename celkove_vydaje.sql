SELECT substr(p."Registraèní èíslo projektu",-5,5) "Poslední pìtièíslí projektu",
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       p.kodwfstav ,
       pzf."Celkové nezpùsobilé výdaje",
       pzf."Celkové zdroje",
       pzf."Celkové zpùsobilé výdaje",
       pzf."Pøíspìvek Unie",
       pzf."PROC_EU" "Procento EU"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav

WHERE p."Registraèní èíslo projektu" is not null
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4')
AND p.kodwfstav in ('PP20','PP21','PP22','PP23a','PP23b','PP27a','PP27b','PP29','PU21','PU27','V2','V5','Z1','Z3','PP30','PP36','PP37','PP40')

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) 


