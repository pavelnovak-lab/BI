SELECT 	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
	u.username,
	p."Registrační číslo projektu",
        p.kodwfstav,
	p.zadatel ,
	p."IČ",
	p."Název projektu CZ",
	gg.eu,
	gg.czv,
	sd."VLASTNIK#Správce přístupů",
	sd."Čtenář",
	sd."Editor",
	sd."Signatář",
	sd."Zástupce správce přístupů",
	u.uzivatel
	-- listagg(vs."IČ", '; ') "Vítězný dodavatel IČ",
	-- listagg(vs."Název subjektu", '; ') "Vítězný dodavatel"
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
INNER JOIN isum.v_bi_UMZPrjGGSdileni sd ON sd.id_nositelsdil = p.id
INNER JOIN isum.v_bi_CUzivatel u ON u.id = sd.id_uzivatel
-- LEFT JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.id_typsubjektu = 300786

WHERE
-- AND sd.hodnoceni <> 'A'
p."Registrační číslo projektu" is not null

--AND u.username in ('GUNEZTOM','HQBROZDE','IBDOBLUD','LUPALOND','QRBROZDE','WLKOTKAR')

AND u.username in ( 'DGNEUNIK', 'LIVILMIR')

-- AND p."Registrační číslo projektu" = 'CZ.01.3.14/0.0/0.0/19_252/0022357'

-- GROUP BY SUBSTR(p.kompetencniutvar, 6 ) ,
-- 	u.username,
-- 	p."Registrační číslo projektu",
--         p.kodwfstav,
-- 	p.zadatel ,
-- 	p."IČ",
-- 	p."Název projektu CZ",
-- 	gg.eu,
-- 	gg.czv,
-- 	sd."VLASTNIK#Správce přístupů",
-- 	sd."Čtenář",
-- 	sd."Editor",
-- 	sd."Signatář",
-- 	sd."Zástupce správce přístupů",
-- 	u.uzivatel


ORDER BY p."Registrační číslo projektu" 
