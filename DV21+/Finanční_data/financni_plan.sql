SELECT count(hl.id)

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
INNER JOIN rozpocet_hlavicka hl ON hl.id_nrozpocet = p.id 

WHERE v."Číslo výzvy" = '01_23_034'
AND p."Registrační číslo projektu" is not null

ORDER BY pl."Datum předložení" 

