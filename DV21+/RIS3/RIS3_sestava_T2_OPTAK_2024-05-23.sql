-- Operaèní program (KOD), Operaèní program (NÁZEV), Specifický cíl OP, Èíslo výzvy, Název výzvy, Kód indikátoru, Název indikátoru, Typ indikátoru, Mìrná jednotka indikátoru, Výchozí hodnota, Cílová hodnota, Dosa¾ená hodnota

SELECT p."Registraèní èíslo projektu" ,
       v."Èíslo výzvy",
       v."Název výzvy",
       i."Kód NÈI 2021+" "Kód indikátoru",
       i."Název indikátoru CZ",
       cti."Typ indikátoru" ,
       cmj."Název mìrné jednotky" "Mìrná jednotka",
       ih."Výchozí hodnota",
       ih."Cílová hodnota",
       ih."Dosa¾ená hodnota"

       
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
inner join indikator_hodnota ih on ih.id_nositelindi = p.id
inner join indikator i on ih.id_indikator = i.id
inner join ciselnik_merna_jednotka cmj on i.id_mernajednotka = cmj.id
INNER JOIN ciselnik_typ_indikatoru cti ON cti.id = i.id_typindi



WHERE (w."Kód"  like ('PP3%') OR w."Kód"  like ('PP4%') )
AND v."Výzva zamìøená na RIS3 strategie" = 'A'
AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/02/22_003/0000098'
AND i."Kód NÈI 2021+" IN ('212002','214001','214011','241020','225010','101052','101042','101022','103002','200002','ne','204002','250001','107301','302031','303031')
