 -- create or replace view "KI_zivodni_prostredi_2" folder = '/06_Data_models/01_OP_TAK/MPO/novak-pavel/Projekty' as
SELECT	op.kodnovy "Kód ØO",
 	op.nazev AS "Opatøení",
	-- op.kod "Kód EU formát",
	-- v."Název výzvy" ,
	v."Èíslo výzvy",
	p."Registraèní èíslo projektu" ,
	p."Název projektu CZ" ,
	s."Název subjektu" "®adatel" ,
	w."Kód" "Kód stavu",
	
 	GROUP_CONCAT(ci."Kód") "Kód CZ NACE",
	GROUP_CONCAT(ci."Název") "Název CZ NACE",
	psc."Ménì rozvinutý region" "% MRR",
        psc."Pøechodové" "%PR" ,
	cki."Kód" "Kód KI",
        cki."Název" "Název KI",
	p."Datum prvního podání",
	sml."Datum uzavøení" "Datum RoPD",
	pf."Celkové zdroje pøipadající na zpùsobilé výdaje" "CZV" ,
	pf."Pøíspìvek Unie" "EU" ,
	pf."Pøíspìvek spoleèenství (% veøejných)" ,

	p."Pøedpokládané datum ukonèení",
	p."Skuteèné datum ukonèení",
        ki."Klimatické zmìny - indikativní alokace" "Klimatické zmìny - indikativní alokace" ,
        ki."Procentní podíl" "Procentní podíl této KI", 
	ki."Indikativní alokace" "Indikativní alokace této KI" ,
	zop.plan "Plánované ZV do 31.12. 2024",
	zop.plan * pf."Pøíspìvek spoleèenství (% veøejných)" AS  "Plánovaná EU podpora do 31.12.2024 "
	
FROM projekt p
INNER JOIN projekt_specificky_cil psc ON psc.id_prjgg = p.id
INNER JOIN subjekt s ON s.id_prjgg = p.id AND id_typsubjektuedit in (413462) -- 413467 zadatel, parnter s FP 
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie AS vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc AS op ON op.id = vh.id_speccil
INNER JOIN ciselnik_stav_workflow w ON w.id = p.id_wfstav
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 
INNER JOIN smlouva sml ON sml.id_nositelsml = p.id AND sml."Poøadí" = 1
LEFT JOIN projekt_cznace nace ON nace.id_projekt = p.id
LEFT JOIN ciselnik_cznace ci ON ci.id = nace.id_cznace
LEFT JOIN kategorie_intervenci_oblast_intervence ki ON ki.id_projekt = p.id
LEFT JOIN ciselnik_oblast_intervence cki ON cki.id = ki.id_ki
LEFT JOIN ( SELECT sum("pl.Vyúètování - plán") plan ,
     	    	   pl.id_nositelplatby
     FROM platba pl
     INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id  
     WHERE w."Kód" not in ('P10','P11','P12','P13','P13T','P14','P14T')
     AND pl."Datum pøedlo¾ení" < to_date('yyyy-MM-dd HH:mm:ss','2025-01-01 08:00:00')
     GROUP BY pl.id_nositelplatby
     ) zop ON pl.id_nositelplatby = p.id


WHERE (w."Kód" like 'PP3%' OR w."Kód" like 'PP4%' OR w."Kód" = 'PU30')
-- AND ( p."Pøedpokládané datum ukonèení" < to_date('yyyy-MM-dd HH:mm:ss','2025-01-01 08:00:00')
--     OR 
--       p."Skuteèné datum ukonèení" < to_date('yyyy-MM-dd HH:mm:ss','2025-01-01 08:00:00')
--     )
AND cki."Kód" IN ('029','030','038','039','040','043','046','047','048','049','050','052','053''054','064','075','076')
--AND  p."Registraèní èíslo projektu" = 'CZ.01.01.01/03/23_024/0002516'



GROUP BY op.kodnovy ,
 	op.nazev ,
	-- op.kod "Kód EU formát",
	-- v."Název výzvy" ,
	v."Èíslo výzvy",
	p."Registraèní èíslo projektu" ,
	p."Název projektu CZ" ,
	s."Název subjektu"  ,
	psc."Ménì rozvinutý region" ,
        psc."Pøechodové",
	p."Datum prvního podání",
	sml."Datum uzavøení" ,
	p."Pøedpokládané datum ukonèení",
	p."Skuteèné datum ukonèení",
	w."Kód" ,
	cki."Kód" ,
        cki."Název" ,
        ki."Klimatické zmìny - indikativní alokace",
        ki."Procentní podíl" , 
	ki."Indikativní alokace" ,
	pf."Celkové zdroje pøipadající na zpùsobilé výdaje" ,
	pf."Pøíspìvek Unie" ,
	pf."Pøíspìvek spoleèenství (% veøejných)" ,
	"Plánované ZV do 31.12. 2024",
	"Plánovaná EU podpora do 31.12.2024 "


ORDER BY op.nazev 
