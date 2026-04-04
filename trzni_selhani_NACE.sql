SELECT
	p."Registrační číslo projektu",
	ci."Název" AS "Kód CZ NACE",	       
	ci."Kód" AS "Název CZ NACE",
	-- (LISTAGG(ci."Kód",'; ') WITHIN GROUP (ORDER BY ci."Kód"))  AS "Kód CZ NACE",
	-- (LISTAGG(ci."Název",'; ') WITHIN GROUP (ORDER BY ci."Kód")) AS "Název CZ NACE",

	o1.nazev as "hl.k.o",
	o1.mail as "Email",
	o1.telefon as "Tel",
	o1.mobil as "MobilniTel",
	o2.nazev2 as "Statutari",
	o2.mail2 as "MailStatut",
        o2.telefon2 as "TelStatut",
	o2.mobil2 as "MobilStatut"



FROM 		isum.v_bi_umzprojekt p
INNER JOIN	isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel
INNER JOIN 	isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
INNER JOIN	isum.v_bi_umzprjggvs pggvs ON pggvs.id=p.id_zadatel

LEFT JOIN ISUM.V_BI_UMSRSVERZEADRESY adr on pggvs.id_oficialniadresa=adr.id
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
LEFT JOIN 
	(SELECT
		(LISTAGG (CONCAT(ox."Jméno", (concat(' ',ox."Příjmení"))), ', ') WITHIN GROUP (ORDER BY CONCAT(ox."Jméno", (concat(' ',ox."Příjmení")))) ) AS nazev2,
		(LISTAGG (ox."Email", ', ') WITHIN GROUP (ORDER BY CONCAT(ox."Jméno", (concat(' ',ox."Příjmení")))) ) AS mail2,
		(LISTAGG (ox."Telefon", ', ') WITHIN GROUP (ORDER BY CONCAT(ox."Jméno", (concat(' ',ox."Příjmení")))) ) AS telefon2,
		(LISTAGG (ox."Mobil", ', ') WITHIN GROUP (ORDER BY CONCAT(ox."Jméno", (concat(' ',ox."Příjmení")))) ) AS mobil2,
		ox.id_verzesubjektu as vazba2
		from isum.v_bi_umsrsverzeosoby ox
		inner join isum.v_bi_umzprjggvs vs on vs.id_verzesubjektu=ox.id_verzesubjektu
		where ox."Statutární zástupce"='A'
		group by ox.id_verzesubjektu
		) o2 on o2.vazba2=pggvs.id_verzesubjektu

WHERE p."Registrační číslo projektu" in 

-- GROUP BY p."Registrační číslo projektu", o1.nazev, o1.mail, o1.telefon, o1.mobil, o2.nazev2, o2.mail2, o2.telefon2, o2.mobil2
