SELECT	SUBSTR(l.kod, 4) "PO",
	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	v."Název výzvy" ,
	p."Registrační číslo projektu" ,
	p.kodwfstav, 
	p.zadatel "Žadatel",
	pzf."Celkové způsobilé výdaje" "CZV",
	pzf.PROC_EU "% podpory",
        vz."IČ dodavatele",
	vz."Dodavatel",
	CASE WHEN (vz."Velikost podniku" IS NULL OR vz."Počet zaměstnanců" IS NULL) THEN NULL
	     ELSE 'Ano' END "Velikost podniku z MS14+",
	vz."Velikost podniku",
	vz."Počet zaměstnanců",
        vz."Měna VZ",
	vz."Pořadí VZ",
	vz."Název VZ",
	-- vz.CENAUHRAZENOZV "Cena VZ připadající na ZV",
	-- vz.CENAUHRAZENOZVDPH "Cena VZ připadající na ZV s DPH",
	vz."Vysoutěžená částka ZV z VZ bez DPH" ,
	vz."Vysoutěžená cena VZ" ,
	--- mělo by se posčítat přes doklady 
	vz.id_mena , 	
	vz."Schválené výdaje",
	-- bezvz.schvaleno,
	-- bezvz."IČO Dodavatele",
	-- bezvz."Název Dodavatele",
	CASE WHEN bezvz."VŘ nerelevantní" = 'A' THEN bezvz.schvaleno
	     ELSE vz."Schválené výdaje" END "Schválené výdaje do jednoho sloupce"
	
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_umzvyzvahierarchie vh on vh.id_vyzva = v.id
INNER JOIN isum.v_bi_umshisc sh on sh.id = vh.id_speccil
INNER JOIN isum.v_bi_umshiplinie l on l.id = sh.id_osa
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 

LEFT JOIN (SELECT vs."IČ" "IČ dodavatele",
		  vs."Název subjektu" "Dodavatel",
		  ci."Název" "Velikost podniku",
		  vs.pocetzamestnancu "Počet zaměstnanců",
		  vz.id_mena "Měna VZ",
		  vz.PORADOVECISLO "Pořadí VZ",
		  vz.nazev "Název VZ",
		  -- vz.CENAUHRAZENOZV "Cena VZ připadající na ZV",
		  -- vz.CENAUHRAZENOZVDPH "Cena VZ připadající na ZV s DPH",
		  smlouva."CASTKAZV#Bez DPH" "Vysoutěžená částka ZV z VZ bez DPH" ,
		  smlouva."Cena veřejné zakázky dle smlou" "Vysoutěžená cena VZ" ,
		  --- mělo by se posčítat přes doklady 
		  sd.id_mena , 	
		  -- sd."Pořadové číslo",
		  sum(sd.VYDAJESCHVAL) "Schválené výdaje",
		  count(sd.id_platba) pocetzop,
		  vz.id_nositelvr

	    FROM isum.v_bi_UmvVyberovaRizeni vz
	    INNER JOIN isum.v_bi_UmvVRDodatek smlouva ON smlouva.id_vyberovarizeni = vz.id  
	    -- INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id = -- ON vs.id_prjgg=p.id -- AND vs.id_typsubjektu = 300786 -- dodavatel
	    INNER JOIN isum.V_BI_UMSRSVerzeSubjektu vs ON vs.id = smlouva.id_verzesubjektu AND vs.id > 0
	    INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  vs.id_velikostpodniku

	    INNER JOIN isum.V_BI_UmfSoupiskaDokladPRJ sd ON sd.id_projekt = vz.id_nositelvr AND sd.id_vz = vz.id

	    WHERE vz.id > 0
	    AND vz.id_nositelvr = 1733810
	    GROUP BY vs."IČ",
		  vs."Název subjektu",
		  ci."Název",
		  vs.pocetzamestnancu,
		  vz.id_mena,
		  vz.PORADOVECISLO,
		  vz.nazev,
		  -- vz.CENAUHRAZENOZV "Cena VZ připadající na ZV",
		  -- vz.CENAUHRAZENOZVDPH "Cena VZ připadající na ZV s DPH",
		  smlouva."CASTKAZV#Bez DPH",
		  smlouva."Cena veřejné zakázky dle smlou",
		  --- mělo by se posčítat přes doklady 
		  sd.id_mena , 	
		  -- sd."Pořadové číslo",
		  vz.id_nositelvr

	    ORDER BY vz.poradovecislo
	    ) vz ON  vz.id_nositelvr = p.id 

LEFT JOIN (SELECT sum(VYDAJESCHVAL) schvaleno,
		  "IČO Dodavatele",
		  "Název Dodavatele" ,
		  id_projekt,
		  "VŘ nerelevantní"

	   FROM isum.V_BI_UmfSoupiskaDokladPRJ 
	   
	   WHERE "VŘ nerelevantní" is not null
	   AND VYDAJESCHVAL > 0
	   AND id_projekt = 1733810	   
	   GROUP BY "IČO Dodavatele",
		    "Název Dodavatele",
		    id_projekt,
		    "VŘ nerelevantní"
	   ) bezvz ON bezvz.id_projekt = p.id

WHERE p."Registrační číslo projektu" is not null 
AND p.kodwfstav IN ('PP40','PP41','PP42','PP43')
AND p."Registrační číslo projektu" = 'CZ.01.1.02/0.0/0.0/15_002/0000007'

ORDER BY vz."Pořadí VZ"



----------------------------------------
SELECT -- sum(sd.VYDAJESCHVAL),
       -- sd."IČO Dodavatele",
       -- sd."Název Dodavatele"
       -- sd.id_projekt
       sd.*
FROM isum.V_BI_UmfSoupiskaDokladPRJ sd

WHERE sd."VŘ nerelevantní" is not null
AND sd.id_projekt = 1733810
AND sd.VYDAJESCHVAL > 0

GROUP BY sd."IČO Dodavatele",
       	 sd."Název Dodavatele"
       	 sd.id_projekt
----------------------------------------



SELECT	SUBSTR(l.kod, 4) "PO",
	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	v."Název výzvy" ,
	p."Registrační číslo projektu" ,
	p.kodwfstav, 
	p.zadatel "Žadatel",
	pzf."Celkové způsobilé výdaje" "CZV",
	pzf.PROC_EU "% podpory",
	
	-- Sloučené sloupce podle typu záznamu
	sloucene."IČ dodavatele",
	sloucene."Dodavatel",
	sloucene."Velikost podniku z MS14+",
	sloucene."Velikost podniku",
	sloucene."Počet zaměstnanců",
	sloucene."Měna VZ",
	sloucene."Pořadí VZ",
	sloucene."Název VZ",
	sloucene."Vysoutěžená částka ZV z VZ bez DPH",
	sloucene."Vysoutěžená cena VZ",
	sloucene.id_mena,
	sloucene."Schválené výdaje"
	
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_umzvyzvahierarchie vh on vh.id_vyzva = v.id
INNER JOIN isum.v_bi_umshisc sh on sh.id = vh.id_speccil
INNER JOIN isum.v_bi_umshiplinie l on l.id = sh.id_osa
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005
-- isum.v_bi_UmsCisZakladni ci ON ci.id =  
-- Sloučení dat s VZ a bez VZ do jednoho podselectu
LEFT JOIN (
    -- Data z veřejných zakázek
    SELECT 
        vs."IČ" "IČ dodavatele",
        vs."Název subjektu" "Dodavatel",
        CASE WHEN (ci."Název" IS NULL OR vs.pocetzamestnancu IS NULL) THEN NULL
             ELSE 'Ano' END "Velikost podniku z MS14+",
        ci."Název" "Velikost podniku",
        vs.pocetzamestnancu "Počet zaměstnanců",
        vz.id_mena "Měna VZ",
        vz.PORADOVECISLO "Pořadí VZ",
        vz.nazev "Název VZ",
        smlouva."CASTKAZV#Bez DPH" "Vysoutěžená částka ZV z VZ bez DPH",
        smlouva."Cena veřejné zakázky dle smlou" "Vysoutěžená cena VZ",
        sd.id_mena,
        sum(sd.VYDAJESCHVAL) "Schválené výdaje",
        vz.id_nositelvr,
        'VZ' as typ_zaznamu
    FROM isum.v_bi_UmvVyberovaRizeni vz
    INNER JOIN isum.v_bi_UmvVRDodatek smlouva ON smlouva.id_vyberovarizeni = vz.id  
    INNER JOIN isum.V_BI_UMSRSVerzeSubjektu vs ON vs.id = smlouva.id_verzesubjektu AND vs.id > 0
    INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = vs.id_velikostpodniku
    INNER JOIN isum.V_BI_UmfSoupiskaDokladPRJ sd ON sd.id_projekt = vz.id_nositelvr AND sd.id_vz = vz.id
    WHERE vz.id > 0
    AND vz.id_nositelvr = 1733810
    GROUP BY vs."IČ", vs."Název subjektu", ci."Název", vs.pocetzamestnancu,
             vz.id_mena, vz.PORADOVECISLO, vz.nazev, smlouva."CASTKAZV#Bez DPH",
             smlouva."Cena veřejné zakázky dle smlou", sd.id_mena, vz.id_nositelvr


    UNION ALL

    -- Data bez veřejných zakázek
    SELECT 
        "IČO Dodavatele" "IČ dodavatele",
        "Název Dodavatele" "Dodavatel",
        NULL "Velikost podniku z MS14+",
        NULL "Velikost podniku", 
        NULL "Počet zaměstnanců",
        NULL "Měna VZ",
        NULL "Pořadí VZ",
        NULL "Název VZ",
        NULL "Vysoutěžená částka ZV z VZ bez DPH",
        NULL "Vysoutěžená cena VZ",
        id_mena,
        sum(VYDAJESCHVAL) "Schválené výdaje",
        id_projekt id_nositelvr,
        'BEZVZ' as typ_zaznamu
    FROM isum.V_BI_UmfSoupiskaDokladPRJ 
    WHERE "VŘ nerelevantní" is not null
    AND VYDAJESCHVAL > 0
    AND id_projekt = 1733810	   
    GROUP BY "IČO Dodavatele", "Název Dodavatele", id_projekt, id_mena

) sloucene ON sloucene.id_nositelvr = p.id

WHERE p."Registrační číslo projektu" is not null 
AND p.kodwfstav IN ('PP40','PP41','PP42','PP43')
AND p."Registrační číslo projektu" = 'CZ.01.1.02/0.0/0.0/15_002/0000007'

ORDER BY sloucene."Pořadí VZ"

----------------------------------------
SELECT DISTINT sd.id_mena,
       	       c."Kód" 

FROM isum.V_BI_UmfSoupiskaDokladPRJ sd
JOIN isum.v_bi_UmsCisZakladni c ON c.id = sd.id_mena
