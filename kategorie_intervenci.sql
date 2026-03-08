SELECT 	p."Registrační číslo projektu",
	p.KodWFStav,
	p.KodPrioritniOsa,
	roz.eu "Dotace EU (EUR)",
	cis."Kód" "Kód KI" ,

	CASE WHEN cis."Kód" IN ('II.1.009','II.1.010','II.1.011','II.1.012','II.1.015','II.1.016','IV.1.065','IV.2.068','IV.2.070') THEN '100'
	     WHEN cis."Kód" IN ('I.0.003','IV.2.069') THEN '40'
	     END "Procento KI",
	     
	CASE WHEN cis."Kód" IN ('II.1.009','II.1.010','II.1.011','II.1.012','II.1.015','II.1.016','IV.1.065','IV.2.068','IV.2.070') THEN roz.eu
	     WHEN cis."Kód" IN ('I.0.003','IV.2.069') THEN 0.4*roz.eu
	     END "Dotace pro KI (EUR)"
	-- ki."Indikativní alokace"
	-- roz.czv_eur,
	-- roz.eu_eur,
	-- roz.vzv,
	-- roz.vzv_eur,
	-- roz.PROCCASTKY "Procento"
	-- ki."Procentní podíl",
	-- ki."Typ kategorie intervencí",
	-- ki."Indikativní alokace",
	-- roz.*
	-- oi."Název" "Oblast intervence"
	
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzPrjKI ki ON ki.id_projekt=p.id
INNER JOIN isum.v_bi_UmsCisZakladni cis ON ki.id_ki=cis.id 
INNER JOIN (SELECT sum(eu_eur) eu ,
      	   	   id_projekt
      	    FROM isum.v_bi_UMZPRJKIRozpad
	    GROUP BY id_projekt ) roz ON roz.id_projekt = p.id 

-- INNER JOIN isum.v_bi_UmsCisZakladni oi ON oi.id = roz.id_oi

WHERE	p."Registrační číslo projektu" is not null 
AND ki."Typ kategorie intervencí" = 0
-- AND	p.KodPrioritniOsa = '01.1','01.3'
AND p.KodWFStav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43')
AND p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/20_321/0024399','CZ.01.3.14/0.0/0.0/17_096/0011793','CZ.01.1.02/0.0/0.0/17_165/0015091')

AND cis."Kód" IN ('II.1.009','II.1.010','II.1.011','II.1.012','II.1.015','II.1.016','IV.1.065','IV.2.068','IV.2.070','I.0.003','IV.2.069')

ORDER BY p."Registrační číslo projektu"
----------------------------------------
SELECT sum(eu_eur) eu ,
      	   	   id_projekt
      	    FROM isum.v_bi_UMZPRJKIRozpad

WHERE id_projekt = 581749058
	    GROUP BY id_projekt



SELECT *
FROM isum.v_bi_UMSCisKurzyMen




Vazba na nositele objektu Událost kalendáře uživatele (V_BI_UMVHodnoceni; V_BI_UMVHodnSchvaleni; V_BI_UMZIN; V_BI_UMZZOZProjekt; V_BI_UMSStatObjekt; V_BI_UMZMVTerminy; V_BI_UMSVZDPrihlaska; V_BI_UMVHodnKomise; V_BI_UMVHodnVyporadaniVK; V_BI_UMVHodnotitelKomp; V_BI_UMZNesrovnalost; V_BI_UMVHodnNamitkaVK; V_BI_UMSVZDKurz; V_BI_UMZPrPodminka; V_BI_UMZISIRPrj; V_BI_UMPEKFormularA; V_BI_CUzivatelWEB; V_BI_UMVHodnStatusDH; V_BI_UMZProfilUzivatele; V_BI_UMVEtapa; V_BI_UMZZpravyIN; V_BI_UMSAKZprava; V_BI_UMZLhuty; V_BI_UMVKontrAR; V_BI_UMSDokumentace; V_BI_UMSPrirucka; V_BI_UMZProjekt; V_BI_UMVVyberovaRizeni; V_BI_UMVKontrolaNaMiste; V_BI_UMZZIProjekt; V_BI_UMSVZDBeh; V_BI_UMVHodnClenVKomisi; V_BI_UMPEKPlatba; V_BI_UMSDAZVZ; V_BI_UMVRocniPlanKontrol; V_BI_UMVHodnotitelPrg; V_BI_UMZVyzva; V_BI_UMFSmlouva; V_BI_UMZPrjGGPlnaMoc; V_BI_UMVHodnNamitka; V_BI_UMSHIRevize; V_BI_UMSAdresaUziv; V_BI_UMZPrPodKriterium; V_BI_UMZMAS; V_BI_UMSHIPLinieKomp; V_BI_UMZPrjGGSdileni; V_BI_UMVHodnNamitkaHodn; V_BI_UMZZOZIN; V_BI_UMSZamestnanec; V_BI_UMVHodnVyporadani; V_BI_UMZNesrovnalostPRK; V_BI_UMFROZHlavicka; V_BI_UMPPlatba; V_BI_UMVHodnKomNos; V_BI_UMSCisSeznam; V_BI_UMZProjOdpovedn; V_BI_UMPSouhrnnaPlatba)
