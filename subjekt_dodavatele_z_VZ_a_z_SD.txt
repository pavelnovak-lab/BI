SELECT	SUBSTR(l.kod, 4) "PO",
	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	v."Název výzvy" ,
	p."Registrační číslo projektu" ,
	p.kodwfstav, 
	p.zadatel "Příjemce",
	vs."IČ",
	vs."Počet zaměstnanců" "Počet zaměstnanců příjemce",
	vp."Název" "Velikost podniku příjemce",
	
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
	sloucene."Měna SD",
	sloucene."Počet ŽoP",	
	sloucene."Schválené výdaje"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_umzvyzvahierarchie vh on vh.id_vyzva = v.id
INNER JOIN isum.v_bi_umshisc sh on sh.id = vh.id_speccil
INNER JOIN isum.v_bi_umshiplinie l on l.id = sh.id_osa
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel 
LEFT JOIN isum.v_bi_UmsCisZakladni vp ON vp.id = vs.id_velikostpodniku
-- Sloučení dat s VZ a bez VZ do jednoho podselectu
INNER JOIN (
    -- Data z veřejných zakázek

    SELECT 
        vs."IČ" "IČ dodavatele",
        vs."Název subjektu" "Dodavatel",
        CASE WHEN (ci."Název" IS NULL AND vs.pocetzamestnancu IS NULL) THEN NULL
             ELSE 'Ano' END "Velikost podniku z MS14+",
        ci."Název" "Velikost podniku",
        vs.pocetzamestnancu "Počet zaměstnanců",
        menavz."Kód"  "Měna VZ",
        vz.PORADOVECISLO "Pořadí VZ",
        vz.nazev "Název VZ",
        smlouva."CASTKAZV#Bez DPH" "Vysoutěžená částka ZV z VZ bez DPH",
        smlouva."Cena veřejné zakázky dle smlou" "Vysoutěžená cena VZ",
        CASE WHEN (menasd."Kód" is null AND menasd."Kód" = '0') THEN 'CZK'
	     ELSE menasd."Kód" END "Měna SD",
        SUM(sd.VYDAJESCHVAL) "Schválené výdaje",
	COUNT(DISTINCT sd.id_platba) "Počet ŽoP",
        vz.id_nositelvr,
        'VZ' as typ_zaznamu
    FROM isum.v_bi_UmvVyberovaRizeni vz
    INNER JOIN isum.v_bi_UmvVRDodatek smlouva ON smlouva.id_vyberovarizeni = vz.id  
    INNER JOIN isum.V_BI_UMSRSVerzeSubjektu vs ON vs.id = smlouva.id_verzesubjektu AND vs.id > 0
    INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = vs.id_velikostpodniku
    INNER JOIN isum.V_BI_UmfSoupiskaDokladPRJ sd ON sd.id_projekt = vz.id_nositelvr AND sd.id_vz = vz.id
    LEFT JOIN isum.v_bi_UmsCisZakladni menasd ON menasd.id = sd.id_mena
    LEFT JOIN isum.v_bi_UmsCisZakladni menavz ON menavz.id = vz.id_mena
    WHERE vz.id > 0
    -- AND vz.id_nositelvr = 1733810
    GROUP BY vs."IČ", vs."Název subjektu", ci."Název", vs.pocetzamestnancu,
             menavz."Kód", vz.PORADOVECISLO, vz.nazev, smlouva."CASTKAZV#Bez DPH",
             smlouva."Cena veřejné zakázky dle smlou",
	     CASE WHEN (menasd."Kód" is null AND menasd."Kód" = '0') THEN 'CZK'
	     ELSE menasd."Kód" END,
	     vz.id_nositelvr

    UNION ALL

    -- Finanční data z ŽoP
    SELECT 
        sd."IČO Dodavatele" "IČ dodavatele",
        sd."Název Dodavatele" "Dodavatel",
        NULL "Velikost podniku z MS14+",
        NULL "Velikost podniku", 
        NULL "Počet zaměstnanců",
        NULL "Měna VZ",
        NULL "Pořadí VZ",
        NULL "Název VZ",
        NULL "Vysoutěžená částka ZV z VZ bez DPH",
        NULL "Vysoutěžená cena VZ",
        CASE WHEN (menasd."Kód" is null AND menasd."Kód" = '0') THEN 'CZK'
	     ELSE menasd."Kód" END "Měna SD",
        SUM(sd.VYDAJESCHVAL) "Schválené výdaje",
	COUNT(DISTINCT sd.id_platba) "Počet ŽoP",
        sd.id_projekt,
        'BEZVZ' as typ_zaznamu
	
    FROM isum.V_BI_UmfSoupiskaDokladPRJ sd
    LEFT JOIN isum.v_bi_UmsCisZakladni menasd ON menasd.id = sd.id_mena  
    WHERE sd."VŘ nerelevantní" is not null
    AND sd.VYDAJESCHVAL > 0
    -- AND sd.id_projekt = 1733810	   
    GROUP BY sd."IČO Dodavatele", sd."Název Dodavatele", sd.id_projekt,
    	     CASE WHEN (menasd."Kód" is null AND menasd."Kód" = '0') THEN 'CZK'
	     	  ELSE menasd."Kód" END
) sloucene ON sloucene.id_nositelvr = p.id

WHERE p."Registrační číslo projektu" is not null 
AND p.kodwfstav IN ('PP40','PP41','PP42','PP43')
-- AND p."Registrační číslo projektu" = 'CZ.01.1.02/0.0/0.0/15_002/0000007'
AND SUBSTR(l.kod, 4) = '1'

ORDER BY substr(p."Registrační číslo projektu",-5,5) ASC, sloucene."Pořadí VZ"
