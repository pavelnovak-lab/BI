SELECT 	p."Registraèní èíslo projektu" ,
	nvl(prvni_krok_VH.POCETBODU,druhy_krok_VH.POCETBODU) "Bodù ve VH 0-100" ,
	analytik.bodykrit "Výrok analytika",
 	ekon.bodykrit "Ekonomické hodnocení"
	
FROM isum.v_bi_UmzProjekt p
LEFT JOIN
(SELECT p.id,
	status.POCETBODU
 FROM isum.v_bi_UmzProjekt p 
 INNER JOIN isum.V_BI_UMVHODNSTATUSDH status ON status.id_noshodnoceni = p.id AND status.id_KROKVECHODN = 171213 -- hodnocení 1. kroku
 WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
 AND  status.POCETBODU > 0
 AND p.kodwfstav in ('PP40','PP41','PP42','PP43')
 AND status.ID_SOUBORKRIT not in (144202634, 166127531, 327137413, 503513958, 25794051, 167459019, 144365005, 1342551, 1026936198, 488253932, 503467634, 344009106, 488346771, 843495401) -- toto jsou soubory kritérií ekonomického hodnocení
) prvni_krok_VH ON prvni_krok_VH.id = p.id 

LEFT JOIN
(SELECT p.id,
	status.POCETBODU
 FROM isum.v_bi_UmzProjekt p 
 INNER JOIN isum.V_BI_UMVHODNSTATUSDH status ON status.id_noshodnoceni = p.id AND status.id_KROKVECHODN = 171214 -- hodnocení 1. kroku
 WHERE status.POCETBODU > 0
 AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
 AND p.kodwfstav in ('PP40','PP41','PP42','PP43')
-- AND status.ID_SOUBORKRIT not in (144202634, 166127531, 327137413, 503513958, 25794051, 167459019, 144365005, 1342551, 1026936198, 488253932, 503467634, 344009106, 488346771, 843495401) -- toto jsou soubory kritérií ekonomického hodnocení
) druhy_krok_VH ON druhy_krok_VH.id = p.id 

LEFT JOIN (
     SELECT krit.pocetbodu bodykrit ,
     	    h.pocetbodu,
     	    h.id_noshodnoceni
     FROM  isum.v_bi_UmvHodnoceni h
     INNER JOIN isum.v_bi_UMVHodnotaKrit krit ON krit.id_hodnoceni = h.id 
     WHERE h.id_kolohodnoceni=171212  /* hodnocení plné ¾ádosti */
     AND h.id_KrokVecHodn = 171213  /* 1. krok VH */
     AND h.platnost = 'A'
     AND h.OpravneHodnoceni = 'N'
     AND h.finalizovano = 'A'
     AND krit.Kod = '02'
     AND h.ID_SOUBORKRIT in (144202634, 166127531, 327137413, 503513958, 25794051, 167459019, 144365005, 1342551, 1026936198, 488253932, 503467634, 344009106, 488346771, 843495401) ) analytik ON analytik.id_noshodnoceni = p.id

LEFT JOIN (
     SELECT krit.pocetbodu bodykrit ,
     	    h.pocetbodu,
     	    h.id_noshodnoceni
     FROM  isum.v_bi_UmvHodnoceni h
     INNER JOIN isum.v_bi_UMVHodnotaKrit krit ON krit.id_hodnoceni = h.id 
     WHERE h.id_kolohodnoceni=171212  /* hodnocení plné ¾ádosti */
     AND h.id_KrokVecHodn = 171213  /* 1. krok VH */
     AND h.platnost = 'A'
     AND h.OpravneHodnoceni = 'N'
     AND h.finalizovano = 'A'
     AND krit.Kod = '01'
     AND h.ID_SOUBORKRIT in (144202634, 166127531, 327137413, 503513958, 25794051, 167459019, 144365005, 1342551, 1026936198, 488253932, 503467634, 344009106, 488346771, 843495401) ) ekon ON ekon.id_noshodnoceni = p.id



WHERE p.kodwfstav in ('PP40','PP41','PP42','PP43')
-- WHERE p.kodwfstav in ('PP23a','PP23b','PP27a','PP27b','V5','PP29','PP30','PP36','PP37','PP40','PP41','PP42','PP43')
-- AND p."Registraèní èíslo projektu" like 'CZ.01.%'
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
