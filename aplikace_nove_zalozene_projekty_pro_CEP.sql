-- CREATE VIEW vpo_aplikace_subjekt_2 FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/finanční_data/aplikace' AS
SELECT
    p.id AS id_projekt,
    p."Registrační číslo projektu",
    s."Název subjektu",
    s."IČ",
    cts."Název" AS "Typ subjektu",
    s.id_typsubjektuedit,
    vpo.eu,
    vpo.vlastni,
    vpo.zv,
    vpo.id_nositel AS id_subjekt,
    
    pzf."Příspěvek Unie",
    pzf."Národní veřejné zdroje",
    pzf."Soukromé zdroje",
    pzf."Příspěvek Unie + Národní spolufinancování" ,

    ROUND(roky.rok_2025/pzf."Příspěvek Unie + Národní spolufinancování", 2) procento_2025,
    ROUND(roky.rok_2026/pzf."Příspěvek Unie + Národní spolufinancování", 2) procento_2026,
    ROUND(roky.rok_2027/pzf."Příspěvek Unie + Národní spolufinancování", 2) procento_2027,
    ROUND(roky.rok_2028/pzf."Příspěvek Unie + Národní spolufinancování", 2) procento_2028,
    ROUND(roky.rok_2029/pzf."Příspěvek Unie + Národní spolufinancování", 2) procento_2029,
    ROUND(roky.rok_2030/pzf."Příspěvek Unie + Národní spolufinancování", 2) procento_2030,
    ROUND(roky.rok_2031/pzf."Příspěvek Unie + Národní spolufinancování", 2) procento_2031 ,

    (
    COALESCE(ROUND(roky.rok_2025/pzf."Příspěvek Unie + Národní spolufinancování", 2),0) +
    COALESCE(ROUND(roky.rok_2026/pzf."Příspěvek Unie + Národní spolufinancování", 2),0) +
    COALESCE(ROUND(roky.rok_2027/pzf."Příspěvek Unie + Národní spolufinancování", 2),0) +
    COALESCE(ROUND(roky.rok_2028/pzf."Příspěvek Unie + Národní spolufinancování", 2),0) +
    COALESCE(ROUND(roky.rok_2029/pzf."Příspěvek Unie + Národní spolufinancování", 2),0) +
    COALESCE(ROUND(roky.rok_2030/pzf."Příspěvek Unie + Národní spolufinancování", 2),0) +
    COALESCE(ROUND(roky.rok_2031/pzf."Příspěvek Unie + Národní spolufinancování", 2),0)
    ) * 100 AS soucet_procent

    
FROM projekt AS p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil 
INNER JOIN prehled_zdroju_financovani AS pzf ON (pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000011)
INNER JOIN subjekt AS s ON (s.id_prjgg = p.id AND s."Neplatný od" IS NULL AND s.id_typsubjektuedit IN (413462, 413467))
INNER JOIN ciselnik_typ_subjektu AS cts ON s.id_typsubjektuedit = cts.id
INNER JOIN (
    SELECT
        sum(verejna_podpora."Částka poskytnuté veřejné podpory celkem - Příspěvek Unie v Kč") AS eu,
        sum(verejna_podpora."Částka poskytnuté veřejné podpory celkem v Kč") AS zv,
        sum(verejna_podpora."Částka poskytnuté veřejné podpory celkem - Ostatní zdroje v Kč") AS vlastni,
        verejna_podpora.id_nositel
    FROM verejna_podpora
    WHERE "Platnost" = 'A'
    GROUP BY verejna_podpora.id_nositel
    ) AS vpo ON vpo.id_nositel = s.id
INNER JOIN (SELECT SUM(CASE WHEN FORMATDATE('yyyy', pl."Datum předložení") = 2025 THEN pl."Vyúčtování - plán" END) rok_2025 ,
      	   	   SUM(CASE WHEN FORMATDATE('yyyy', pl."Datum předložení") = 2026 THEN pl."Vyúčtování - plán" END) rok_2026 ,
 		   SUM(CASE WHEN FORMATDATE('yyyy', pl."Datum předložení") = 2027 THEN pl."Vyúčtování - plán" END) rok_2027 ,
 		   SUM(CASE WHEN FORMATDATE('yyyy', pl."Datum předložení") = 2028 THEN pl."Vyúčtování - plán" END) rok_2028 ,
 		   SUM(CASE WHEN FORMATDATE('yyyy', pl."Datum předložení") = 2029 THEN pl."Vyúčtování - plán" END) rok_2029 ,
 		   SUM(CASE WHEN FORMATDATE('yyyy', pl."Datum předložení") = 2030 THEN pl."Vyúčtování - plán" END) rok_2030 ,
 		   SUM(CASE WHEN FORMATDATE('yyyy', pl."Datum předložení") = 2031 THEN pl."Vyúčtování - plán" END) rok_2031 ,
		   pl.id_nositelplatby
      	    FROM platba pl 
	    -- WHERE pl.id_nositelplatby = 437975895
	    GROUP BY pl.id_nositelplatby
	    ) roky ON roky.id_nositelplatby = p.id 
-- WHERE p."Registrační číslo projektu" = 'CZ.01.01.01/01/24_063/0006507'
WHERE op."Název specifického cíle/opatření" = 'Aplikace'
