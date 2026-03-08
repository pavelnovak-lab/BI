SELECT p."Registraèní èíslo projektu" AS "Èíslo projektu",
       w.kod AS "Kód stavu",
       st."Celkový výsledek - v bodech" "2. krok VH body",
       cis."Název" "Status 2. kroku VH",
       pzf."Pøíspìvek Unie"

FROM projekt AS p
INNER JOIN v_rav_umscisstavwf AS w ON w.id = p.id_wfstav 
INNER JOIN vyzva AS v ON v.id = p.id_vyzva 
INNER JOIN hodnoceni_status st ON st.id_noshodnoceni = p.id  AND st.id_krokvechodn = 488854 
INNER JOIN ciselnik_status_hodnoceni cis on cis.id = st.id_statushodn
LEFT JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005

WHERE p."Registraèní èíslo projektu" is not null 
AND v."Èíslo výzvy" = '01_22_002'
