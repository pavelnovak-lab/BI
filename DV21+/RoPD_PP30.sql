CREATE or REPLACE view "RoPD_PP30" FOLDER= AS 
SELECT hs."Zmìnil/a",
       hs."Datum zmìny",
       p."Registraèní èíslo projektu" ,
       pf."Pøíspìvek Unie" "RoPD EU dotace"

FROM projekt p
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000011 -- RoPD
INNER JOIN smlouva s ON s.id_nositelsml = p.id AND s.id_typ = 489758 -- typ PA: RoPD
INNER JOIN historie_stavu hs ON hs.nositelid = s.id
INNER JOIN ciselnik_stav_workflow swf ON swf.id = hs.id_stavdo

WHERE swf."Kód" = 'P4' 
