SELECT 	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
	p."Registrační číslo projektu",
        p.kodwfstav Stav_prj,
	p.zadatel ,
	p."IČ",
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
	-- sd."VLASTNIK#Správce přístupů" AS vlastnik,
	-- sd."Čtenář" ctenar,
	-- sd."Editor" editor,
 	-- sd."Signatář" signatar,
	-- sd."Zástupce správce přístupů" zastupce_spravce_pristupu,
	
	listagg(distinct  vs."IČ", '; ' ON OVERFLOW TRUNCATE) AS "Vítězný dod IČ",
	listagg(distinct vs."Název subjektu", '; ' ON OVERFLOW TRUNCATE) AS  "Vítězný dodavatel",
	listagg(distinct problem."Název Dodavatele", '; ' ON OVERFLOW TRUNCATE) AS "Dodavatel soupis" ,
	listagg(distinct problem."IČO Dodavatele", '; ' ON OVERFLOW TRUNCATE) AS "IČ dod soupis",

	CASE WHEN pl2.kodwfstav IS NOT NULL THEN 'Ano' ELSE 'Ne' END AS Proplaceno_s_kracenim	,

	sum(rf.CASTKASCHVALENA) 







FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
-- INNER JOIN isum.v_bi_UMZPrjGGSdileni sd ON sd.id_nositelsdil = p.id
-- INNER JOIN isum.v_bi_CUzivatel u ON u.id = sd.id_uzivatel
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.kodwfstav in ('P10','P11')
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = (361356) -- řádky cis."Kód" in ('10a') 
LEFT JOIN isum.v_bi_UmpPlatbaPrj pl2 ON pl2.id_nositelplatby = p.id AND pl2.kodwfstav = 'P11'
INNER JOIN isum.v_bi_UMZSdileniHistorie hist ON hist.id_nositelsdil = p.id
INNER JOIN isum.v_bi_CUzivatel uu ON uu.id = hist.id_uzivatel
LEFT JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.id_typsubjektu = 300786
LEFT JOIN (

SELECT  DISTINCT vs.id_prjgg,
	s."Název Dodavatele",
	s."IČO Dodavatele"

FROM isum.v_bi_UmzPrjGGvs vs 
inner join isum.V_BI_UMFSOUPISKADOKLADPRJ s on s.ID_SUBJEKT=vs.ID

WHERE vs.ID_TYPSUBJEKTU = 300784
AND s."Částka bez DPH připadající na" >0
) problem ON problem.id_prjgg = p.id




WHERE
p."Registrační číslo projektu" is not null
 -- p."Registrační číslo projektu" = 'CZ.01.3.14/0.0/0.0/19_252/0019769'
-- AND uu.username in ('UVHASNAI','GOSIRKAT','VWHASRAD','YCKHUBAO','VPROSSON')
-- AND ( vs."Název subjektu" = 'TAJMAC-ZPS, a.s.' or vs."Název subjektu" is null )
AND u.username in ('HMKUBBAR','IBDOBLUD','QRBROZDE','GUNEZTOM','LUPALOND','WLKOTKAR')


GROUP BY SUBSTR(p.kompetencniutvar, 6 ) ,
	p."Registrační číslo projektu",
        p.kodwfstav ,
	p.zadatel ,
	p."IČ",
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


	
	-- vs."IČ" ,
	-- vs."Název subjektu" ,
	-- problem."Název Dodavatele" 

ORDER BY substr(p."Registrační číslo projektu",-5,5), uu.username asc
