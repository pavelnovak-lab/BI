SELECT  p."Registraèní èíslo projektu",
      p.zadatel,
      p."IÈ",
      p."Datum ukonèení pøedp",
      p."Datum ukonèení skut",
      hs.datumod "Datum vydání RoPD",
      pf."Pøíspìvek Unie",
      pf."Vlastní zdroj financování",
      pf."Celkové zpùsobilé výdaje",
      pf."Národní veøejné zdroje",
      -- dpzop."Datum propl. posl. ®oP",
      -- czv.CastkaSchvalena "Celkové zdroje",
      -- eu.CastkaSchvalena "Výdaje ESIF",
      -- nsz.CastkaSchvalena "Národní soukromé zdroje",

      (SELECT pla2."Datum proplacení pøíjemci"
       FROM  isum.v_bi_UmpPlatbaPrj pla2
       WHERE pla2.id_nositelplatby = p.id
       AND pla2."PORADI#Poøadí finanèního plánu" =
        (SELECT max(pla1."PORADI#Poøadí finanèního plánu") posl
 	 FROM isum.v_bi_UmpPlatbaPrj pla1
	 WHERE pla1.id_nositelplatby = p.id)
	 ) "Datum propl. posl. ®oP" ,
      platba.kodwfstav ,
      platba."Datum proplacení pøíjemci",
      platba."Èíslo ¾ádosti o platbu",
      (SELECT rf.CastkaSchvalena 
       FROM isum.v_bi_UmpRozpisFin rf
       WHERE rf.id_ukazatel = 361360
       AND rf.id_platba = platba.id) "Spolufinancování ze SR" ,
      (SELECT rf.CastkaSchvalena 
       FROM isum.v_bi_UmpRozpisFin rf
       WHERE rf.id_ukazatel = 361346
       AND rf.id_platba = platba.id) "Celkové zdroje" ,
      (SELECT rf.CastkaSchvalena 
       FROM isum.v_bi_UmpRozpisFin rf
       WHERE rf.id_ukazatel = 361356
       AND rf.id_platba = platba.id) "Výdaje ESIF" ,
      (SELECT rf.CastkaSchvalena 
       FROM isum.v_bi_UmpRozpisFin rf
       WHERE rf.id_ukazatel = 361370
       AND rf.id_platba = platba.id) "Národní soukromé zdroje",
       platba.DatumCertifikace
      
      
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id 
INNER JOIN isum.v_bi_UmfPfCelkem pf ON pf.id_projekt = p.id
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby

-- INNER JOIN (
--  SELECT platba.id_NositelPlatby,
-- 	max(platba."PORADI#Poøadí finanèního plánu") "Poøadí posl. ®oP"
--  FROM isum.v_bi_UmpPlatbaPrj platba
--  GROUP BY platba.id_NositelPlatby) poslzop ON poslzop.id_NositelPlatby = p.id

-- INNER JOIN (
--  SELECT platba."Datum proplacení pøíjemci" "Datum propl. posl. ®oP",
--  	platba.id_nositelplatby,
-- 	platba."PORADI#Poøadí finanèního plánu"
--  FROM isum.v_bi_UmpPlatbaPrj platba ) dpzop ON dpzop.id_nositelplatby = p.id AND poslzop."Poøadí posl. ®oP" = dpzop."PORADI#Poøadí finanèního plánu"
      
-- INNER JOIN (
--  SELECT rf.CastkaSchvalena ,
--  	rf.id_platba
--  FROM isum.v_bi_UmpRozpisFin rf
--  WHERE rf.id_ukazatel = 361346 ) czv ON czv.id_platba = platba.id

-- INNER JOIN (
--  SELECT rf.CastkaSchvalena ,
--  	rf.id_platba
--  FROM isum.v_bi_UmpRozpisFin rf
--  WHERE rf.id_ukazatel = 361356 ) eu ON eu.id_platba = platba.id

-- INNER JOIN (
--  SELECT rf.CastkaSchvalena ,
--  	rf.id_platba
--  FROM isum.v_bi_UmpRozpisFin rf
--  WHERE rf.id_ukazatel = 361370 ) nsz ON nsz.id_platba = platba.id

WHERE hs.stavdo = 'PP30'
AND platba.kodwfstav in ('P10','P11')
AND pf.id_faze = 99991000000000005

AND p."Registraèní èíslo projektu" in ('CZ.01.3.10/0.0/0.0/15_010/0000838','CZ.01.3.10/0.0/0.0/15_010/0003344','CZ.01.1.02/0.0/0.0/16_045/0007355','CZ.01.3.10/0.0/0.0/15_010/0000433','CZ.01.3.10/0.0/0.0/15_010/0000435','CZ.01.3.10/0.0/0.0/15_010/0000478','CZ.01.3.10/0.0/0.0/15_010/0001491','CZ.01.2.111/0.0/0.0/16_047/0009100','CZ.01.2.111/0.0/0.0/16_047/0007606','CZ.01.2.07/0.0/0.0/15_004/0003818','CZ.01.5.125/0.0/0.0/15_020/0007518','CZ.01.5.125/0.0/0.0/15_020/0007518','CZ.01.5.125/0.0/0.0/15_020/0007518','CZ.01.5.125/0.0/0.0/15_020/0007518','CZ.01.5.125/0.0/0.0/15_020/0007518','CZ.01.2.06/0.0/0.0/15_038/0006300','CZ.01.3.10/0.0/0.0/17_138/0011560','CZ.01.1.02/0.0/0.0/15_018/0000727','CZ.01.1.02/0.0/0.0/17_170/0014598','CZ.01.4.04/0.0/0.0/16_076/0008471','CZ.01.4.04/0.0/0.0/16_076/0008471','CZ.01.3.10/0.0/0.0/15_010/0004131','CZ.01.2.07/0.0/0.0/16_048/0007897','CZ.01.2.111/0.0/0.0/18_167/0013152','CZ.01.2.111/0.0/0.0/18_167/0013152')
-- AND platba."Èíslo ¾ádosti o platbu" in ( 'CZ.01.3.10/0.0/0.0/15_010/0000838/2017/001/POST','CZ.01.3.10/0.0/0.0/15_010/0003344/2017/001/POST','CZ.01.1.02/0.0/0.0/16_045/0007355/2017/001/POST','CZ.01.3.10/0.0/0.0/15_010/0000433/2017/001/POST','CZ.01.3.10/0.0/0.0/15_010/0000435/2017/001/POST','CZ.01.3.10/0.0/0.0/15_010/0000478/2017/001/POST','CZ.01.3.10/0.0/0.0/15_010/0001491/2017/001/POST','CZ.01.2.111/0.0/0.0/16_047/0009100/2018/001/POST','CZ.01.2.111/0.0/0.0/16_047/0007606/2017/001/POST','CZ.01.2.07/0.0/0.0/15_004/0003818/2017/002/POST','CZ.01.5.125/0.0/0.0/15_020/0007518/2017/007/ANTE','CZ.01.5.125/0.0/0.0/15_020/0007518/2018/009/ANTE','CZ.01.5.125/0.0/0.0/15_020/0007518/2018/011/ANTE','CZ.01.5.125/0.0/0.0/15_020/0007518/2018/013/ANTE','CZ.01.5.125/0.0/0.0/15_020/0007518/2018/015/ANTE','CZ.01.2.06/0.0/0.0/15_038/0006300/2018/001/POST','CZ.01.3.10/0.0/0.0/17_138/0011560/2019/001/POST','CZ.01.1.02/0.0/0.0/15_018/0000727/2019/003/POST','CZ.01.1.02/0.0/0.0/17_170/0014598/2019/001/POST','CZ.01.4.04/0.0/0.0/16_076/0008471/2018/003/POST','CZ.01.4.04/0.0/0.0/16_076/0008471/2019/004/POST','CZ.01.3.10/0.0/0.0/15_010/0004131/2017/001/POST','CZ.01.2.07/0.0/0.0/16_048/0007897/2019/002/POST','CZ.01.2.111/0.0/0.0/18_167/0013152/2019/001/POST','CZ.01.2.111/0.0/0.0/18_167/0013152/2019/002/POST')



ORDER BY p."Registraèní èíslo projektu" , platba."Èíslo ¾ádosti o platbu"



