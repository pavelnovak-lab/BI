-- CREATE or REPLACE view "RIS3_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 
SELECT op.nazev as "Opatøení" ,
       v."Èíslo výzvy" ,
       p."Registraèní èíslo projektu" ,
       w."Kód" "Kód stavu" ,
       -- h."Poøadí",
       tel."Kód u¾ivatele" ,
       -- sk.hk,
       CASE WHEN sk.hk = 1 THEN 'A'
	    ELSE 'N' END AS "Posudek obsahuje hodnotící kritéria",
       CASE WHEN tel."Interní hodnotitel" = 'A' THEN 'IH'
       	    ELSE 'EH' END AS "IH/EH",
       h."Výsledek (v bodech)",
       h."Datum finalizace",
       h."Opravný posudek",
       h."Arbitr",
       h."Schváleno schvalovatelem"   

       

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id
INNER JOIN hodnotitel tel ON tel.id = h.id_hodnotitel
INNER JOIN (SELECT soubor.id ,
      	   	   max(CASE WHEN k.id is not null THEN 1
      	   	   	ELSE 0 END) AS hk
	    FROM soubor_kriterii_vyzvy sk
	    INNER JOIN soubor_kriterii soubor ON soubor.id = sk.id_souborkrit
	    LEFT JOIN hodnotici_kriterium k ON k.id_souborkrit = soubor.id AND k.id_typkriteria = 488949
	    WHERE sk."Poèet hodnotitelù" = 2
	    -- AND soubor.id IN (89563065, 21176262)
	    GROUP BY soubor.id) sk ON sk.id = h.id_souborkrit
	    

WHERE h."Platný" = 'A'
-- AND  = 178023803
-- AND p."Registraèní èíslo projektu" in ('CZ.01.04.01/01/24_049/0004841', 'CZ.01.01.02/01/23_023/0004010', 'CZ.01.01.01/01/23_027/0003143','CZ.01.01.01/01/22_002/0000534')

