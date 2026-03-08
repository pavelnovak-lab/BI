CREATE or REPLACE view "RIS3_T2_OPTAK-KI" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 

SELECT '01' "Operaèní program (KOD)",
      'Operaèní program podnikání a inovace pro konkurenceschopnost' "Operaèní program (NÁZEV)",
       sc.kodnovy as  "Kód SC",
       sc.nazev as  "SC",
       op.nazev as "Opatøení",
       NULL "Kód indikátoru",
       'Zdroje EFRR vyu¾ité v oblasti Rozvoj dovedností pro inteligentní specializaci, prùmyslovou transformaci a podnikání (kód intervence 023)' "Název indikátoru",
       'Výstup' "Typ indikátoru" ,
       'EUR' "Mìrná jednotka",
       NULL "Výchozí hodnota",
       NULL "Cílová hodnota" ,
       sum(ki."Indikativní alokace") "Dosa¾ená hodnota"

FROM vyzva AS v
INNER JOIN ciselnik_stav_workflow AS vw ON vw.id = v.id_wfstav
INNER JOIN projekt AS p ON p.id_vyzva = v.id and p."Registraèní èíslo projektu" is not null
-- LEFT JOIN ciselnik_stav_workflow AS pw ON pw.id = p.id_wfstav
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN v_rav_umshisc sc on sc.id=op.id_hierarchie
INNER JOIN programova_linie prg ON prg.id = sc.id_osa
INNER JOIN kategorie_intervenci_oblast_intervence ki ON ki.id_projekt = p.id
INNER JOIN ciselnik_oblast_intervence cki ON cki.id = ki.id_ki

WHERE sc.kodnovy IN ('01.01.01','01.01.02') 
AND cki."Kód" = '023'

GROUP BY "Operaèní program (KOD)",
       "Operaèní program (NÁZEV)",
       "Kód SC",
       "SC",
       "Opatøení",
       "Kód indikátoru",
       "Název indikátoru",
       "Typ indikátoru" ,
       "Mìrná jednotka",
       "Výchozí hodnota",
       "Cílová hodnota" 

----------------------------------------


SELECT p."Registraèní èíslo projektu" ,
       cki."Kód" "Kód KI",
       cki."Název" "Název KI" ,
       w."Kód" "Kód stavu" ,
       ki."Indikativní alokace",
       v."Název výzvy" 
FROM projekt p 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id
INNER JOIN kategorie_intervenci_oblast_intervence ki ON ki.id_projekt = p.id
INNER JOIN ciselnik_oblast_intervence cki ON cki.id = ki.id_ki
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav
INNER JOIN vyzva v ON v.id = p.id_vyzva 

WHERE w."Kód" in ('PP30','PP31','PP36','PP37','PP40','PP41','PP42','PP43','PU30')
AND cki."Kód" = '023'

AND v."Èíslo výzvy" IN '01_24_051'


