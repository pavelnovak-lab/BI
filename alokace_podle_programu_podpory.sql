SELECT v."Èíslo výzvy" ,
       v."Název výzvy" ,
       v."Fin alokace výzvy EU",
       v."Datum vyhlá¹ení výzvy",
       v."Datum ukonèení pøíjmu ¾ádosti",
       kom."Název",
       sropd."Proplaceno",
       sropd."Poèet projektù s RoPD",
       sropd."Po¾adovaná dotace s RoPD",
       predropd.eu "V PP projektech pøed RoPD" ,
       v.wfstav,
       -- sum(sropd."Proplacená dotace") "Proplaceno",
       count(p.id) "Poèet zaregistrovaných prj",
       sum(p.eu)/count(p.id) "Prùmìrná dotace"
 


FROM isum.v_bi_UmzVyzva v -- ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmzPrjGG p ON p.id_vyzva = v.id AND p."Registraèní èíslo projektu" is not null 
INNER JOIN isum.V_BI_UmzVyzvaUtvar utvar ON utvar.id_vyzva=v.id
INNER JOIN isum.V_BI_UMSHIUtvarKomp kom ON kom.id=utvar.id_utvarkomp 
INNER JOIN (
  SELECT p.id_vyzva,
	 sum(proplaceno."Proplacená dotace") "Proplaceno",
	 count(p.id) "Poèet projektù s RoPD",
	 sum(p.eu) "Po¾adovaná dotace s RoPD"

  FROM isum.v_bi_umzprjgg p
  -- INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
  INNER JOIN 
   (SELECT platba.id_nositelplatby,
	  sum(rf.CASTKASCHVALENA) "Proplacená dotace"
   FROM isum.v_bi_UmpPlatbaPrj platba 
   INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- øádky 10a
   WHERE platba.kodwfstav in ('P10','P11')
   GROUP BY platba.id_nositelplatby) proplaceno ON proplaceno.id_nositelplatby = p.id

  WHERE p.id_prioritniosa in ('406085','406086','406087','406088','406089') -- prioritni osy OP PIK
  AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43')
-- AND v."Èíslo výzvy" in ('01_16_056', '01_15_068', '01_17_121', '01_19_267')
  GROUP BY p.id_vyzva

-- SELECT sum(p.eu) eu,
 -- 	p.id_vyzva,
 -- 	p.id,
 -- 	sum(rf.CASTKASCHVALENA) "Proplacená dotace" 
 -- FROM isum.v_bi_UmzPrjGG p
 -- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.kodwfstav in ('P10','P11')
 -- INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- øádky 10a

 -- WHERE p.id_prioritniosa in ('406085','406086','406087','406088','406089') -- prioritni osy OP PIK
 -- AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43')
 
 -- GROUP BY p.id_vyzva) sropd ON sropd.id_vyzva = v.id
 ) sropd ON sropd.id_vyzva = v.id
INNER JOIN (
 SELECT sum(p.eu) eu,
 	p.id_vyzva
 FROM isum.v_bi_UmzPrjGG p
 WHERE p.id_prioritniosa in ('406085','406086','406087','406088','406089') -- prioritni osy OP PIK 
 AND p.kodwfstav in ('PP20','PP21','PP22','PP23a','PP23b','PP27a','PP27b','PP29','PU21','PU27','V2','V5','Z1','Z3')  
 GROUP BY p.id_vyzva) predropd ON predropd.id_vyzva = v.id



WHERE
-- v."Èíslo výzvy" = '01_21_374' AND
v.wfstav not in ('Pozastavená','Zaregistrovaná','Zru¹ená','Pozastavená')
AND kom."Název" <> 'Operaèní program Podnikání a inovace pro konkurenceschopnost' 


GROUP BY v."Èíslo výzvy" ,
       v."Název výzvy" ,
       v."Fin alokace výzvy EU",
       v."Datum vyhlá¹ení výzvy",
       v."Datum ukonèení pøíjmu ¾ádosti",
       kom."Název",
       predropd.eu,
       v.wfstav ,
       sropd."Proplaceno",
       sropd."Poèet projektù s RoPD",
       sropd."Po¾adovaná dotace s RoPD"






-- ------------------------------------------------------------------

-- SELECT v."Èíslo výzvy" ,
--        p."Registraèní èíslo projektu" ,
--        p.kodwfstav,
--        platba."Èíslo ¾ádosti o platbu" ,
--        rf.castkaschvalena
--        -- count(p.id) "Poèet projektù"
--        -- sum(rf.CASTKASCHVALENA) "Proplacená dotace" 

        
-- FROM isum.v_bi_UmzProjekt p
-- INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
-- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.kodwfstav in ('P10','P11')
-- INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- øádky 10a   

-- WHERE p."Registraèní èíslo projektu" is not null
-- AND v.wfstav not in ('Pozastavená','Zaregistrovaná','Zru¹ená','Pozastavená')
-- AND v."Èíslo výzvy" in ('01_17_121')

-- ORDER BY platba."Èíslo ¾ádosti o platbu" 

-- -- GROUP BY v."Èíslo výzvy"
-- -- ORDER BY  "Poèet projektù"




SELECT p.id_vyzva
       sum(proplaceno."Proplacená dotace"),
       count(p.id),
       sum(p.eu)
       
FROM isum.v_bi_umzprjgg p
-- INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN 
 (SELECT platba.id_nositelplatby,
 	sum(rf.CASTKASCHVALENA) "Proplacená dotace"
 FROM isum.v_bi_UmpPlatbaPrj platba 
 INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- øádky 10a
 WHERE platba.kodwfstav in ('P10','P11')
 GROUP BY platba.id_nositelplatby) proplaceno ON proplaceno.id_nositelplatby = p.id

WHERE p.id_prioritniosa in ('406085','406086','406087','406088','406089') -- prioritni osy OP PIK
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43')
-- AND v."Èíslo výzvy" in ('01_16_056', '01_15_068', '01_17_121', '01_19_267')

GROUP BY p.id_vyzva





AND v."Èíslo výzvy" in ('01_16_056', '01_15_068', '01_17_121', '01_19_267')
