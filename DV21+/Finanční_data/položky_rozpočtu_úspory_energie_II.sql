-- CREATE VIEW "tak-novak-dotace-na-polo¾ce-rozpoètu-rozpad-na-partnery" FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/finanèní_data' AS
SELECT --v."Èíslo výzvy",
       -- v."Název výzvy",
       
       p."Registraèní èíslo projektu",
       -- s."IÈ",
       -- s."Název subjektu",
       w."Kód" AS "Kód stavu",
       -- pr."Kód",
       -- pr."Název",
       -- pr."Èástka celkem"
       -- rsp."Název",
       GROUP_CONCAT(vpo."Název") "VPo",
       sum(pr."Èástka celkem") ,
       count(vpo.id) "Poèet VPo"        
FROM projekt AS p
INNER JOIN subjekt AS s ON (s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462)
INNER JOIN ciselnik_stav_workflow AS w ON p.id_wfstav = w.id
INNER JOIN vyzva AS v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN rozpocet_hlavicka AS hr ON hr.id_nrozpocet = p.id
INNER JOIN rozpocet_skupina sk ON sk.id = hr.id_skupina
INNER JOIN rozpocet_skupina_polozka rsp ON rsp.id_predpis = sk.id

INNER JOIN ciselnik_kombinace_verejne_podpory vpo ON rsp.id_verejnapodpora = vpo.id

INNER JOIN rozpocet_hlavicka AS hrp ON hrp.id_nrozpocet = p.id
INNER JOIN rozpocet_polozka AS pr ON pr.id_hlavicka = hr.id AND pr.id_rozpis = rsp.id


WHERE 
 hr."Aktuální" = 'A'
 -- AND w."Kód" NOT LIKE 'PN%'
 AND p."Registraèní èíslo projektu" IS NOT NULL
 -- AND op.nazev = 'Certifikace produktù'
 AND v."Èíslo výzvy" = '01_24_049'
 -- AND pr."Název" LIKE 'Certifikace produktù'
 AND w."Kód" not like 'PN%'
 AND pr."Èástka celkem" > 0
 AND p."Registraèní èíslo projektu" = 'CZ.01.04.01/01/24_049/0007612'


GROUP BY        p."Registraèní èíslo projektu",
       -- s."IÈ",
       -- s."Název subjektu",
       w."Kód" 
       -- pr."Kód",



ORDER BY "Poèet VPo" desc

