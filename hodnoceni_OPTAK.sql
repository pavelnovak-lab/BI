-- CREATE or REPLACE view "Informace_o_posudcích" FOLDER= AS 
SELECT p."Registraèní èíslo projektu" ,
       op.nazev as "Opatøení" ,
       w."Kód" "WF stav",       
       null hodnotitel ,
       h."Výsledek (v bodech)" ,
       h."Arbitr" ,
       h."Datum finalizace" "Datum hodnocení",
       null schvalovatel,
       h."Schváleno schvalovatelem",
       h."Datum schválení" ,
       hdntl."Interní hodnotitel" ,
       cis."Fáze hodnocení" ,
       hdntl."Kód u¾ivatele" kod_hodnotitele,
       cisk.*
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id 
INNER JOIN hodnotitel hdntl ON hdntl.id = h.id_hodnotitel
INNER JOIN ciselnik_faze_hodnoceni cis ON cis.id = h.id_druhhodn 
INNER JOIN ciselnik_krok_vecneho_hodnoceni cisk ON cisk.id = h.id_krokvechodn
INNER JOIN soubor_kriterii_vyzvy skv ON skv.id_vyzva = v.id AND skv."Poèet hodnotitelù" = 2 AND skv."Platnost do" is null

WHERE h.id_kolohodnoceni= 488844 -- 171212   /* hodnocení "ostré" ¾ádosti */
AND h."Platný" = 'A'
-- Posudek je¹tì nemusí být schválený
-- AND	(h.SchvalenoSchval = 'N' OR sch.SchvalenoSchval = 'N' OR (h.SchvalenoSchval is null) OR (sch.SchvalenoSchval is null ) )
AND h."Opravný posudek" = 'N'
AND h."Finalizováno" = 'A'
AND h.id_souborkrit = skv.id_souborkrit
AND p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000011'

ORDER BY p."Registraèní èíslo projektu" , cis."Fáze hodnocení"


----------------------------------------
SELECT 	p."Registraèní èíslo projektu" ,
 	SUBSTR( p.kompetencniutvar, 10 ) AS "Program podpory", 
	p.kodwfstav,
	h.pocetbodu,
	h.arbiter,
	h.schvalenoschval, /* Pozor, h.schvalenoschval se v¹ude nerovná sch.schvalenoschval */
	-- h.datumhodnoceni, /* Tøeba jednou budu vìdìt, v èem se tyto dva atributy li¹í... */
	-- h.datumhodn,
	NVL(h.datum_finalizace,h.datumhodnoceni) AS "Datum hodnocení", /* Existují prj, kde není h.datum_finalizace vyplnìno, tam pøiøazuji h.datumhodnoceni */
	sch.Last_Modif_Uzivatel AS Schvalovatel, /* Bohu¾el nevím odkud jinud */
	h.Create_uzivatel AS Hodnotitel,
-- 	sch.DatumSchval, /* Existují schválené posudky, kde není DatumSchval vyplnìno, proto následující podmínka. */
	(CASE WHEN (sch.schvalenoschval = 'A' AND sch.DatumSchval is null)
	 THEN sch.Last_Modif_cas
	 ELSE sch.DatumSchval  END) AS "Datum schválení", /* Tam, kde není schváleno bude prázdné pole */

	 (CASE WHEN LENGTH(h.CREATE_UZIVATEL)>7
	 THEN 'EH'
	 ELSE 'IH'  END) AS "EH / IH" ,

	 cis.zkratkacz "Druh hodnocení"	 

	 

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
INNER JOIN isum.v_bi_UmvHodnSchvaleni sch ON h.id=sch.id_hodnoceni
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.V_BI_UMVHodnDruhCis cis ON cis.id = h.id_druhhodn



WHERE
p."Registraèní èíslo projektu" is not null
AND	p.kodwfstav not in ('PP20','Z1','Z2','Z3','PN21','PN22')
AND 	p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.5','31.26')
AND 	h.id_kolohodnoceni=171212   /* hodnocení "ostré" ¾ádosti */
-- Po konzultaci je povolen i arbitr, check má hodnotu buï A nebo N, OR je tu zbyteèné
-- AND 	(h.arbiter = 'N' OR h.arbiter = 'A')
AND	h.platnost = 'A'
-- Posudek je¹tì nemusí být schválený
-- AND	(h.SchvalenoSchval = 'N' OR sch.SchvalenoSchval = 'N' OR (h.SchvalenoSchval is null) OR (sch.SchvalenoSchval is null ) )
AND 	h.OpravneHodnoceni = 'N'
AND	h.finalizovano = 'A'
