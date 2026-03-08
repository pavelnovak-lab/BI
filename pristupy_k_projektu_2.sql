SELECT 	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
	u.username,
	p."Registraèní èíslo projektu" ,
        p.kodwfstav,
	p.zadatel ,
	p."IÈ",
	p."Název projektu CZ",
	sd."VLASTNIK#Správce pøístupù",
	sd."Ètenáø",
	sd."Editor",
	sd."Signatáø",
	u.uzivatel,
	listagg(DISTINCT vs."IÈ", '; ') "Dodavatelé IÈ",
	listagg(DISTINCT vs."Název subjektu", '; ') "Dodavatelé",
	listagg(DISTINCT hvs."IÈ", '; ') "Zamìstanavatelé  IÈ",
	listagg(DISTINCT hvs."Název subjektu", '; ') "Zamìstnavatelé"

       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMZPrjGGSdileni sd ON sd.id_nositelsdil = p.id
INNER JOIN isum.v_bi_CUzivatel u ON u.id = sd.id_uzivatel
LEFT JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.id_typsubjektu = 300786
INNER JOIN isum.v_bi_UmvHodnotitel hodn ON hodn.create_uzivatel = u.username
LEFT JOIN isum.v_bi_UMVHodnVerzeSubjektu hvs ON hvs.id_hodnotitel = hodn.id


WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 
AND u.username in ('HANOVPET','ITKOUMAR','IIBARMIC','JTPESMAR','ICSEDANN','IBPOSMIL','HMHOLMAR','NRCECJIR','QRJANDAN')
AND hvs."Zamestnavatel" = 'A'
AND ( sd."VLASTNIK#Správce pøístupù" = 'A' OR sd."Ètenáø" = 'A' OR sd."Editor" = 'A' OR sd."Signatáø" = 'A')


GROUP BY SUBSTR(p.kompetencniutvar, 6 ),
	u.username,
	p."Registraèní èíslo projektu",
        p.kodwfstav,
	p.zadatel ,
	p."IÈ",
	p."Název projektu CZ",
	sd."VLASTNIK#Správce pøístupù",
	sd."Ètenáø",
	sd."Editor",
	sd."Signatáø",
	u.uzivatel


ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC , u.username ASC



--------------------------------------------

SELECT hodn."Název" "Jméno EH",
       hvs."Název subjektu",
       hvs."IÈ",
       hvs."Zamestnavatel" ,
       hvs."Aktuální"

FROM isum.v_bi_UmvHodnotitel hodn
INNER JOIN isum.v_bi_UMVHodnVerzeSubjektu hvs ON hvs.id_hodnotitel = hodn.id

WHERE hodn.id = 94205867
AND hvs."Zamestnavatel" = 'A'
