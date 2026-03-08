SELECT p."Registraèní èíslo projektu" ,
       p."Název projektu CZ",
       p.zadatel ,
       p.kodwfstav ,
       p.wfstav ,
       v."Èíslo výzvy" ,
       v."Název výzvy",
       pzf."Pøíspìvek Unie",
       pzf."Celkové zpùsobilé výdaje",
       -- vs."Poèet zamìstnancù",
       ci."Název" "Velikost podniku (¾adatel)"
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  vs.id_velikostpodniku

WHERE p."Registraèní èíslo projektu" is not null
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PU30')
AND v."Èíslo výzvy" in ('01_16_084','01_16_083','01_15_019','01_15_018','01_15_015')
AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_019/0004555'

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC


