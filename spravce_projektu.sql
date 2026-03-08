SELECT p."Registraèní èíslo projektu",
       p.KodPrioritniOsa ,
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" 

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMZPrjGGSdileni sd ON id_nositelsdil = p.id
INNER JOIN isum.v_bi_CUzivatel cu ON cu.id = sd.id_uzivatel

WHERE p."Registraèní èíslo projektu" is not null
AND (sd."Zástupce správce pøístupù" = 'A' or sd."VLASTNIK#Správce pøístupù" = 'A')
AND sd.platnost = 'A'
AND sd.create_uzivatel = 'GOSIRKAT'
-- AND p.kodwfstav in ('PP20','PU*','Z*','PP21','PP22','PP23a','PP23b','PP27a','PP27b','PP29','V*')

GROUP BY p.KodPrioritniOsa , p.kompetencniutvar

ORDER BY p.KodPrioritniOsa , p.kompetencniutvar

----------------------


SELECT 	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
	u.username,
	p."Registraèní èíslo projektu",
        p.kodwfstav,
	p.zadatel ,
	p."IÈ",
	p."Název projektu CZ",
	gg.eu,
	gg.czv,

	hist.VLASTNIK vlastnik_hist,
	hist.CTENARHODN ctenar_hist,
	hist.editor editor_hist,
 	hist.signatar signatar_hist,
	hist.zastupce zastupce_spravce_hist,
	hist.PLATIDO,
	hist.PLATIOD ,
	u.uzivatel
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
-- INNER JOIN isum.v_bi_UMZPrjGGSdileni sd ON sd.id_nositelsdil = p.id
INNER JOIN isum.v_bi_UMZSdileniHistorie hist ON hist.id_nositelsdil = p.id
INNER JOIN isum.v_bi_CUzivatel u ON u.id = hist.id_uzivatel

WHERE
p."Registraèní èíslo projektu" is not null
AND u.username = ( 'GOSIRKAT')

ORDER BY p."Registraèní èíslo projektu"


----------------------

SELECT 	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
	p."Registraèní èíslo projektu",
        p.kodwfstav Stav_prj,
	p.zadatel ,
	p."IÈ",
	p."Název projektu CZ",

	gg.eu,
	gg.czv,
	gg.eu/gg.czv "Procento podpory",

	hist.VLASTNIK vlastnik_hist,
	hist.CTENARHODN ctenar_hist,
	hist.editor editor_hist,
 	hist.signatar signatar_hist,
	hist.zastupce zastupce_spravce_hist,
	uu.uzivatel AS uzivatel_hist,
	uu.username ,

	-- u.uzivatel,
	-- u.username,
	-- sd."VLASTNIK#Správce pøístupù" AS vlastnik,
	-- sd."Ètenáø" ctenar,
	-- sd."Editor" editor,
 	-- sd."Signatáø" signatar,
	-- sd."Zástupce správce pøístupù" zastupce_spravce_pristupu,
	
	listagg(distinct  vs."IÈ", '; ' ON OVERFLOW TRUNCATE) AS "Vítìzný dod IÈ",
	listagg(distinct vs."Název subjektu", '; ' ON OVERFLOW TRUNCATE) AS  "Vítìzný dodavatel",
	listagg(distinct problem."Název Dodavatele", '; ' ON OVERFLOW TRUNCATE) AS "Dodavatel soupis" ,
	listagg(distinct problem."IÈO Dodavatele", '; ' ON OVERFLOW TRUNCATE) AS "IÈ dod soupis",

	CASE WHEN pl2.kodwfstav IS NOT NULL THEN 'Ano' ELSE 'Ne' END AS Proplaceno_s_kracenim	,

	sum(rf.CASTKASCHVALENA) 







FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
-- INNER JOIN isum.v_bi_UMZPrjGGSdileni sd ON sd.id_nositelsdil = p.id
-- INNER JOIN isum.v_bi_CUzivatel u ON u.id = sd.id_uzivatel
LEFT JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.kodwfstav in ('P10','P11')
LEFT JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = (361356) -- øádky cis."Kód" in ('10a') 
LEFT JOIN isum.v_bi_UmpPlatbaPrj pl2 ON pl2.id_nositelplatby = p.id AND pl2.kodwfstav = 'P11'
INNER JOIN isum.v_bi_UMZSdileniHistorie hist ON hist.id_nositelsdil = p.id
INNER JOIN isum.v_bi_CUzivatel uu ON uu.id = hist.id_uzivatel
LEFT JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.id_typsubjektu = 300786
LEFT JOIN (

SELECT  DISTINCT vs.id_prjgg,
	s."Název Dodavatele",
	s."IÈO Dodavatele"

FROM isum.v_bi_UmzPrjGGvs vs 
inner join isum.V_BI_UMFSOUPISKADOKLADPRJ s on s.ID_SUBJEKT=vs.ID

WHERE vs.ID_TYPSUBJEKTU = 300784
AND s."Èástka bez DPH pøipadající na" >0
) problem ON problem.id_prjgg = p.id




WHERE
p."Registraèní èíslo projektu" is not null
 -- p."Registraèní èíslo projektu" = 'CZ.01.3.14/0.0/0.0/19_252/0019769'
-- AND uu.username in ('UVHASNAI','GOSIRKAT','VWHASRAD','YCKHUBAO','VPROSSON')
-- AND ( vs."Název subjektu" = 'TAJMAC-ZPS, a.s.' or vs."Název subjektu" is null )
AND uu.username in ('HMKUBBAR','IBDOBLUD','QRBROZDE','GUNEZTOM','LUPALOND','WLKOTKAR')


GROUP BY SUBSTR(p.kompetencniutvar, 6 ) ,
	p."Registraèní èíslo projektu",
        p.kodwfstav ,
	p.zadatel ,
	p."IÈ",
	p."Název projektu CZ",

	gg.eu,
	gg.czv,

	pl2.kodwfstav,

	hist.VLASTNIK,
	hist.CTENARHODN,
	hist.editor ,
 	hist.signatar,
	hist.zastupce,
	uu.uzivatel ,
	uu.username 


	
	-- vs."IÈ" ,
	-- vs."Název subjektu" ,
	-- problem."Název Dodavatele" 

ORDER BY substr(p."Registraèní èíslo projektu",-5,5), uu.username asc
