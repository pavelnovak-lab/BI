CREATE or REPLACE view "®oZ OPTAK" FOLDER= AS 
SELECT null pm,
       hs."Zmìnil/a",
       hs."Datum zmìny",
       zwf."Název" wfstav,
       null stavdo,
       p."Registraèní èíslo projektu" ,
       z."Poøadí", 

FROM projekt p
INNER JOIN zmena z ON z.id_zad = p.id
INNER JOIN historie_stavu hs ON hs.nositelid = z.id
INNER JOIN ciselnik_stav_workflow zwf ON zwf.id = hs.id_stavdo

WHERE zwf."Název" = 'Schválena'
