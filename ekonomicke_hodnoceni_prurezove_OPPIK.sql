SELECT p."Registraèní èíslo projektu" ,
       p."Název projektu CZ",
       p.kodwfstav,
       p.zadatel,
       p."IÈ",
       krit."Celkem bodù" ,  
       krit."Ekonomické hodnocení" ,
       krit."Výrok analytika" 

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN ( SELECT max(CASE WHEN k.kod = '00' THEN k.pocetbodu END) "Celkem bodù" ,
       	    	   max(CASE WHEN k.kod = '01' THEN k.pocetbodu END) "Ekonomické hodnocení" ,
       		   max(CASE WHEN k.kod = '02' THEN k.pocetbodu END) "Výrok analytika" ,
       		   hod.id_noshodnoceni
       FROM isum.v_bi_UmvHodnoceni hod -- ON hod.id_noshodnoceni = p.id
       INNER JOIN isum.v_bi_UMVHodnotaKrit k ON k.id_hodnoceni = hod.id 
       WHERE hod.id_krokvechodn = (171213)
       -- AND hod.id_noshodnoceni = 1084608481
       AND hod.finalizovano = 'A'
       AND hod.platnost = 'A'
       GROUP BY hod.id_noshodnoceni
       ) krit ON krit.id_noshodnoceni = p.id 




