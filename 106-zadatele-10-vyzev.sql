SELECT	p."Registrační číslo projektu",
	p."Název projektu CZ" ,
	p.KODWFSTAV,
	p.ZADATEL,
	p.kompetence as "Program podpory",
	p.wfstav,

        v."Název výzvy",
-- 	v."Číslo výzvy",

	gg."EU" AS "Požadovaná dotace",
	gg."CZV" AS "Celkové způsobilé výdaje",

	listagg (uzjed."Název", '; ') AS "Místo realizace"
	-- uzjed.urovennazev,

	-- o1.nazev as "hl.k.o",
	-- o1.mail as "Email"


-- o1.telefon as "Tel",
	-- o1.mobil as "MobilniTel",
	-- o2.nazev2 as "Statutari",
	-- o2.mail2 as "MailStatut",
        -- o2.telefon2 as "TelStatut",
	-- o2.mobil2 as "MobilStatut"


FROM 		isum.v_bi_umzprojekt p
INNER JOIN	isum.v_bi_umzprjggvs pggvs ON pggvs.id=p.id_zadatel  
INNER JOIN	isum.v_bi_umzvyzva v ON p.id_vyzva=v.id
INNER JOIN	isum.v_bi_umzprjgg gg ON gg.id=p.id
INNER JOIN 	isum.V_BI_UMZPRJUMISTENI umist ON umist.id_projekt=p.id AND umist.typ = 1
INNER JOIN 	isum.V_BI_UMSCisUzemniJednotky uzjed ON umist.id_uzemnijednotky=uzjed.id

-- INNER JOIN	isum.V_BI_UMZPRJKI ki ON ki.id_projekt=p.id
-- INNER JOIN	isum.v_bi_UmsCisZakladni cis_2 ON ki.id_ki=cis_2.id AND cis_2.id_CisSeznam=198443
-- LEFT JOIN 	isum.v_bi_UMSRSVerzeAdresy adr on pggvs.id_oficialniadresa=adr.id
-- LEFT JOIN 
-- 	(select
-- 		(LISTAGG (CONCAT(o."Jméno", (concat(' ',o."Příjmení"))), ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' 

-- ',o."Příjmení")))) ) AS nazev,
-- 		(LISTAGG (o."Email", ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Příjmení")))) ) AS mail,
-- 		(LISTAGG (o."Telefon", ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Příjmení")))) ) AS telefon,
-- 		(LISTAGG (o."Mobil", ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Příjmení")))) ) AS mobil,
-- 		o.id_verzesubjektu as vazba
-- 		from isum.v_bi_umsrsverzeosoby o
-- 		inner join isum.v_bi_umzprjggvs vs on vs.id_verzesubjektu=o.id_verzesubjektu
-- 		where o."Hlavní kontaktní osoba" ='A'
-- 		group by o.id_verzesubjektu
-- 		) o1 on o1.vazba=pggvs.id_verzesubjektu
-- left join 
-- 	(select
-- 		(LISTAGG (CONCAT(ox."Jméno", (concat(' ',ox."Příjmení"))), ', ') WITHIN GROUP (ORDER BY CONCAT(ox."Jméno", (concat(' ',ox."Příjmení")))) ) AS nazev2,
-- 		(LISTAGG (ox."Email", ', ') WITHIN GROUP (ORDER BY CONCAT(ox."Jméno", (concat(' ',ox."Příjmení")))) ) AS mail2,
-- 		(LISTAGG (ox."Telefon", ', ') WITHIN GROUP (ORDER BY CONCAT(ox."Jméno", (concat(' ',ox."Příjmení")))) ) AS telefon2,
-- 		(LISTAGG (ox."Mobil", ', ') WITHIN GROUP (ORDER BY CONCAT(ox."Jméno", (concat(' ',ox."Příjmení")))) ) AS mobil2,
-- 		ox.id_verzesubjektu as vazba2
-- 		from isum.v_bi_umsrsverzeosoby ox
-- 		inner join isum.v_bi_umzprjggvs vs on vs.id_verzesubjektu=ox.id_verzesubjektu
-- 		where ox."Statutární zástupce"='A'
-- 		group by ox.id_verzesubjektu
-- 		) o2 on o2.vazba2=pggvs.id_verzesubjektu

WHERE p."Registrační číslo projektu" is not null 
AND   p.kodwfstav not like 'PN%'
AND   v."Číslo výzvy" in ('01_17_164','01_20_339','01_20_338','01_20_357','01_20_322','01_20_321','01_20_318','01_20_371','01_20_370')

GROUP BY p."Registrační číslo projektu",
      p."Název projektu CZ",
      p.KODWFSTAV,
	p.ZADATEL,
	p.kompetence,
	p.wfstav,

        v."Název výzvy",

	gg."EU" ,
	gg."CZV" 


ORDER BY p.kompetence



