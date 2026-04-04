SELECT
	cis."Název" AS "Právní forma",


	p."Registrační číslo projektu",

	REPLACE(REPLACE(p."Anotace projektu",CHR(10),' $ '),CHR(13),' $ ') as "Anotace projektu",	
	p.KODWFSTAV,
	p.ZADATEL,
	REPLACE(p.KodPrioritniOsa,'01.','') AS "Prioriní osa",  
	p.kodspecifcil,
	p.kompetence,
	p.specifcil,
	p.velikostpodniku,
	p.wfstav,
	p."Datum ukončení předp",
	p."Datum ukončení skut",
	p."Datum zahájení předp",
	p."Datum zahájení skut",
   	p."Název projektu CZ",

        v."Název výzvy",
	v."Číslo výzvy",
	pggvs."IČ",
 	pggvs."Počet zaměstnanců",
	gg."EU" AS "Požadovaná dotace",
	gg."CZV" AS "Celkové způsobilé výdaje",
	LISTAGG(DISTINCT cis_2."Název",'; ') AS "Kraj realizace",
	LISTAGG(DISTINCT uzjed."Název",'; ') AS "Název územní jednotky",
	LISTAGG(DISTINCT uzjed.urovennazev,'; ') AS urovennazev,

	LISTAGG(ci."Kód",'; ') AS "Kód CZ NACE",
	LISTAGG(ci."Název",'; ') AS "Název CZ NACE"
	
	-- o1.nazev as "hl.k.o",
	-- o1.mail as "Email",
	-- o1.telefon as "Tel",
	-- o1.mobil as "MobilniTel",
	-- o2.nazev2 as "Statutari",
	-- o2.mail2 as "MailStatut",
        -- o2.telefon2 as "TelStatut",
	-- o2.mobil2 as "MobilStatut"


FROM 		isum.v_bi_umzprojekt p
INNER JOIN	isum.v_bi_umzprjggvs pggvs ON pggvs.id=p.id_zadatel  
INNER JOIN	isum.v_bi_umzvyzva v ON p.id_vyzva=v.id
INNER JOIN	isum.v_bi_umsrscznace n ON n.id_projekt=p.id
INNER JOIN 	isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
INNER JOIN	isum.v_bi_umzprjgg gg ON gg.id=p.id
INNER JOIN 	isum.V_BI_UMZPRJUMISTENI umist ON umist.id_projekt=p.id AND umist.typ = 1
INNER JOIN 	isum.V_BI_UMSCisUzemniJednotky uzjed ON umist.id_uzemnijednotky=uzjed.id
INNER JOIN	isum.v_bi_UmsCisZakladni cis ON pggvs.id_HOSPPRAVFORMA=cis.id
INNER JOIN	isum.V_BI_UMZPRJKI ki ON ki.id_projekt=p.id
INNER JOIN	isum.v_bi_UmsCisZakladni cis_2 ON ki.id_ki=cis_2.id AND cis_2.id_CisSeznam=198443




-- left join ISUM.V_BI_UMSRSVERZEADRESY adr on pggvs.id_oficialniadresa=adr.id
-- left join 
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
-- p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/15_002/0000004','CZ.01.1.02/0.0/0.0/16_084/0010377')
-- 
-- AND   p.kodprioritniosa='01.2'
-- AND v."Číslo výzvy"='01_17_106'
-- AND p.kompetence='Aplikace'
-- p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/17_106/0012345','CZ.01.1.02/0.0/0.0/17_093/0012346','CZ.01.1.02/0.0/0.0/17_107/0012347','CZ.01.1.02/0.0/0.0/17_093/0012348')

GROUP BY p."Registrační číslo projektu", p.specifcil, p.kodspecifcil, pggvs."IČ", pggvs."Počet zaměstnanců", v."Číslo výzvy", v."Název výzvy", gg."EU", gg."CZV", p."Název projektu CZ", p."Anotace projektu", p.ZADATEL, p.KODWFSTAV, p.velikostpodniku, cis."Název", p.kompetence, p.wfstav, p."Datum ukončení předp", p."Datum ukončení skut", p."Datum zahájení předp", p."Datum zahájení skut", p.KodPrioritniOsa

-- o1.nazev, o1.mail, o1.telefon, o1.mobil, o2.nazev2, o2.mail2, o2.telefon2, o2.mobil2 , 

/*
Bude dát třeba pozor na
* info, o plnění kodu/popis - SC, NACE, KODSTAVU
* ohlídat zahraniční IČO
* Projekt s více kraji realizace CZ.01.1.02/0.0/0.0/16_084/0010377
*/
