-- CREATE or REPLACE view "tak-mpo-novak_RoPD_PP29" FOLDER= AS 

Select op.nazev as "Opatøení" ,
       v."Èíslo výzvy" ,
       v."Název výzvy",
       p."Registraèní èíslo projektu",
       pwf."Kód",
       -- hs."Poøadí",
       hs."Datum pøepnutí" "Datum zmìny stavu",
       hs."U¾ivatel, který provedl pøepnutí stavu" "Pøepnul u¾ivatel"
       pzf."Pøíspìvek Unie" "EU dotace"
    
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN historie_stavu hs ON hs.nositelid = p.id
INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = (99991000000000005)  --  aktuální stav

WHERE pwf."Kód" in ('PP26','PP30')



p."Registraèní èíslo projektu" is not null
-- AND v."Èíslo výzvy" = '01_22_006'
