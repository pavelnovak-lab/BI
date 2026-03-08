SELECT p."Registraèní èíslo projektu",
       substr(p."Registraèní èíslo projektu",-5,5) "Projekt" ,
       p.zadatel,
       p."Název projektu CZ",
       p.id,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       max( platba."Datum proplacení pøíjemci")  "Datum proplacení pøíjemci" ,
       max( platba."Èíslo ¾ádosti o platbu") "Èíslo ¾ádosti o platbu",
       -- pril.NAZEVPRIL,
       -- pril."Link DMS" ,
       vs.pocet "Poèet partnerù",
       sum(czv.czv) "suma czv",
       sum(eu.eu) "suma eu",
       count(platba.id),
       LISTAGG( platba."Závìreèná platba", '; ') "Závìreèná platba",
       LISTAGG( prp."Link DMS" , '; ') "Kontrolní tabulka",
       count(prp.id) "Poèet kontrolních tabulek"
       
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id = p.id_vyzva 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id = platba.id_NositelPlatby 
-- INNER JOIN isum.v_bi_UMFSmlouva sml ON  sml.id_nositelsml = p.id
-- INNER JOIN isum.v_bi_UMSPrilohyPA pril ON pril.id_nositelpril = sml.id
-- LEFT JOIN (SELECT isum.v_bi_UMSPrilohy prp ON prp.id_nositelpril = platba.id AND (upper(prp."Název dokumentu") like upper('%kontrolni tabulka%') OR upper(prp."Název dokumentu") like upper('%kontrolní tabulka%'))

LEFT JOIN isum.v_bi_UMSPrilohy prp ON prp.id_nositelpril = platba.id AND (upper(prp."Název dokumentu") like upper('%kontrolni tabulka%') OR upper(prp."Název dokumentu") like upper('%kontrolní tabulka%'))


left JOIN (SELECT count(vs.id) pocet,
      	   	   vs.id_prjgg
  FROM isum.v_bi_UmzPrjGGvs vs
  WHERE vs.neplatny is null
  AND vs.id_typsubjektu = 300785 -- partner
  GROUP BY vs.id_prjgg ) vs ON vs.id_prjgg = p.id

INNER JOIN (SELECT rf.castkaschvalena czv ,
	rf.id_platba
  FROM isum.v_bi_UmpRozpisFin rf
  WHERE rf.id_ukazatel = 361347) czv ON czv.id_platba = platba.id

INNER JOIN (SELECT rf.castkaschvalena eu ,
	rf.id_platba
  FROM isum.v_bi_UmpRozpisFin rf
  WHERE rf.id_ukazatel = 361356) eu ON eu.id_platba = platba.id

WHERE p.kodwfstav in ('PP37','PP40','PP41','PP42','PP43','PU30')
-- AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'
-- AND v."Èíslo výzvy" IN ('01_17_106','01_17_107','01_17_175','01_17_176','01_19_262','01_20_321')
-- AND p."Registraèní èíslo projektu" IN ('CZ.01.1.02/0.0/0.0/17_176/0015727')
-- AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/20_321/0023609'
-- AND to_date('2021-12-31','yyyy-mm-dd') < platba."Datum proplacení pøíjemci"
-- AND platba."Datum proplacení pøíjemci" < to_date('2023-01-01','yyyy-mm-dd')  
AND (platba.kodwfstav = 'P10' OR platba.kodwfstav like 'P1%' )
-- AND upper(pril.NAZEVPRIL) like upper('%Rozpoèet%')
-- AND sml."Poøadí" = 1
-- AND exists
-- (SELECT pl."Èíslo ¾ádosti o platbu" 
--  from isum.v_bi_UmpPlatbaPrj pl
--  WHERE pl.id_NositelPlatby = p.id  
--  AND pl."Závìreèná platba" = 'A'
--  AND to_date('2021-12-31','yyyy-mm-dd') < pl."Datum proplacení pøíjemci"
--  AND pl."Datum proplacení pøíjemci" < to_date('2023-01-01','yyyy-mm-dd')  )
AND p."Registraèní èíslo projektu" IN ('CZ.01.1.02/0.0/0.0/16_084/0009908','CZ.01.1.02/0.0/0.0/17_107/0012333','CZ.01.1.02/0.0/0.0/17_106/0012289','CZ.01.1.02/0.0/0.0/17_175/0015498','CZ.01.1.02/0.0/0.0/17_176/0015573','CZ.01.1.02/0.0/0.0/17_176/0015680','CZ.01.1.02/0.0/0.0/20_321/0023605','CZ.01.1.02/0.0/0.0/20_321/0023609','CZ.01.1.02/0.0/0.0/20_321/0023783','CZ.01.1.02/0.0/0.0/20_321/0024194','CZ.01.1.02/0.0/0.0/20_321/0024293','CZ.01.1.02/0.0/0.0/20_321/0024364','CZ.01.1.02/0.0/0.0/15_018/0001238','CZ.01.1.02/0.0/0.0/15_019/0000735','CZ.01.1.02/0.0/0.0/15_019/0004353','CZ.01.1.02/0.0/0.0/15_019/0004433','CZ.01.1.02/0.0/0.0/15_019/0004706','CZ.01.1.02/0.0/0.0/15_019/0004815','CZ.01.1.02/0.0/0.0/15_019/0005110','CZ.01.1.02/0.0/0.0/16_084/0010281','CZ.01.1.02/0.0/0.0/16_084/0010312','CZ.01.1.02/0.0/0.0/17_106/0012281','CZ.01.1.02/0.0/0.0/17_106/0012292','CZ.01.1.02/0.0/0.0/17_106/0012442','CZ.01.1.02/0.0/0.0/17_106/0012522','CZ.01.1.02/0.0/0.0/17_107/0012430','CZ.01.1.02/0.0/0.0/17_107/0012435','CZ.01.1.02/0.0/0.0/17_175/0014505','CZ.01.1.02/0.0/0.0/17_175/0014979','CZ.01.1.02/0.0/0.0/17_175/0015596','CZ.01.1.02/0.0/0.0/17_175/0015642','CZ.01.1.02/0.0/0.0/17_175/0015677','CZ.01.1.02/0.0/0.0/17_175/0015737','CZ.01.1.02/0.0/0.0/17_175/0015752','CZ.01.1.02/0.0/0.0/19_262/0019258','CZ.01.1.02/0.0/0.0/19_262/0019500','CZ.01.1.02/0.0/0.0/19_262/0019720','CZ.01.1.02/0.0/0.0/19_262/0019878','CZ.01.1.02/0.0/0.0/19_262/0019888','CZ.01.1.02/0.0/0.0/19_262/0019913','CZ.01.1.02/0.0/0.0/19_262/0019917','CZ.01.1.02/0.0/0.0/19_262/0019927','CZ.01.1.02/0.0/0.0/19_262/0019954','CZ.01.1.02/0.0/0.0/19_262/0020025','CZ.01.1.02/0.0/0.0/19_262/0020026','CZ.01.1.02/0.0/0.0/19_262/0020034','CZ.01.1.02/0.0/0.0/19_262/0020055','CZ.01.1.02/0.0/0.0/19_262/0020065','CZ.01.1.02/0.0/0.0/19_262/0020114','CZ.01.1.02/0.0/0.0/19_262/0020122','CZ.01.1.02/0.0/0.0/19_262/0020124','CZ.01.1.02/0.0/0.0/19_262/0020133','CZ.01.1.02/0.0/0.0/19_262/0020141','CZ.01.1.02/0.0/0.0/19_262/0020143','CZ.01.1.02/0.0/0.0/19_262/0020178','CZ.01.1.02/0.0/0.0/19_262/0020182','CZ.01.1.02/0.0/0.0/19_262/0020213','CZ.01.1.02/0.0/0.0/19_262/0020226','CZ.01.1.02/0.0/0.0/19_262/0020238','CZ.01.1.02/0.0/0.0/19_262/0020240','CZ.01.1.02/0.0/0.0/19_262/0020257','CZ.01.1.02/0.0/0.0/17_106/0012273','CZ.01.1.02/0.0/0.0/17_106/0012285','CZ.01.1.02/0.0/0.0/17_106/0012475','CZ.01.1.02/0.0/0.0/17_106/0012494','CZ.01.1.02/0.0/0.0/17_106/0012500','CZ.01.1.02/0.0/0.0/17_107/0012336','CZ.01.1.02/0.0/0.0/17_107/0012337','CZ.01.1.02/0.0/0.0/17_107/0012396','CZ.01.1.02/0.0/0.0/17_107/0012547','CZ.01.1.02/0.0/0.0/17_175/0015370','CZ.01.1.02/0.0/0.0/17_175/0015440','CZ.01.1.02/0.0/0.0/17_175/0015484','CZ.01.1.02/0.0/0.0/17_175/0015541','CZ.01.1.02/0.0/0.0/17_175/0015546','CZ.01.1.02/0.0/0.0/17_175/0015558','CZ.01.1.02/0.0/0.0/17_175/0015559','CZ.01.1.02/0.0/0.0/17_175/0015566','CZ.01.1.02/0.0/0.0/17_175/0015577','CZ.01.1.02/0.0/0.0/17_175/0015586','CZ.01.1.02/0.0/0.0/17_175/0015587','CZ.01.1.02/0.0/0.0/17_175/0015598','CZ.01.1.02/0.0/0.0/17_175/0015603','CZ.01.1.02/0.0/0.0/17_175/0015633','CZ.01.1.02/0.0/0.0/17_175/0015634','CZ.01.1.02/0.0/0.0/17_175/0015636','CZ.01.1.02/0.0/0.0/17_175/0015730','CZ.01.1.02/0.0/0.0/17_175/0015760','CZ.01.1.02/0.0/0.0/17_176/0015497','CZ.01.1.02/0.0/0.0/17_176/0015521','CZ.01.1.02/0.0/0.0/17_176/0015523','CZ.01.1.02/0.0/0.0/17_176/0015602','CZ.01.1.02/0.0/0.0/17_176/0015622','CZ.01.1.02/0.0/0.0/17_176/0015683','CZ.01.1.02/0.0/0.0/17_176/0015688','CZ.01.1.02/0.0/0.0/17_176/0015718','CZ.01.1.02/0.0/0.0/17_166/0014440','CZ.01.1.02/0.0/0.0/17_106/0012311','CZ.01.1.02/0.0/0.0/17_107/0012433','CZ.01.1.02/0.0/0.0/17_107/0012517','CZ.01.1.02/0.0/0.0/20_321/0024555','CZ.01.1.02/0.0/0.0/17_176/0015664','CZ.01.1.02/0.0/0.0/17_176/0015690','CZ.01.1.02/0.0/0.0/15_018/0004478','CZ.01.1.02/0.0/0.0/17_176/0014554')






GROUP BY p."Registraèní èíslo projektu",
       substr(p."Registraèní èíslo projektu",-5,5),
       p.zadatel,
       p."Název projektu CZ",
       p.id,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       -- platba."Datum proplacení pøíjemci",
       -- platba."Èíslo ¾ádosti o platbu" ,
       -- pril.NAZEVPRIL,
       -- pril."Link DMS" ,
       vs.pocet
