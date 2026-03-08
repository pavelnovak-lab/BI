-- CREATE OR replace VIEW subjekt_pravni_forma FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/subjekty' AS

SELECT op.nazev AS "Opatøení",
       p."Registraèní èíslo projektu",
       w."Kód" AS "Kód stavu",
       s."Název subjektu",
       s."IÈ",
       ts."Název" AS "Typ subjektu",
       pf."Právní forma",
       GROUP_CONCAT(vz."Názvy subjektù VZ") "Názvy subjektù VZ",
       GROUP_CONCAT(vz."IÈ subjektù VZ") "IÈ subjektù VZ",
       GROUP_CONCAT(vz."Typ subjektu") "Typ subjektu VZ"

FROM projekt AS p INNER JOIN vyzva AS v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie AS vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc AS op ON op.id = vh.id_speccil
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null -- AND s.id_typsubjektuedit IN (413462, 413467) -- ¾adatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 
INNER JOIN ciselnik_pravni_forma AS pf ON pf.id = s.id_hosppravforma
INNER JOIN ciselnik_stav_workflow AS w ON p.id_wfstav = w.id

LEFT JOIN (SELECT DISTINCT p.id id_projekt,
		  ts."Název" "Typ subjektu" ,
		  s."IÈ/rodné èíslo" "IÈ subjektù VZ",
		  s."Jméno a pøíjmení / Název" "Názvy subjektù VZ"
		  
	   FROM projekt p
	   INNER JOIN zakazka_projekt zp ON zp.id_projekt = p.id
	   INNER JOIN zakazka z ON z.id = zp.id_vz
	   INNER JOIN subjekt s ON s.id_prjgg = z.id AND s."Neplatný od" is null -- AND s.id_typsubjektuedit IN (413462, 413467) -- ¾adatel, partner s FP
	   INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit

	   WHERE p."Registraèní èíslo projektu" is not null ) vz ON vz.id_projekt = p.id

WHERE p."Registraèní èíslo projektu" IS NOT NULL
-- AND p."Registraèní èíslo projektu" IN ('CZ.01.04.01/01/22_006/0000001','CZ.01.01.01/02/22_003/0000175', 'CZ.01.01.01/01/22_002/0000334')

GROUP BY "Opatøení",
       p."Registraèní èíslo projektu",
       "Kód stavu",
       s."Název subjektu",
       s."IÈ",
       ts."Název",
       pf."Právní forma"

ORDER BY SUBSTR(p."Registraèní èíslo projektu",24)


----------------------------------------
SELECT p."Registraèní èíslo projektu" ,
       vz."Poøadové èíslo",
       vs.*
FROM projekt p 
INNER JOIN zakazka_projekt vzp ON vzp.id_projekt = p.id
INNER JOIN zakazka vz ON vz.id = vzp.id_vz
INNER JOIN zakazka_smlouva vzs ON vzs.id_vz = vz.id
INNER JOIN zakazka_dodavatel vzd ON vzd.id_smlouva = vzs.id
INNER JOIN verze_subjektu vs ON vzd.id_dodavatel = vs.id


WHERE vz.id = 325273777


----------------------------------------
SELECT p."Registraèní èíslo projektu" ,
       ts."Název" typ_subjektu
       s."IÈ/rodné èíslo",
       s."Jméno a pøíjmení / Název"
FROM projekt p
INNER JOIN zakazka_projekt zp ON zp.id_projekt = p.id
INNER JOIN zakazka z ON z.id = zp.id_vz
INNER JOIN subjekt s ON s.id_prjgg = z.id AND s."Neplatný od" is null -- AND s.id_typsubjektuedit IN (413462, 413467) -- ¾adatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 

WHERE p."Registraèní èíslo projektu" = 'CZ.01.01.01/02/22_003/0000175'
-- vs.id_verzesubjektu = 325282357
-- s.id_typsubjektuedit = 7534050
----------------------------------------
SELECT *

from subjekt

WHERE id = 156571878
