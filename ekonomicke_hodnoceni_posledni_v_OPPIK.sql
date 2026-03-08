     SELECT v."Název výzvy" ,
     	    p."Registraèní èíslo projektu",
	    max(h.datum_finalizace)
     	    
     FROM  isum.v_bi_UmzProjekt p 
     INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
     INNER JOIN isum.v_bi_UmvHodnoceni h ON h.id_noshodnoceni = p.id 

     WHERE h.id_kolohodnoceni=171212  /* hodnocení plné ¾ádosti */
     AND h.id_KrokVecHodn = 171213  /* 1. krok VH */
     AND h.platnost = 'A'
     AND h.OpravneHodnoceni = 'N'
     AND h.finalizovano = 'A'
     AND h.ID_SOUBORKRIT in (144202634, 166127531, 327137413, 503513958, 25794051, 167459019, 144365005, 1342551, 1026936198, 488253932, 503467634, 344009106, 488346771, 843495401)

     GROUP BY v."Název výzvy" p."Registraèní èíslo projektu" 
