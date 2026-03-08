SELECT p."Registraèní èíslo projektu" ,
       prvni.pocetbodu "Celkem bodù",
       prvni.bodykrit "Ekonomické hodnocení bodù",
       druhy.bodykrit "Výrok analytika"       

FROM isum.v_bi_UmzPrjGGII p 
INNER JOIN (
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
     AND h.ID_SOUBORKRIT in (144202634, 166127531, 327137413, 503513958, 25794051, 167459019, 144365005, 1342551, 1026936198, 488253932, 503467634, 344009106, 488346771, 843495401) ) prvni ON prvni.id_noshodnoceni = p.id
INNER JOIN (
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
     AND h.ID_SOUBORKRIT in (144202634, 166127531, 327137413, 503513958, 25794051, 167459019, 144365005, 1342551, 1026936198, 488253932, 503467634, 344009106, 488346771, 843495401) ) druhy ON druhy.id_noshodnoceni = p.id
 

WHERE p."Registraèní èíslo projektu" like 'CZ.01%'
AND p.kodwfstav in ('PP23a','PP23b','PN23a','PP27a','PP27b','V5','PP29','PP30','PP36','PP37','PP40','PP41','PP42','PP43')
