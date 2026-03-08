SELECT p."Registraèní èíslo projektu",
       substr(p."Registraèní èíslo projektu",-5,5) "Projekt" ,
       p.zadatel,
       p."Název projektu CZ",
       p.id,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       LISTAGG( platba."Datum proplacení pøíjemci", '; ')  "Datum proplacení pøíjemci" ,
       LISTAGG( platba."Èíslo ¾ádosti o platbu", '; ') "Èíslo ¾ádosti o platbu",
       pril.NAZEVPRIL,
       pril."Link DMS" ,
       vs.pocet "Poèet partnerù",
       sum(czv.czv) "suma czv",
       sum(eu.eu) "suma eu",
       count(platba.id),
       LISTAGG( platba."Závìreèná platba", '; ') "Závìreèná platba"
       -- LISTAGG( prp."Link DMS" , '; ') "Kontrolní tabulka"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id = p.id_vyzva 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id = platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UMFSmlouva sml ON  sml.id_nositelsml = p.id
INNER JOIN isum.v_bi_UMSPrilohyPA pril ON pril.id_nositelpril = sml.id
-- LEFT JOIN (SELECT isum.v_bi_UMSPrilohy prp ON prp.id_nositelpril = platba.id AND (upper(prp."Název dokumentu") like upper('%kontrolni tabulka%') OR upper(prp."Název dokumentu") like upper('%kontrolní tabulka%'))
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
AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'
-- AND v."Èíslo výzvy" IN ('01_17_106','01_17_107','01_17_175','01_17_176','01_19_262','01_20_321')
-- AND p."Registraèní èíslo projektu" IN ('CZ.01.1.02/0.0/0.0/17_176/0015727')
-- AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/20_321/0023609'
AND to_date('2021-12-31','yyyy-mm-dd') < platba."Datum proplacení pøíjemci"
AND platba."Datum proplacení pøíjemci" < to_date('2023-01-01','yyyy-mm-dd')  
AND (platba.kodwfstav = 'P10' OR platba.kodwfstav like 'P1%' )
AND upper(pril.NAZEVPRIL) like upper('%Rozpoèet%')
AND sml."Poøadí" = 1
AND exists
(SELECT pl."Èíslo ¾ádosti o platbu" 
 from isum.v_bi_UmpPlatbaPrj pl
 WHERE pl.id_NositelPlatby = p.id  
 AND pl."Závìreèná platba" = 'A'
 AND to_date('2021-12-31','yyyy-mm-dd') < pl."Datum proplacení pøíjemci"
 AND pl."Datum proplacení pøíjemci" < to_date('2023-01-01','yyyy-mm-dd')  )


GROUP BY p."Registraèní èíslo projektu",
       substr(p."Registraèní èíslo projektu",-5,5),
       p.zadatel,
       p."Název projektu CZ",
       p.id,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       -- platba."Datum proplacení pøíjemci",
       -- platba."Èíslo ¾ádosti o platbu" ,
       pril.NAZEVPRIL,
       pril."Link DMS" ,
       vs.pocet


----------------------------------------
SELECT p."Registraèní èíslo projektu",
       substr(p."Registraèní èíslo projektu",-5,5) "Projekt" ,
       platba."Èíslo ¾ádosti o platbu" ,
       LISTAGG(prp."Link DMS" , '; ') "Link kontrolní tabulku"
       count(prp.id) "Poèet kontrolních tabulek"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
LEFT JOIN isum.v_bi_UMSPrilohy prp ON prp.id_nositelpril = platba.id AND (upper(prp."Název dokumentu") like upper('%kontrolni tabulka%') OR upper(prp."Název dokumentu") like upper('%kontrolní tabulka%'))

WHERE platba."Èíslo ¾ádosti o platbu" IN ('CZ.01.1.02/0.0/0.0/15_018/0004478/2019/002/POST','CZ.01.1.02/0.0/0.0/15_019/0000735/2018/003/POST','CZ.01.1.02/0.0/0.0/15_019/0004676/2019/005/POST','CZ.01.1.02/0.0/0.0/15_019/0004815/2021/004/POST','CZ.01.1.02/0.0/0.0/16_084/0009908/2021/004/POST','CZ.01.1.02/0.0/0.0/16_084/0010281/2021/005/POST','CZ.01.1.02/0.0/0.0/16_084/0010312/2021/003/POST','CZ.01.1.02/0.0/0.0/17_106/0012273/2022/003/POST','CZ.01.1.02/0.0/0.0/17_106/0012281/2021/002/POST','CZ.01.1.02/0.0/0.0/17_106/0012285/2021/004/POST','CZ.01.1.02/0.0/0.0/17_106/0012289/2021/003/POST','CZ.01.1.02/0.0/0.0/17_106/0012292/2022/003/POST','CZ.01.1.02/0.0/0.0/17_106/0012311/2021/002/POST','CZ.01.1.02/0.0/0.0/17_106/0012442/2021/007/POST','CZ.01.1.02/0.0/0.0/17_106/0012475/2022/003/POST','CZ.01.1.02/0.0/0.0/17_106/0012500/2021/003/POST','CZ.01.1.02/0.0/0.0/17_106/0012522/2022/002/POST','CZ.01.1.02/0.0/0.0/17_107/0012333/2021/004/POST','CZ.01.1.02/0.0/0.0/17_107/0012336/2021/003/POST','CZ.01.1.02/0.0/0.0/17_107/0012337/2020/004/POST','CZ.01.1.02/0.0/0.0/17_107/0012396/2021/004/POST','CZ.01.1.02/0.0/0.0/17_107/0012430/2021/002/POST','CZ.01.1.02/0.0/0.0/17_107/0012433/2021/003/POST','CZ.01.1.02/0.0/0.0/17_107/0012435/2022/004/POST','CZ.01.1.02/0.0/0.0/17_107/0012448/2019/002/POST','CZ.01.1.02/0.0/0.0/17_107/0012448/2022/003/POST','CZ.01.1.02/0.0/0.0/17_107/0012517/2021/004/POST','CZ.01.1.02/0.0/0.0/17_107/0012547/2021/003/POST','CZ.01.1.02/0.0/0.0/17_166/0014440/2021/004/POST','CZ.01.1.02/0.0/0.0/17_175/0014505/2021/003/POST','CZ.01.1.02/0.0/0.0/17_175/0014979/2021/002/POST','CZ.01.1.02/0.0/0.0/17_175/0015370/2021/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015440/2022/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015484/2022/006/POST','CZ.01.1.02/0.0/0.0/17_175/0015498/2022/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015541/2022/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015546/2022/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015558/2022/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015559/2022/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015577/2022/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015587/2022/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015596/2021/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015598/2022/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015603/2022/006/POST','CZ.01.1.02/0.0/0.0/17_175/0015633/2022/004/POST','CZ.01.1.02/0.0/0.0/17_175/0015633/2022/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015634/2022/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015636/2022/004/POST','CZ.01.1.02/0.0/0.0/17_175/0015636/2022/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015642/2021/001/POST','CZ.01.1.02/0.0/0.0/17_175/0015677/2021/004/POST','CZ.01.1.02/0.0/0.0/17_175/0015730/2022/003/POST','CZ.01.1.02/0.0/0.0/17_175/0015737/2022/001/POST','CZ.01.1.02/0.0/0.0/17_175/0015752/2021/004/POST','CZ.01.1.02/0.0/0.0/17_175/0015760/2022/005/POST','CZ.01.1.02/0.0/0.0/17_175/0015760/2021/004/POST','CZ.01.1.02/0.0/0.0/17_176/0014554/2022/003/POST','CZ.01.1.02/0.0/0.0/17_176/0015497/2022/003/POST','CZ.01.1.02/0.0/0.0/17_176/0015523/2022/003/POST','CZ.01.1.02/0.0/0.0/17_176/0015523/2021/002/POST','CZ.01.1.02/0.0/0.0/17_176/0015573/2022/003/POST','CZ.01.1.02/0.0/0.0/17_176/0015602/2022/003/POST','CZ.01.1.02/0.0/0.0/17_176/0015622/2022/005/POST','CZ.01.1.02/0.0/0.0/17_176/0015664/2021/005/POST','CZ.01.1.02/0.0/0.0/17_176/0015680/2021/003/POST','CZ.01.1.02/0.0/0.0/17_176/0015683/2022/004/POST','CZ.01.1.02/0.0/0.0/17_176/0015688/2022/002/POST','CZ.01.1.02/0.0/0.0/17_176/0015690/2021/003/POST','CZ.01.1.02/0.0/0.0/17_176/0015718/2022/005/POST','CZ.01.1.02/0.0/0.0/19_262/0019258/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0019720/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0019720/2022/003/POST','CZ.01.1.02/0.0/0.0/19_262/0019878/2021/001/POST','CZ.01.1.02/0.0/0.0/19_262/0019917/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0019927/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0019954/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0020025/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0020034/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0020055/2021/001/POST','CZ.01.1.02/0.0/0.0/19_262/0020055/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0020065/2021/002/POST','CZ.01.1.02/0.0/0.0/19_262/0020114/2022/001/POST','CZ.01.1.02/0.0/0.0/19_262/0020122/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0020124/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0020133/2022/003/POST','CZ.01.1.02/0.0/0.0/19_262/0020141/2021/002/POST','CZ.01.1.02/0.0/0.0/19_262/0020143/2022/003/POST','CZ.01.1.02/0.0/0.0/19_262/0020178/2021/001/POST','CZ.01.1.02/0.0/0.0/19_262/0020178/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0020182/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0020213/2022/003/POST','CZ.01.1.02/0.0/0.0/19_262/0020226/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0020238/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0020240/2022/002/POST','CZ.01.1.02/0.0/0.0/19_262/0020257/2022/002/POST','CZ.01.1.02/0.0/0.0/20_321/0023605/2022/002/POST','CZ.01.1.02/0.0/0.0/20_321/0023609/2022/001/POST','CZ.01.1.02/0.0/0.0/20_321/0023783/2022/001/POST','CZ.01.1.02/0.0/0.0/20_321/0024194/2022/001/POST','CZ.01.1.02/0.0/0.0/20_321/0024293/2022/001/POST','CZ.01.1.02/0.0/0.0/20_321/0024364/2022/001/POST','CZ.01.1.02/0.0/0.0/20_321/0024375/2022/001/POST')
AND platba."Závìreèná platba" = 'A'

GROUP BY p."Registraèní èíslo projektu",
       substr(p."Registraèní èíslo projektu",-5,5),
       platba."Èíslo ¾ádosti o platbu" 
