SELECT p."Registraèní èíslo projektu",
       p.zadatel ,
       p.kodwfstav,
       p.wfstavdatum,
       -- p."Datum ukonèení pøedp",
       -- p."Datum ukonèení skut",       		
       -- -- v."Název výzvy" ,
       -- v."Èíslo výzvy" ,
       pzf."Celkové zpùsobilé výdaje" CZV,
       pzf."Pøíspìvek Unie" EU,
       pzf."PROC_EU" "Procento EU",
       LISTAGG(distinct uk."Název", '; ')  "Kraj realizace"
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmzPrjUmisteniKraj	uk ON uk.id_projekt = p.id AND uk.typ = 'Realizace'
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 


WHERE p."Registraèní èíslo projektu" is not null
-- AND v."Èíslo výzvy" in :vyzva

-- AND uk."Název" = 'Moravskoslezský kraj'

GROUP BY p."Registraèní èíslo projektu",
       p.zadatel ,
       p.kodwfstav,
       p.wfstavdatum,
       p."Datum ukonèení pøedp",
       p."Datum ukonèení skut",       		
       -- v."Název výzvy" ,
       -- v."Èíslo výzvy" ,
       pzf."Celkové zpùsobilé výdaje",
       pzf."Pøíspìvek Unie",
       pzf."PROC_EU"
