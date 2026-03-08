SELECT p."Registraèní èíslo projektu",
       p.kodwfstav,
       hl."Název" "Název aktuálního rozpoètu",
       pol."Kód",
       pol."Název",
       pol."Èástka celkem"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMFROZHlavickaPrj hl ON p.id = hl.id_nrozpocet AND hl."Aktuální" = 'A'
INNER JOIN isum.V_BI_UMFROZSkupina sk ON sk.id = hl.id_skupina
INNER JOIN isum.V_BI_UMFROZPOLOZKYPRJ pol ON pol.id_hlavicka = hl.id AND (pol.LISTOVA = 'A' or pol."Název" = 'Celkové zpùsobilé výdaje')

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) asc, pol."Kód"
