SELECT p."Registraèní èíslo projektu",
       p.zadatel ,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       p.kodwfstav ,
       p."Datum podání",
       p.wfstavdatum ,

       p."Fázovaný projekt",
       pzf."Pøíspìvek Unie" ,
       pzf."Celkové zpùsobilé výdaje" ,

       nvl(ukonceno."pocet",0) "Ukonèených etap",
       nvl(count(platba.id),0) "Poèet etap",
       listagg (DISTINCT ci."Název", '; ') "Tagy"       

     
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
-- INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id
INNER JOIN isum.v_bi_UMZPrjGGTag tag ON p.id = tag.id_prjgg
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = tag.id_tag
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 
LEFT JOIN (
SELECT platba.id_NositelPlatby ,
       count(platba.id) "pocet"
FROM isum.v_bi_UmpPlatbaPrj platba
WHERE platba.kodwfstav in ('N1','N2','N3','P10','P11')
GROUP BY platba.id_NositelPlatby
) ukonceno ON ukonceno.id_NositelPlatby = p.id

WHERE v."Èíslo výzvy" in ('01_20_321', '01_21_374')
-- AND p."Registraèní èíslo projektu" in 'CZ.01.1.02/0.0/0.0/20_321/0025139'
AND
(ci."Název" in ('Fázovaný PRJ') OR p."Fázovaný projekt" = 'A')
AND platba.SOUCTOVYRADEK is null


GROUP BY p."Registraèní èíslo projektu",
       p.zadatel ,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       p.kodwfstav ,
       p."Fázovaný projekt",
       pzf."Pøíspìvek Unie" ,
       pzf."Celkové zpùsobilé výdaje" ,
       ukonceno."pocet" ,
       p."Datum podání",
       p.wfstavdatum 
