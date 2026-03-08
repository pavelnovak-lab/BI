SELECT 	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
	p."Registraèní èíslo projektu",
        p.kodwfstav Stav_prj,
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
	uu.uzivatel AS uzivatel_hist,
	
	-- u.uzivatel,
	-- u.username,
	-- sd."VLASTNIK#Správce pøístupù" AS vlastnik,
	-- sd."Ètenáø" ctenar,
	-- sd."Editor" editor,
 	-- sd."Signatáø" signatar,
	-- sd."Zástupce správce pøístupù" zastupce_spravce_pristupu,
	
	vs."IÈ" "Vítìzný dodavatel IÈ",
	vs."Název subjektu"  "Vítìzný dodavatel",
	problem."Název Dodavatele" "Dodavatel ze soupisky",
	problem."IÈO Dodavatele" "IÈ dodavatele soupiska"
	
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
-- INNER JOIN isum.v_bi_UMZPrjGGSdileni sd ON sd.id_nositelsdil = p.id
-- INNER JOIN isum.v_bi_CUzivatel u ON u.id = sd.id_uzivatel
-- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.kodwfstav in ('P10','P11')
-- INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = (361356) -- øádky cis."Kód" in ('10a') 
-- LEFT JOIN isum.v_bi_UmpPlatbaPrj pl2 ON pl2.id_nositelplatby = p.id AND pl2.kodwfstav = 'P11'

INNER JOIN isum.v_bi_UMZSdileniHistorie hist ON hist.id_nositelsdil = p.id
INNER JOIN isum.v_bi_CUzivatel uu ON uu.id = hist.id_uzivatel
LEFT JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.id_typsubjektu = 300786
LEFT JOIN (

SELECT  DISTINCT vs.id_prjgg,
	s."Název Dodavatele",
	s."IÈO Dodavatele"
FROM isum.v_bi_UmzPrjGGvs vs 
inner join isum.V_BI_UMFSOUPISKADOKLADPRJ s on s.ID_SUBJEKT=vs.ID
-- inner join isum.V_BI_UMPPLATBAPRJ pl on pl.ID=s.ID_PLATBA

WHERE vs.ID_TYPSUBJEKTU = 300784
AND s."Èástka bez DPH pøipadající na" >0
-- AND vs."IÈ" = 25702556
-- AND s."Èíslo úèetního dokladu \nv úèe" like ('CZ.01.5%')
-- AND pl."Èíslo ¾ádosti o platbu" = ('CZ.01.1.02/0.0/0.0/17_125/0014421/2019/001/POST')
-- AND p."Registraèní èíslo projektu" = 'CZ.01.3.14/0.0/0.0/19_252/0019769'
-- AND LOWER(s."Název Dodavatele") like 'tajmac-zps%' 
) problem ON problem.id_prjgg = p.id




WHERE
-- AND sd.hodnoceni <> 'A'	
p."Registraèní èíslo projektu" is not null
-- AND u.username in ('GUNEZTOM','HQBROZDE','IBDOBLUD','LUPALOND','QRBROZDE','WLKOTKAR','UVHASNAI','GOSIRKAT','VWHASRAD')
 -- p."Registraèní èíslo projektu" = 'CZ.01.3.14/0.0/0.0/19_252/0019769'
-- AND ( vs."Název subjektu" = 'TAJMAC-ZPS, a.s.' or vs."Název subjektu" is null )


ORDER BY substr(p."Registraèní èíslo projektu",-5,5) asc
