SELECT	p."Registrační číslo projektu" ,
	REPLACE(p.KodPrioritniOsa,'01.','') AS "Prioritní osa",
	p.zadatel,
	p."Název projektu CZ",
	p.id_zadatel,
	p.wfstav,
	p.kodwfstav,
	p."IČ",
	v."Číslo výzvy",
        v."Název výzvy",
	gg."EU" AS "Požadovaná dotace",
	gg."CZV" AS "Celkové způsobilé výdaje",
	o1.nazev as "hl.k.o",
	o1.mail as "Email"



FROM 		isum.v_bi_UmzProjekt p
INNER JOIN	isum.v_bi_umzprjggvs pggvs ON pggvs.id=p.id_zadatel  
INNER JOIN	isum.v_bi_umzvyzva v ON p.id_vyzva=v.id
INNER JOIN	isum.v_bi_umzprjgg gg ON gg.id=p.id

-- LEFT JOIN	 isum.v_bi_umsrsverzeadresy adr on pggvs.id_oficialniadresa=adr.id
LEFT JOIN 
	(SELECT
		(LISTAGG (CONCAT(o."Jméno", (concat(' ',o."Příjmení"))), ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Příjmení")))) ) AS nazev,
		(LISTAGG (o."Email", ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Příjmení")))) ) AS mail,
		(LISTAGG (o."Telefon", ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Příjmení")))) ) AS telefon,
		(LISTAGG (o."Mobil", ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Příjmení")))) ) AS mobil,
		o.id_verzesubjektu as vazba
		from isum.v_bi_umsrsverzeosoby o
		inner join isum.v_bi_umzprjggvs vs on vs.id_verzesubjektu=o.id_verzesubjektu
		where o."Hlavní kontaktní osoba" ='A'
		group by o.id_verzesubjektu
		) o1 on o1.vazba=pggvs.id_verzesubjektu

WHERE	p."Registrační číslo projektu" is not null

--- in ('CZ.01.1.02/0.0/0.0/17_106/0012345','CZ.01.1.02/0.0/0.0/17_093/0012346','CZ.01.2.06/0.0/0.0/16_059/0008095','CZ.01.3.10/0.0/0.0/15_010/0000630','CZ.01.4.04/0.0/0.0/16_066/0008676')
