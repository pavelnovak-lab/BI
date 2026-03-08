-- CREATE or REPLACE view "SDP_parcela_realizace" FOLDER= AS 
SELECT v."Èíslo výzvy" ,
       p."Registraèní èíslo projektu",
       w."Kód" "Kód stavu" ,
       psdp."CZ"

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN projekt_sdp psdp ON psdp.id_projekt = p.id
-- INNER JOIN specificka_datova_polozka sdp ON sdp.id =  psdp.id_sdp
-- INNER JOIN ciselnik_sdp_projekt c ON c.id_sdp = sdp.id

WHERE v."Èíslo výzvy" in ('01_23_026')
AND p."Registraèní èíslo projektu" is not null
-- AND psdp."CZ" is not null 
