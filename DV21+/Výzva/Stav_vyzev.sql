-- CREATE OR replace VIEW "Stav_vyzev_vèetnì_ukonèených_projektù" FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/Vyzvy' AS

SELECT v."Èíslo výzvy",
       v."Název výzvy",
       prg."Kód" "Kód Priority",
       prg."Název" "Priorita",
       sc.kodnovy as  "Kód SC",
       sc.nazev as  "SC",
       op.kodnovy as  "Kód Opatøení",
       op.nazev as "Opatøení",
       v."Datum vyhlá¹ení výzvy",
       v."Datum ukonèení pøíjmu ¾ádostí o podporu",
       v."Datum zpøístupnìní ¾ádostí o podporu",
       v."Finanèní alokace výzvy (CZV)"/1000000 "Alokace výzvy (mil. Kè)",
       vw."Kód",
       vw."Název",
       CASE WHEN v."Druh výzvy" = 0 THEN 'Kolová'
       	    WHEN v."Druh výzvy" = 1 THEN 'Prùbì¾ná'
	    else null
	    end  "Druh výzvy",
       count(case when wfp."Kód stavu" in ('PP20', 'PP22', 'PU22a', 'PP23a', 'PP23b','PU24','PP24') then 1 END) AS "Projektù pøed VK",
       sum(case when wfp."Kód stavu" in ('PP20', 'PP22', 'PU22a', 'PP23a', 'PP23b','PU24','PP24') then pzf."Celkové zdroje pøipadající na zpùsobilé výdaje"/1000000 END) AS "CZV pøed VK (mil. Kè)",
       sum(case when wfp."Kód stavu" in ('PP20', 'PP22', 'PU22a', 'PP23a', 'PP23b','PU24','PP24') then pzf."Pøíspìvek Unie"/1000000 END) AS "EU pøed VK (mil. Kè)" ,
       sum(case when wfp."Kód stavu" in ('PP20', 'PP22', 'PU22a', 'PP23a', 'PP23b','PU24','PP24') then pzf."Národní veøejné zdroje"/1000000 END) AS "NVZ pøed VK (mil. Kè)",

       count(case when wfp."Kód stavu" in ('PU25') then 1 END) AS "Projektù v PU25",
       sum(case when wfp."Kód stavu" in ('PU25') then pzf."Celkové zdroje pøipadající na zpùsobilé výdaje"/1000000 END) AS "CZV v PU25 (mil. Kè)",
       sum(case when wfp."Kód stavu" in ('PU25') then pzf."Pøíspìvek Unie"/1000000 END) AS "EU v PU25 (mil. Kè)" ,
       sum(case when wfp."Kód stavu" in ('PU25') then pzf."Národní veøejné zdroje"/1000000 END) AS "NVZ v PU25 (mil. Kè)",

       count(case when wfp."Kód stavu" in ('PP25a','PP25b','PU26','PP26') then 1 END) AS "Projektù po VK pøed RoPD",
       sum(case when wfp."Kód stavu" in ('PP25a','PP25b','PU26','PP26') then pzf."Celkové zdroje pøipadající na zpùsobilé výdaje"/1000000 END) AS "CZV po VK pøed RoPD (mil. Kè)",
       sum(case when wfp."Kód stavu" in ('PP25a','PP25b','PU26','PP26') then pzf."Pøíspìvek Unie"/1000000 END) AS "EU po VK pøed RoPD (mil. Kè)" ,
       sum(case when wfp."Kód stavu" in ('PP25a','PP25b','PU26','PP26') then pzf."Národní veøejné zdroje"/1000000 END) AS "NVZ po VK pøed RoPD (mil. Kè)",

       count(case when (wfp."Kód stavu" like 'PP3%' ) then 1 END) AS "Projektù s RoPD",
       sum(case when (wfp."Kód stavu" like 'PP3%' ) then pzf."Celkové zdroje pøipadající na zpùsobilé výdaje"/1000000 END) AS "CZV s RoPD (mil. Kè)",
       sum(case when (wfp."Kód stavu" like 'PP3%' ) then pzf."Pøíspìvek Unie"/1000000 END) AS "EU s RoPD (mil. Kè)" ,
       sum(case when (wfp."Kód stavu" like 'PP3%' ) then pzf."Národní veøejné zdroje"/1000000 END) AS "NVZ s RoPD (mil. Kè)" ,

       count(case when (wfp."Kód stavu" like 'PP4%') then 1 END) AS "Ukonèených projektù",
       sum(case when (wfp."Kód stavu" like 'PP4%') then pzf."Celkové zdroje pøipadající na zpùsobilé výdaje"/1000000 END) AS "CZV v ukonèených (mil. Kè)",
       sum(case when (wfp."Kód stavu" like 'PP4%') then pzf."Pøíspìvek Unie"/1000000 END) AS "EU v ukonèených (mil. Kè)" ,
       sum(case when (wfp."Kód stavu" like 'PP4%') then pzf."Národní veøejné zdroje"/1000000 END) AS "NVZ v ukonèených (mil. Kè)"


FROM vyzva AS v
INNER JOIN ciselnik_stav_workflow AS vw ON vw.id = v.id_wfstav
LEFT JOIN projekt AS p ON p.id_vyzva = v.id and p."Registraèní èíslo projektu" is not null
LEFT JOIN stav_projektu_bez_z_stavu wfp ON wfp.id_projekt = p.id
LEFT JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN v_rav_umshisc sc on sc.id=op.id_hierarchie
INNER JOIN programova_linie prg ON prg.id = sc.id_osa
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
LEFT JOIN rozpis_financovani rf ON rf.id_platba = pl.id 
LEFT JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel AND cuk."Kód" = '7' -- øádek F1-C EU celkem
 
WHERE v.id_integnastr = 0 -- vyhazuje ven výzvy na ISg CLLD a ITI
AND vw."Název" <> 'Zru¹ená'


GROUP BY v."Èíslo výzvy", v."Název výzvy", v."Datum vyhlá¹ení výzvy", v."Datum ukonèení pøíjmu ¾ádostí o podporu", v."Datum zpøístupnìní ¾ádostí o podporu", v."Finanèní alokace výzvy (CZV)", vw."Kód", vw."Název", v."Druh výzvy",
       prg."Kód" , prg."Název", sc.kodnovy, sc.nazev, op.kodnovy, op.nazev
