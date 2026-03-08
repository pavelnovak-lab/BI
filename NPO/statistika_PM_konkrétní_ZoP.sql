SELECT	ak.nazev "Manažer projektu" ,
	hs."Číslo žádosti o platbu",
	hs."Dní v P4 (nevrácena)",
	hs.kodwfstav
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMZProjOdpovedn ak ON ak.ID_PRJGG = p.id AND ak.PLATNYUZIVATEL = 'A' AND ak.DATUMDO is null 
LEFT JOIN (
     SELECT hs.NositelId, platba.id_nositelplatby,
     platba."Číslo žádosti o platbu",
     platba.CISLOPLATBYZKR,
     platba.kodwfstav ,
     trunc(sysdate) - trunc(hs.datumod) "Dní v P4 (nevrácena)" ,
     count(hs.id) 
     FROM isum.v_bi_UmpPlatbaPrj platba 
     INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.nositelid = platba.id 
     WHERE stavdo = 'P4'
     AND platba.kodwfstav = 'P4'
     AND platba."Číslo žádosti o platbu" like 'CZ.31.3%'
     HAVING count(hs.id)=1
     GROUP BY hs.NOSITELID,
     	trunc(sysdate) - trunc(datumod),
 	platba."Číslo žádosti o platbu" ,
	platba.id_nositelplatby,
 	platba.CISLOPLATBYZKR, platba.kodwfstav 
	) hs ON  hs.id_nositelplatby = p.id



WHERE v."Číslo výzvy" in ('31_22_001', '31_22_005') 
-- AND p."Registrační číslo projektu" = 'CZ.31.3.0/0.0/0.0/22_001/0003409'
-- AND ak.nazev = 'Hála Zdeněk, Ing.'


-- GROUP BY ak.nazev

-- -- ORDER BY count(p.id) DESC 
