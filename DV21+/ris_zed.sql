SELECT p."Registraèní èíslo projektu",
       zed."Kód",
       -- w.kod "Stav projektu",
       pf."Pøíspìvek Unie" ,
       pf."Celkové zdroje pøipadající na zpùsobilé výdaje" ,
       p."Identifikaèní èíslo akce RIS ZED"
       
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN ciselnik_agregacni_akce_zed zed ON zed.id = p.id_agrakcezed
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav
INNER JOIN ciselnik_stav_workflow w ON w.id = p.id_wfstav

WHERE -- p."Identifikaèní èíslo akce RIS ZED" is not null 
-- p."Registraèní èíslo projektu" = 'CZ.01.07.01/01/23_022/0002981'
v."Èíslo výzvy" = '01_23_010'
