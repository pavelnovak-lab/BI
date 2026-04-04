
CREATE VIEW "Stav_vyzev" FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/vyzvy' AS

SELECT v."Číslo výzvy",
       v."Název výzvy",
       	prg."Kód" AS "Kód Priority",
	prg."Název" AS "Priorita",
	sc.kod AS "Kód SC", sc.nazev AS "SC",
	op.kod AS "Kód Opatření", op.nazev AS "Opatření", v."Datum vyhlášení výzvy", v."Datum ukončení příjmu žádostí o podporu", v."Datum zpřístupnění žádostí o podporu", v."Finanční alokace výzvy (CZV)", vw."Kód", vw."Název", case WHEN (v."Druh výzvy" = 0) THEN 'Kolová' WHEN (v."Druh výzvy" = 1) THEN 'Průběžná' END AS "Druh výzvy",
	count(case WHEN (pw."Kód" in ('PP20', 'PP22', 'PU22a', 'PP23a', 'PP23b')) THEN 1 END) AS "Projektů před VK", sum(case WHEN (pw."Kód" in ('PP20', 'PP22', 'PU22a', 'PP23a', 'PP23b')) THEN pzf."Celkové zdroje připadající na způsobilé výdaje" END) AS "CZV před VK",
	sum(case WHEN (pw."Kód" in ('PP20', 'PP22', 'PU22a', 'PP23a', 'PP23b')) THEN pzf."Příspěvek Unie" END) AS "EU před VK",
	sum(case WHEN (pw."Kód" in ('PP20', 'PP22', 'PU22a', 'PP23a', 'PP23b')) THEN pzf."Národní veřejné zdroje" END) AS "NVZ před VK",
	count(case WHEN (pw."Kód" in ('PU25')) THEN 1 END) AS "Projektů v PU25",
	sum(case WHEN (pw."Kód" in ('PU25')) THEN pzf."Celkové zdroje připadající na způsobilé výdaje" END) AS "CZV v PU25",
	sum(case WHEN (pw."Kód" in ('PU25')) THEN pzf."Příspěvek Unie" END) AS "EU v PU25",
	sum(case WHEN (pw."Kód" in ('PU25')) THEN pzf."Národní veřejné zdroje" END) AS "NVZ v PU25", count(case WHEN (pw."Kód" in ('PP25a', 'PP25b', 'PU26', 'PP26')) THEN 1 END) AS "Projektů po VK před RoPD", sum(case WHEN (pw."Kód" in ('PP25a', 'PP25b', 'PU26', 'PP26')) THEN pzf."Celkové zdroje připadající na způsobilé výdaje" END) AS "CZV po VK před RoPD", sum(case WHEN (pw."Kód" in ('PP25a', 'PP25b', 'PU26', 'PP26')) THEN pzf."Příspěvek Unie" END) AS "EU po VK před RoPD", sum(case WHEN (pw."Kód" in ('PP25a', 'PP25b', 'PU26', 'PP26')) THEN pzf."Národní veřejné zdroje" END) AS "NVZ po VK před RoPD", count(case WHEN ((pw."Kód" like 'PP3%' OR pw."Kód" like 'PP4%')) THEN 1 END) AS "Projektů s RoPD", sum(case WHEN ((pw."Kód" like 'PP3%' OR pw."Kód" like 'PP4%')) THEN pzf."Celkové zdroje připadající na způsobilé výdaje" END) AS "CZV s RoPD", sum(case WHEN ((pw."Kód" like 'PP3%' OR pw."Kód" like 'PP4%')) THEN pzf."Příspěvek Unie" END) AS "EU s RoPD", sum(case WHEN ((pw."Kód" like 'PP3%' OR pw."Kód" like 'PP4%')) THEN pzf."Národní veřejné zdroje" END) AS "NVZ s RoPD" FROM (((((((vyzva AS v INNER JOIN ciselnik_stav_workflow AS vw ON vw.id = v.id_wfstav ) LEFT OUTER JOIN projekt AS p ON (p.id_vyzva = v.id AND p."Registrační číslo projektu" is not null ) ) LEFT OUTER JOIN ciselnik_stav_workflow AS pw ON pw.id = p.id_wfstav ) LEFT OUTER JOIN prehled_zdroju_financovani AS pzf ON (pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005) ) INNER JOIN vyzva_hierarchie AS vh ON vh.id_vyzva = v.id ) INNER JOIN v_rav_umshisc AS op ON op.id = vh.id_speccil ) INNER JOIN v_rav_umshisc AS sc ON sc.id = op.id_hierarchie ) INNER JOIN programova_linie AS prg ON prg.id = sc.id_osa  WHERE (v.id_integnastr = 0 AND vw."Název" <> 'Zrušená') GROUP BY v."Číslo výzvy", v."Název výzvy", v."Datum vyhlášení výzvy", v."Datum ukončení příjmu žádostí o podporu", v."Datum zpřístupnění žádostí o podporu", v."Finanční alokace výzvy (CZV)", vw."Kód", vw."Název", v."Druh výzvy", prg."Kód", prg."Název", sc.kod, sc.nazev, op.kod, op.nazev;

