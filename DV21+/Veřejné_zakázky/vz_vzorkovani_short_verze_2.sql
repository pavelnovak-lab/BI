-- CREATE or REPLACE view prehled_vz_pro_vzorkovani_short_2 FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/VZ' AS 

SELECT  op."Název specifického cíle/opatření" as "Opatření",
	op."Číslo SC/opatření ŘO formát" "ŘO kód opatření",
	v."Číslo výzvy", 	
	p."Registrační číslo projektu",
	w."Kód" "Kód stavu" ,
	s."Název subjektu" "Žadatel/zadavatel" ,
	s."IČ" ,
	pf."Celkové zdroje připadající na způsobilé výdaje" "CZV projektu (Kč)" ,
	pf."Příspěvek Unie" "EU dotace projektu (Kč)",
 	p."Evidován v BL",
	-- pa."IČ" "IČ poradenské agentury",
	-- pa."Název" "Název poradenské agentury",
        -- pocetvz."Počet VZ na projektu" "Počet VZ na projektu" ,
        -- pocetvz."Krácených VZ na projektu",

	-- kraceniprjvz.pocet "Krácených VZ na proj",

	z."Pořadové číslo" "Číslo VZ",
	-- z."Název veřejné zakázky",
	poradivzprj.pz "Pořadí VZ na projektu (včetně zrušených)",

	dosud_kracenych_vz.pocet "Počet VZ s krácením (na projektu)",     
	pocetzp.pocet "Počet VZ na projektu (včetně zrušených)",

	CASE WHEN kraceni.pocet is not null THEN 100*(dosud_kracenych_vz.pocet)/pocetzp.pocet
	     ELSE 0 END "% krácených VZ na projektu (včetně této)" ,



	-- v Aplikaci je plnění měny podmínečně povinné s podmínkou  (VZStav.Kod in ['ZAHA','ZADA','SPLN','NESP','PZAD']) OR JeZMV=True
	-- pokud je nevyplněno zakazka.id = 0 a nelze JOINovat s ciselnik_mena, v případě exotické měny nechávám prázdné



	z."Částka způsobilých výdajů předpokládané hodnoty veřejné zakázky bez DPH" ,



	-- zp."Bez DPH - nezpůsobilé výdaje" ,
    	-- zp."Předpokládaná hodnota veřejné zakázky/nbez DPH vážící se k projektu" AS "Předpokládaná hodnota veřejné zakázky (vazba na projekt)",
	-- zp."Částka ceny veřejné zakázky/nvážící se k projektu bez DPH" AS "Částka ceny veřejné zakázky (vazba na projekt)",
    	-- zp."Skutečně uhrazená cena vážící se k projektu bez DPH – způsobilé výdaje" AS "Skutečně uhrazená cena ZV (vazba na projekt)",
	
    	-- zp."Předpokládaná hodnota veřejné zakázky/nbez DPH vážící se k projektu" - zp."Skutečně uhrazená cena vážící se k projektu bez DPH – způsobilé výdaje" AS "Rozdíl předpoklad - uhrazeno (vazba na projekt)",
	
	-- (zp."Předpokládaná hodnota veřejné zakázky/nbez DPH vážící se k projektu" - zp."Skutečně uhrazená cena vážící se k projektu bez DPH – způsobilé výdaje")/zp."Předpokládaná hodnota veřejné zakázky/nbez DPH vážící se k projektu"*100 AS "O kolik % se liší uhrazená od předpokládané (vazba na projekt)", 	


	CASE WHEN z.id_mena = 279658 THEN 'EUR'
 	     WHEN z.id_mena = 279648 THEN 'CZK'
	     ELSE 'jiná' END "Měna",

	     
 	eurczk."Předpokládaná hodnota VZ bez DPH v Kč",
	eurczk.kurz, 

	z."Datum zahájení zadávacího/výběrového řízení" "Datum zahájení VŘ",
	-- CASE WHEN z."Hash VZ" IS NULL THEN 'podtyp'
    	--      WHEN z."Hash podtypu" IS NULL THEN CAST(podtyp.pocet_podtypu AS varchar(1))
	--      ELSE null END "Počet podtypů / podtyp",

	-- zp."Předpokládaná hodnota veřejné zakázky/nbez DPH vážící se k projektu", 
	-- zp."Částka ceny veřejné zakázky/nvážící se k projektu bez DPH",
	-- zp."Skutečně uhrazená cena vážící se k projektu bez DPH – způsobilé výdaje",
	zp."Datum uhrazení" ,
	-- sml.pocet "Počet smluv",
	kraceni.pocet "Počet sankcí na této VZ" ,
 	kraceni.kateg "Kategorizace krácení",
	kraceni.max_proc "Max % krácení na této VZ",
	kraceni.f1 "Dopad některé sankce na ŽoP",



	-- dod.pocet "Počet dodavatelů",
 	-- dod."Názvy dodavatelů",
	-- dod."IČ dodavatelů",
	-- dod."Zahraniční IČ dodavatelů",
	-- stav."Název" "Adm. stav",
	rez."Název" "Režim",
	typ."Název" "Typ",
	druh."Název" "Druh VŘ",
	st."Název" "Stav",
	-- poc.projektu "Navázaných projektů" ,
	CASE WHEN z.id_vzpredmet = 282518 THEN 'Dodávky'
	     WHEN z.id_vzpredmet = 282528 THEN 'Stavební práce'
	     WHEN z.id_vzpredmet = 282523 THEN 'Služby'
	     WHEN z.id_vzpredmet IS NULL THEN NULL
	     ELSE 'Jiný' END "Předmět",
	-- hs.pocet "Kolikrát ve stavu Podaná",
 	z."Znovu vyhlášená veřejná zakázka",
	-- z."Podnět na ÚOHS",
	-- z."Sdružení zadavatelů" ,

 	k."Číslo kontroly",
 	k."Stav AdO",
 	k."Datum zahájení kontroly",
 	k."Datum ukončení kontroly",
 	k."Zkontrolované fáze VZ",
 	-- k."Kód zjištění",
 	k."Název zjištění" ,
	k."Výsledek kontroly"
	-- platba.datumzopl "Plánované datum předložení",
	-- platba.pocetzop "Počet ŽoP projektu",
	-- platba.poradizop "Pořadí ŽoP ve stavu P4 a nižším",
 	-- platba.kodwfzop "Kód první neschválené ŽoP"


FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil
-- LEFT JOIN (SELECT max(pl."Pořadí finančního plánu") pocetzop,
--       	   	   pl.id_nositelplatby,
-- 		   min(CASE WHEN wpl."Kód" NOT IN ('P5','P5T','P6','P6T','P7','P8','P8T','P9','P9T','P10','P11','P12','P13T','P14','P14T') THEN pl."Pořadí finančního plánu"
--  		   ELSE NULL END) poradizop ,
-- 		   min(CASE WHEN wpl."Kód" NOT IN ('P5','P5T','P6','P6T','P7','P8','P8T','P9','P9T','P10','P11','P12','P13T','P14','P14T') THEN pl."Datum předložení"
--  		   ELSE NULL END) datumzopl,
-- 		   max(CASE WHEN wpl."Kód" NOT IN ('P5','P5T','P6','P6T','P7','P8','P8T','P9','P9T','P10','P11','P12','P13T','P14','P14T') THEN wpl."Kód" 
--  		   ELSE NULL END) kodwfzop
-- 	   FROM platba pl
-- 	   INNER JOIN ciselnik_stav_workflow wpl ON pl.id_wfstav = wpl.id
-- 	   WHERE pl."Součtový řádek" is null 
-- 	   GROUP BY pl.id_nositelplatby) platba ON platba.id_nositelplatby = p.id


INNER JOIN zakazka_projekt zp ON zp.id_projekt = p.id AND zp."Platné přiřazení" = 'A'
INNER JOIN (SELECT count(id) pocet,
	           id_projekt
	    FROM zakazka_projekt
	    WHERE "Platné přiřazení" = 'A'
	    GROUP BY id_projekt) pocetzp ON pocetzp.id_projekt = p.id  

INNER JOIN (SELECT ROW_NUMBER() OVER (PARTITION BY zp.id_projekt ORDER BY zp.id ) pz,
	           zp.id,
		   zp.id_projekt
	    FROM zakazka_projekt zp
	    -- INNER JOIN zakazka z ON z.id = zp.id_vz
	    WHERE "Platné přiřazení" = 'A'
	    ) poradivzprj ON poradivzprj.id = zp.id  



INNER JOIN zakazka z ON zp.id_vz = z.id
INNER JOIN ciselnik_typ_kontraktu_zadavaciho_vyberoveho_rizeni typ on typ.id = z.id_vztyp
INNER JOIN ciselnik_rezim_verejne_zakazky rez on rez.id = z.id_vzrezim
-- INNER JOIN ciselnik_stav_administrace_verejne_zakazky stav on stav.id = z.id_admstav
INNER JOIN ciselnik_druh_zadavaciho_vyberoveho_rizeni druh on druh.id = z.id_vzdruh
INNER JOIN ciselnik_stav_verejne_zakazky st on st.id = z.id_vzstav -- AND st."Název" <> 'Zrušena' 
-- Počet průchodů stavem Podána
-- INNER JOIN (SELECT id_vz,
-- 		   count(id) pocet 
--       	    FROM zakazka_historie_stavu
-- 	    WHERE id_stavdo = 400083 -- stav Podaná
-- 	    GROUP BY id_vz) hs ON hs.id_vz = z.id
-- Počet projektů na VZ
-- INNER JOIN (SELECT count(zp.id_projekt) projektu,
--       	   	   zp.id_vz   
-- 	    FROM zakazka_projekt zp
-- 	    GROUP BY zp.id_vz) poc ON poc.id_vz = z.id
-- počítám počet podtypů VZ
LEFT JOIN (SELECT VZ.id ,
     	  	  VZ."Hash VZ", -- Hash hlavní zakázky, který identifikuje skupinu podtypů
    		  COUNT(Podtyp."Hash podtypu") AS pocet_podtypu
	   FROM zakazka VZ -- VZ je alias pro hlavní zakázky
	   INNER JOIN zakazka Podtyp ON 
	   -- Spojovací podmínka: Hash podtypu podtypu musí začínat Hash VZ hlavní zakázky
           Podtyp."Hash podtypu" LIKE VZ."Hash VZ"||'%' AND
           -- A zároveň musí být vyplněný Hash podtypu u podtypu
           (Podtyp."Hash podtypu" IS NOT NULL ) AND
           -- A Hash VZ u podtypu musí být prázdný
           (Podtyp."Hash VZ" IS NULL )
	   WHERE
           -- Podmínky pro identifikaci hlavní zakázky
       	   (VZ."Hash podtypu" IS NULL ) AND
    	   (VZ."Hash VZ" IS NOT NULL)
	   GROUP BY VZ.id, VZ."Hash VZ") podtyp ON podtyp.id = z.id

-- LEFT JOIN (SELECT id_vzprj,
--      	  	  count(id) pocet
-- 	   FROM zakazka_smlouva_projekt
-- 	   GROUP BY id_vzprj) sml ON sml.id_vzprj = zp.id 
-- Počet krácení na této zakázce
LEFT JOIN (SELECT GROUP_CONCAT(DISTINCT '; ', ckp."Název") kateg ,
     	   	  max(kr."Procento sankce (celkové)") max_proc, 
 		  max(kr."Dopad na F1") f1,
		  count(kr.id) pocet,
		  kr.id_vzprj
		  -- zp.id_projekt
	   FROM zakazka_sankcni_kraceni kr
	   -- INNER JOIN zakazka_projekt zp ON zp.id = kr.id_vzprj
	   INNER JOIN ciselnik_kategorizace_poruseni ckp ON ckp.id = kr.id_kategporuseni
	   -- WHERE kr.id_vzprj = 171647290
	   GROUP BY kr.id_vzprj ) kraceni ON kraceni.id_vzprj = zp.id
-- počet krácených VZ na projektu
LEFT JOIN (SELECT count(DISTINCT kr.id_vzprj) pocet ,
		  zp.id_projekt
	   FROM zakazka_projekt zp
	   INNER JOIN zakazka_sankcni_kraceni kr ON zp.id = kr.id_vzprj AND zp."Platné přiřazení" = 'A'
	   GROUP BY zp.id_projekt) dosud_kracenych_vz ON dosud_kracenych_vz.id_projekt = p.id 

-- dodavatelé VZ
-- LEFT JOIN (SELECT GROUP_CONCAT( vs."IČ") "IČ dodavatelů",
--      	  	  GROUP_CONCAT(DISTINCT '; ', vs."IČ zahraniční") "Zahraniční IČ dodavatelů",
--      	  	  GROUP_CONCAT( vs."Název subjektu") "Názvy dodavatelů",
-- 		  count(d.id) pocet,
-- 		  sml.id_vzprj
--      	   FROM zakazka_smlouva_projekt sml 
-- 	   INNER JOIN zakazka_dodavatel d ON d.id_smlouva = sml.id_smlouva
-- 	   INNER JOIN verze_subjektu vs ON vs.id = d.id_dodavatel
-- 	   GROUP BY sml.id_vzprj) dod ON dod.id_vzprj = zp.id 
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null AND s.id_typsubjektuedit IN (413462) -- žadatel
-- INNER JOIN ciselnik_velikost_podniku AS vp ON vp.id = s.id_velikostpodniku
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 
-- INNER JOIN ciselnik_pravni_forma prf ON prf.id = s.id_hosppravforma 
-- poradenské agentury
-- LEFT JOIN ( SELECT group_concat(subjekt."IČ") AS "IČ",
--      	    	   group_concat(subjekt."Název subjektu") AS "Název",
-- 		   subjekt.id_prjgg
-- 	    FROM subjekt
-- 	    WHERE ("Neplatný od" IS NULL AND id_typsubjektuedit = 413437)
-- 	    GROUP BY subjekt.id_prjgg ) AS pa ON pa.id_prjgg = p.id

INNER JOIN (SELECT k."Číslo kontroly" "Číslo kontroly",
		  wvz."Název"  "Stav AdO",
		  k."Datum ukončení kontroly" "Datum ukončení kontroly",
		  k."Datum zahájení kontroly" "Datum zahájení kontroly",
		  k."Zkontrolované fáze VZ" "Zkontrolované fáze VZ",
		  CASE WHEN k."Ukončení kontroly" = 0 THEN 'Se zjištěním'
			     WHEN k."Ukončení kontroly" = 1 THEN 'Bez zjištění'
			     ELSE null END "Výsledek kontroly",
		  cpk."Kód" "Kód zjištění",
		  cpk."Název"   "Název zjištění" ,
		  k.id_nositelkontroly
     	  FROM kontrola k 
	  INNER JOIN ciselnik_stav_workflow wvz ON k.id_wfstav = wvz.id 
	  LEFT JOIN ciselnik_mira_zavaznosti_zjisteni mz ON k.id_mirazavaznosti = mz.id
	  LEFT JOIN ciselnik_podrobnosti_k_ukonceni_kontroly_se_zjistenim cpk ON cpk.id = k.id_ukonkontr AND k.id_ukonkontr > 0
	  INNER JOIN ciselnik_kontrolni_organ ko ON ko.id = k.id_kontrorgan

	  WHERE ko."Organizační jednotka" = 'Oddělení kontrol výběrových řízení'

	  -- GROUP BY k.id_nositelkontroly
	  ) k ON k.id_nositelkontroly = z.id

-- INNER JOIN (SELECT GROUP_CONCAT(DISTINCT '; ',  k."Číslo kontroly") "Číslo kontroly",
-- 		  GROUP_CONCAT(DISTINCT '; ',  wvz."Název")  "Stav AdO",
-- 		  GROUP_CONCAT(DISTINCT '; ',  k."Datum ukončení kontroly") "Datum ukončení kontroly",
-- 		  GROUP_CONCAT(DISTINCT '; ',  k."Datum zahájení kontroly") "Datum zahájení kontroly",
-- 		  GROUP_CONCAT(DISTINCT '; ',  k."Zkontrolované fáze VZ") "Zkontrolované fáze VZ",
-- 		  GROUP_CONCAT(DISTINCT '; ',
-- 		  	CASE WHEN k."Ukončení kontroly" = 0 THEN 'Se zjištěním'
-- 			     WHEN k."Ukončení kontroly" = 1 THEN 'Bez zjištění'
-- 			     ELSE null END) "Výsledek kontroly",
-- 		  GROUP_CONCAT(DISTINCT '; ',  cpk."Kód") "Kód zjištění",
-- 		  GROUP_CONCAT(DISTINCT '; ',  cpk."Název"  ) "Název zjištění" ,
-- 		  k.id_nositelkontroly
--      	  FROM kontrola k 
-- 	  INNER JOIN ciselnik_stav_workflow wvz ON k.id_wfstav = wvz.id 
-- 	  LEFT JOIN ciselnik_mira_zavaznosti_zjisteni mz ON k.id_mirazavaznosti = mz.id
-- 	  LEFT JOIN ciselnik_podrobnosti_k_ukonceni_kontroly_se_zjistenim cpk ON cpk.id = k.id_ukonkontr AND k.id_ukonkontr > 0
-- 	  INNER JOIN ciselnik_kontrolni_organ ko ON ko.id = k.id_kontrorgan

-- 	  WHERE ko."Organizační jednotka" = 'Oddělení kontrol výběrových řízení'

-- 	  GROUP BY k.id_nositelkontroly ) k ON k.id_nositelkontroly = z.id


LEFT JOIN (SELECT mke.kurz,
     	  	  z."Částka způsobilých výdajů předpokládané hodnoty veřejné zakázky bez DPH" * mke.kurz AS "Předpokládaná hodnota VZ bez DPH v Kč",
		  zp.id
           FROM zakazka z
	   INNER JOIN zakazka_projekt zp ON zp.id_vz = z.id
	   INNER JOIN mesicni_kurz_eura mke ON substr(z."Datum zahájení zadávacího/výběrového řízení",1,7) = mke.mesic
	   WHERE z.id_mena = 279658
	   ) eurczk ON eurczk.id = zp.id 

WHERE z."Pořadové číslo" is not null 
-- and z."Pořadové číslo" = '00011434' 
-- AND hs.pocet > 0
-- AND p."Registrační číslo projektu" = 'CZ.01.02.01/07/23_021/0003411'
-- AND p."Registrační číslo projektu" in ('CZ.01.05.02/01/23_028/0003030', 'CZ.01.04.01/01/22_006/0001176', 'CZ.01.02.01/07/23_021/0003411')

-- ORDER BY p."Registrační číslo projektu" , z."Pořadové číslo"
-- AND z.id_mena = 279658

