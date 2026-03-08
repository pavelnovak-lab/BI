SELECT 	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
	u.username,
	p."Registraèní èíslo projektu",
        p.kodwfstav,
	p.zadatel ,
	p."IÈ",
	p."Název projektu CZ",
	-- gg.eu,
	-- gg.czv,
	sd."VLASTNIK#Správce pøístupù",
	sd."Ètenáø",
	sd."Editor",
	sd."Signatáø",
	sd."Zástupce správce pøístupù",
	u.uzivatel
	-- listagg(vs."IÈ", '; ') "Vítìzný dodavatel IÈ",
	-- listagg(vs."Název subjektu", '; ') "Vítìzný dodavatel"

       
FROM isum.v_bi_UmzProjekt p
-- INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
INNER JOIN isum.v_bi_UMZPrjGGSdileni sd ON sd.id_nositelsdil = p.id
INNER JOIN isum.v_bi_CUzivatel u ON u.id = sd.id_uzivatel
-- LEFT JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.id_typsubjektu = 300786

WHERE p."Registraèní èíslo projektu" is not null
-- AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND u.username in ('KINOVPAV')
AND (sd."VLASTNIK#Správce pøístupù" = 'A' OR sd."Editor" = 'A')


-- GROUP BY SUBSTR(p.kompetencniutvar, 6 ) ,
-- 	u.username,
-- 	p."Registraèní èíslo projektu",
--         p.kodwfstav,
-- 	p.zadatel ,
-- 	p."IÈ",
-- 	p."Název projektu CZ",
-- 	gg.eu,
-- 	gg.czv,
-- 	sd."VLASTNIK#Správce pøístupù",
-- 	sd."Ètenáø",
-- 	sd."Editor",
-- 	sd."Signatáø",
-- 	sd."Zástupce správce pøístupù",
-- 	u.uzivatel


-- ORDER BY u.uzivatel

