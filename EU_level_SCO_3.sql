SELECT p."Registraèní èíslo projektu" ,
       hodn."Dosa¾ená hodnota z projektu",
       i."Kód NÈI 2014+" ,
       p."Registraèní èíslo projektu",
       p.kodwfstav,
       v."Èíslo výzvy" 

FROM isum.v_bi_UmzPrjGG p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMVIndiHodnotaPrj hodn ON hodn.id_nositelindi = p.id AND hodn."Platnost" = 'A' AND hodn."Dosa¾ená hodnota z projektu" is not null  AND hodn.typdleprav = 'A'
INNER JOIN isum.v_bi_UmvIndikator i ON i.id = hodn.id_indikator

WHERE p."Registraèní èíslo projektu" is not null
AND p.kodwfstav in ('PP42') 
AND v."Èíslo výzvy" in ('01_16_045','01_16_049','01_17_109','01_15_010','01_16_061','01_19_251')
AND i."Kód NÈI 2014+" in ('36010','32700','34901','32500','34900','32802','21410','20400','20702','20000','21200','21301','22501')
