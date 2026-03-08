SELECT projekt."Registrační číslo projektu" AS "Registrační číslo projektu",
       subjekt."IČ" AS "IČ",
       subjekt."Název subjektu" AS "Název subjektu",
       ciselnik_typ_subjektu."Název" AS "Název typu subjektu",
       MAX(prehled_zdroju_financovani."Celkové zdroje připadající na způsobilé výdaje") AS "CZV (Celý projekt)",
       MAX(prehled_zdroju_financovani."Příspěvek Unie") AS "Příspěvek EU (celý projekt)",
       SUM(verejna_podpora."Částka poskytnuté veřejné podpory celkem v Kč" ) AS "Součet Částka poskytnuté VP celkem v Kč",
       SUM(verejna_podpora."Částka veřejné podpory\n (CZK, dotační zdroje)" ) AS "Součet Částka veřejné podpory (CZK, dotační zdroje)",
       MAX(verze_adresy."Název kraj") AS "Název kraj",

       CASE
	   WHEN MAX(verze_adresy."Název kraj") IN ('Plzeňský kraj', 'Středočeský kraj', 'Kraj Vysočina', 'Jihočeský kraj', 'Jihomoravský kraj') THEN 'PR'
	   ELSE 'MRR'
       END AS "Kategorie" 

FROM vyzva
INNER JOIN projekt ON vyzva.id = projekt.id_vyzva
INNER JOIN subjekt ON projekt.id = subjekt.id_prjgg
INNER JOIN ciselnik_typ_subjektu ON subjekt.id_typsubjektuedit = ciselnik_typ_subjektu.id
INNER JOIN prehled_zdroju_financovani ON projekt.id = prehled_zdroju_financovani.id_projekt
INNER JOIN verejna_podpora ON (projekt.id = verejna_podpora.id_projekt AND subjekt.id = verejna_podpora.id_nositel)
INNER JOIN verze_adresy ON subjekt.id = verze_adresy.id_verzesubjektu

WHERE verze_adresy."Typ adresy" like '%Adresa místa realizace%'
AND projekt."Registrační číslo projektu" = 'CZ.01.01.01/01/22_002/0001035'
AND ciselnik_typ_subjektu."Kód" IN ('20', '21') -- žadatel a partner s FP
AND prehled_zdroju_financovani.id_faze = '99991000000000005' -- aktuální stav


GROUP BY
    vyzva."Název výzvy",
    projekt."Registrační číslo projektu",
    subjekt."IČ",
    subjekt."Název subjektu",
    ciselnik_typ_subjektu."Název"
ORDER BY
    "Registrační číslo projektu" ASC,
    "IČ" ASC;

----------------------------------------
-- CREATE or REPLACE view "Aplikace_rozpad_financi_na_partnery" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Subjekty' AS	
SELECT v."Název výzvy",
       v."Číslo výzvy",
       p."Registrační číslo projektu" ,
       w."Kód" "Stav projektu" ,
       pf."Celkové zdroje připadající na způsobilé výdaje" "CZV projekt" ,
       pf."Příspěvek Unie" "EU projekt",
       pf."Příspěvek společenství (% veřejných)" "% EU projekt",
       subj."Název subjektu",
       subj."IČ",
       CASE WHEN subj.id_typsubjektuedit = (413462) THEN 'Žadatel'
       	    WHEN subj.id_typsubjektuedit = 413467 THEN 'Partner'
 	    END "Žadatel / partner",
       CASE WHEN vpo."CZV" = 0 THEN 'Ne'
       	    WHEN round(100 * vpo."EU"/vpo."CZV",0) = 85 THEN 'Ano'
	    ELSE 'Ne' END "Výzkumná org.",
       vpo."CZV" "ZV subjekt",
       vpo."EU" "EU subjekt",
       ROUND(CASE WHEN vpo."CZV" = 0 THEN pf."Příspěvek společenství (% veřejných)"
       	    ELSE 100 * vpo."EU"/vpo."CZV"
	    END,2) "% EU subjekt",
       subj."Název kraj" "Kraj",
       subj."KR"

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil 
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 
INNER JOIN ( -- vnořený SELECT kvůli ošetření duplicit adres realizace, místo číslování by se dalo vytáhnout MIN(adr.id)
       SELECT  ROW_NUMBER() OVER (PARTITION BY s.id ORDER BY adr.id ASC) AS "Pořadí záznamu" ,
	       s."Název subjektu",
	       s."IČ",
	       s.id,
	       s.id_typsubjektuedit,
	       s.id_prjgg,
	       adr."Název kraj",
	       CASE WHEN adr."Název kraj" IN ('Plzeňský kraj', 'Středočeský kraj', 'Kraj Vysočina', 'Jihočeský kraj', 'Jihomoravský kraj') THEN 'PR'
		    WHEN adr."Název kraj" IN ('Karlovarský kraj', 'Ústecký kraj', 'Liberecký kraj', 'Královéhradecký kraj', 'Pardubický kraj', 'Olomoucký kraj', 'Zlínský kraj', 'Moravskoslezský kraj') THEN 'MRR'
		    WHEN adr."Název kraj" = 'Hlavní město Praha' THEN 'VRR'
		    ELSE NULL END AS "KR"
       FROM subjekt s -- ON s.id_prjgg = p.id 
       INNER JOIN verze_adresy adr  ON s.id = adr.id_verzesubjektu  
       WHERE adr."Typ adresy" like '%Adresa místa realizace%'
       AND s."Neplatný od" is null
       AND s.id_typsubjektuedit IN (413462, 413467) -- žadatel, partner s FP
       AND adr."Neplatný záznam adresy" is null 
       	   ) subj ON subj.id_prjgg = p.id 
INNER JOIN ( -- pro přehlednost vpo mimo hlavní dotaz
      SELECT id_projekt,
      	     id_nositel,
	     SUM("Částka poskytnuté veřejné podpory celkem v Kč" ) AS "CZV",
	     SUM("Částka veřejné podpory\n (CZK, dotační zdroje)" ) AS "EU"
      FROM verejna_podpora
      WHERE "Platnost" = 'A'
      GROUP BY id_projekt,
      	       id_nositel
           ) vpo ON (p.id = vpo.id_projekt AND subj.id = vpo.id_nositel)

WHERE subj."Pořadí záznamu" = 1
AND p.id IN (68643484, 75974570)
AND p."Registrační číslo projektu" is not null 
AND op."Název specifického cíle/opatření" = 'Aplikace'
ORDER BY v."Číslo výzvy" , p."Registrační číslo projektu", "Žadatel / partner" DESC


