SELECT	
	p."Identifikace ¾ádosti (Hash)" ,
        p.kodwfstav,
	p.zadatel ,
	p."IÈ",
	p."Název projektu CZ"
	-- gg.eu,
	-- gg.czv,
	-- sd."VLASTNIK#Správce pøístupù",
	-- sd."Ètenáø",
	-- sd."Editor",
	-- sd."Signatáø",
	-- sd."Zástupce správce pøístupù"
	-- -- u.uzivatel,
	-- u.username,
	-- listagg(vs."IÈ", '; ') "Vítìzný dodavatel IÈ",
	-- listagg(vs."Název subjektu", '; ') "Vítìzný dodavatel"

       
FROM isum.v_bi_UmzPrjGG p
-- INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
INNER JOIN isum.v_bi_UMZPrjGGSdileni sd ON sd.id_nositelsdil = p.id
-- INNER JOIN isum.v_bi_CUzivatel u ON u.id = sd.id_uzivatel
-- LEFT JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.id_typsubjektu = 300786

WHERE p."Identifikace ¾ádosti (Hash)" = '1OiXNwP' -- ADS.CZ


ORDER BY u.uzivatel

