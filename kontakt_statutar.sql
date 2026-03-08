
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
LEFT JOIN isum.v_bi_UMZPrjGGSdileni sd ON sd.id_nositelsdil = p.id
INNER JOIN isum.v_bi_CUzivatel u ON u.id = sd.id_uzivatel

where p.id_vyzva = 1806915184




SELECT p."Název projektu CZ" ,
       p."Identifikace ¾ádosti (Hash)" ,
       p.zadatel ,
       p.create_uzivatel,
       u.*

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_CUzivatel u ON u.username = p.create_uzivatel


where p.id_vyzva = 1806915184



