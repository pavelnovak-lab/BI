CREATE or REPLACE view "tak-mpo-novak-projekty-rozpad-kategorie-reginonu" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Projekty' AS 
SELECT	op.nazev as "Opatøení" ,
	p."Registraèní èíslo projektu" ,
        w."Kód" "Kód stavu" ,
        psc."Pøechodové" ,
        psc."Ménì rozvinutý region",
       	CASE WHEN kr.maximum = psc."Pøechodové" THEN 'PR'
	     ELSE 'MRR' END AS "Kam s ním?"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN projekt_specificky_cil psc ON psc.id_prjgg = p.id
INNER JOIN (SELECT max(psc."Pøechodové" , psc."Ménì rozvinutý region") AS maximum,
      	   	   psc.id_prjgg id
    	    FROM projekt_specificky_cil psc
 	   ) kr ON kr.id = p.id 



WHERE p."Registraèní èíslo projektu" is not null

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC 




----------------------------------------

-- CREATE OR REPLACE VIEW "rozpracovano_v_iskp_SR_KR" FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/projekty/rozpracovane_v_iskp' AS
    SELECT v."Èíslo výzvy",
           p."Identifikace ¾ádosti (hash)",
           w."Kód",
           p."Datum zmìny stavu",
           s."Název subjektu" AS "®adatel",
           sr."Název skupiny rozpoètu",
           psc."Pøechodové",
           psc."Ménì rozvinutý region"
    FROM (
             (
                 (
                     (
                         (projekt AS p INNER JOIN vyzva AS v ON v.id = p.id_vyzva)
                         LEFT OUTER JOIN subjekt AS s
                             ON (s.id_prjgg = p.id AND s."Neplatný od" IS NULL)
                     )
                     INNER JOIN ciselnik_stav_workflow AS w
                         ON p.id_wfstav = w.id
                 )
                 LEFT OUTER JOIN rozpocet_hlavicka AS hr
                     ON hr.id_nrozpocet = p.id
             )
             LEFT OUTER JOIN rozpocet_skupina AS sr
                 ON hr.id_skupina = sr.id
         )
         INNER JOIN projekt_specificky_cil AS psc
             ON psc.id_prjgg = p.id
	 LEFT JOIN rozpocet_polozka rp ON rp.id_hlavicka = rh.id
	 
    WHERE v."Èíslo výzvy" = '01_24_042' 
    AND p."Registraèní èíslo projektu" is null
    CONTEXT ('formatted' = 'yes');

