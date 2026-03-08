SELECT	pl."KOD",
	pl."Název programové linie",
	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	platba."Datum pøedlo¾ení" as "Datum pøedlo¾ení",
	v."Název výzvy" as "Název výzvy",
	p."Registraèní èíslo projektu" as "Registraèní èíslo projektu",
	p."ZADATEL" as "ZADATEL",
	platba."PORADI#Poøadí finanèního plánu" as "PORADI#Poøadí finanèního plánu",
	platba."WFSTAV" as "Stav ®opl",
	p."KODWFSTAV" as "KODWFSTAV",
	p."WFSTAV" as "Stav projektu",
	-- LISTAGG(DISTINCT odpovedni."NAZEV", '; ') as "PM",
	-- osoba."Email" as "Email",
	-- osoba."Jméno" as "Jméno",
	-- osoba."Pøíjmení" as "Pøíjmení",
	-- osoba."Mobil" as "Mobil",
	-- platba."SOUCTOVYRADEK" as "SOUCTOVYRADEK",
	-- odpovedni."ROLE" as "ROLE",
	-- odpovedni."DATUMDO" as "DATUMDO",
	platba.CISLOPLATBYZKR "Zkrácené èíslo ®oP" ,
	platba."VYUCTPLAN#Vyúètování plán" as CZV,
	((platba."VYUCTPLAN#Vyúètování plán"/100)*fp."PROC_EU") as "Dotace",
	platba."Závìreèná platba" as "Závìreèná platba",
	czv_schvalene.castkaschvalena "CZV Schválené",
	eu_schvalene.castkaschvalena "Dotace schválená"	,
	nvl(platba.kurz, 0) "Kurz",
	nvl(platba.kurz * czv_schvalene.castkaschvalena, 0) AS "CZV scvhálené EUR",
 	nvl(platba.kurz * eu_schvalene.castkaschvalena, 0) AS "Dotace scvhálené EUR"
 	-- LISTAGG(DISTINCT ci."Název", '; ') WITHIN GROUP(ORDER BY ci."Název")  "Tag"
			
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmsHiPLinie pl ON p."ID_PRIORITNIOSA"=pl.id  
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
-- INNER JOIN isum.v_bi_UmzProjOdpovedn odpovedni ON odpovedni.idprojekt =p.id
-- INNER JOIN isum.v_bi_UmsRsVerzesubjektu verzes ON verzes.id=p.id_zadatel
-- INNER JOIN isum.v_bi_UmsRsVerzeosoby osoba ON osoba.id=verzes.id_hlkontaktosoba
INNER JOIN isum.v_bi_UmfPFCelkem fp ON fp.id_projekt = p.ID
LEFT JOIN
(SELECT rf.CASTKASCHVALENA,
	rf.id_platba
 FROM isum.v_bi_UmpRozpisFin rf
 WHERE  rf.id_ukazatel = 361347 -- øádek 2, CZV	
) czv_schvalene ON czv_schvalene.id_platba = platba.id
LEFT JOIN
(SELECT rf.CASTKASCHVALENA,
	rf.id_platba
 FROM isum.v_bi_UmpRozpisFin rf
 WHERE rf.id_ukazatel = 361356 -- øádek 10a, dotace EU
) eu_schvalene ON eu_schvalene.id_platba = platba.id

-- LEFT JOIN isum.v_bi_UMZPrjGGTag tag ON p.id = tag.id_prjgg
-- LEFT JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = tag.id_tag


WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND p."Registraèní èíslo projektu" is not null 
AND fp.ID_FAZE=99991000000000005 -- sloupec aktuální stav 
AND platba.SOUCTOVYRADEK IS NULL
-- AND odpovedni.ROLE ='MAN_PRJ'
-- AND odpovedni.DATUMDO IS NULL
-- AND (ci."Název" not in ('Kvalitní PRJ','Chyba udr¾itelnost','brownfield','Tesco SW','úèinná spolupráce','Oponentní øízení') OR ci."Název" is null) 
AND platba.ID = 1282152996 -- zop CZ.01.1.02/0.0/0.0/20_358/0027098/2022/001/POST

-- GROUP BY pl."KOD",
-- 	pl."Název programové linie",
-- 	platba."Datum pøedlo¾ení",
-- 	v."Název výzvy",
-- 	p."Registraèní èíslo projektu",
-- 	p."ZADATEL",
-- 	platba."PORADI#Poøadí finanèního plánu",
-- 	platba."WFSTAV",
-- 	p."KODWFSTAV",
-- 	p."WFSTAV",
-- 	osoba."Email",
-- 	osoba."Jméno",
-- 	osoba."Pøíjmení",
-- 	osoba."Mobil",
-- 	platba."SOUCTOVYRADEK",
-- 	odpovedni."ROLE",
-- 	odpovedni."DATUMDO",
-- 	platba."VYUCTPLAN#Vyúètování plán",
-- 	((platba."VYUCTPLAN#Vyúètování plán"/100)*fp."PROC_EU"),
-- 	platba."Závìreèná platba"

-- ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC , platba."PORADI#Poøadí finanèního plánu" 



--------------------------------------------

SELECT ci."Název", ci."Kód", rf.*

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id -- AND rf.id_ukazatel in ( 361346, 361347, 361356, 361370 ) -- øádky cis."Kód" in ('1','2','10a','17a')
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  rf.id_ukazatel

where platba.id = 1282152996

-------------------------------------------------------



select
	-- hip.kod,
	-- hip."Název programové linie",
	pl."Datum pøedlo¾ení",
	v."Název výzvy",
	p."Registraèní èíslo projektu",
	p.zadatel,
	pl."PORADI#Poøadí finanèního plánu",
	pl.wfstav as "Stav ®opl",
	s."datum prvního stavu P4",
	p.kodwfstav,
	p.wfstav,
	-- od.nazev,
	-- os."Email",
	-- os."Jméno",
	-- os."Pøíjmení",
	-- os."Mobil",
	-- pl.souctovyradek,
	-- od.role,
	-- od.datumdo,
	pl."VYUCTPLAN#Vyúètování plán" as CZV,
	((pl."VYUCTPLAN#Vyúètování plán"/100)*pf.proc_eu) as "Dotace",
	pl."Závìreèná platba"	

from isum.v_bi_umzprojekt p
inner join isum.v_bi_umzvyzva v on v.id = p.id_vyzva
inner join isum.v_bi_umpplatba pl on pl.id_nositelplatby = p.id
inner join isum.v_bi_umfpfcelkem pf on pf.id_projekt = p.id
inner join isum.v_bi_umzprojodpovedn od on od.idprojekt = p.id
-- inner join isum.v_bi_umshiplinie hip on hip.id = p.id_prioritniosa
-- inner join isum.v_bi_umsrsverzesubjektu vs on vs.id = p.id_zadatel
-- inner join isum.v_bi_umsrsverzeosoby os on os.id=vs.id_hlkontaktosoba
left outer join 

(select hi.nositelid,
	min(hi.datumod) as "datum prvního stavu P4"
from isum.v_bi_umswfhistoriestavu hi
where hi.stavdo = 'P4'
group by hi.nositelid)s on s.nositelid=pl.id

where pf.id_faze = 99991000000000005
and pl.souctovyradek is null
and od.role = 'MAN_PRJ'
and od.datumdo is null

AND p."Registraèní èíslo projektu" = 'CZ.01.3.14/0.0/0.0/17_153/0011251'




CZ.01.2.06/0.0/0.0/20_344/0027699|CZ.01.2.06/0.0/0.0/20_344/0027708|CZ.01.1.02/0.0/0.0/20_358/0028040|CZ.01.5.125/0.0/0.0/15_020/0027901|CZ.01.5.125/0.0/0.0/15_020/0027901|CZ.01.1.02/0.0/0.0/20_358/0028135|CZ.01.1.02/0.0/0.0/20_358/0028136|CZ.01.1.02/0.0/0.0/20_358/0028137
