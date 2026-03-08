SELECT -- prg."Kód" "Kód Priority",
       op.nazev as "Opatøení" ,
       v."Èíslo výzvy",
       v."Název výzvy",
       p."Registraèní èíslo projektu" ,
       w."Kód" "Stav projektu" ,
       h."Poøadí",
       h."Arbitr",
       h."Výsledek (v bodech)" ,
       h."Schváleno schvalovatelem",
       h."Platný",
       h."Datum finalizace",
       h."Datum vytvoøení",
       cs.*
       -- chybí status posudku st.*
       
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN v_rav_umshisc sc on sc.id=op.id_hierarchie
INNER JOIN programova_linie prg ON prg.id = sc.id_osa 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id   
INNER JOIN hodnoceni h ON p.id = h.id_noshodnoceni
INNER JOIN hodnotitel tel ON h.id_hodnotitel = tel.id
INNER JOIN hodnotitel_adresa_depese dep ON dep.id = tel.id
INNER JOIN hodnoceni_schvaleni s ON s.id = h.id_schvaleni
INNER JOIN ciselnik_stav_schvaleni cs ON cs.id = s.id_stavschvaleni
INNER JOIN ciselnik_status_hodnoceni st ON st.id = h.id_statushodn

WHERE
 -- h."Platný" = 'A'
 h."Finalizováno" = 'A'
 AND tel."Interní hodnotitel" = 'N'
 AND h."Opravný posudek" = 'N'
 AND prg."Kód" = '01.01' 
 AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000364'
