SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	REPLACE(p.KodPrioritniOsa,'01.','') AS "Prioriní osa",  
	p."Registraèní èíslo projektu",
   	p."Název projektu CZ",
	-- cis_2."Název" AS "Kraj realizace",
	uk."Název" "Kraj realizace",
	p.ZADATEL,
	p.KODWFSTAV,
	p.velikostpodniku,
	p."Datum ukonèení pøedp",
	p."Datum ukonèení skut",
	p."Datum zahájení pøedp",
	p."Datum zahájení skut",

        -- v."Název výzvy",
	-- v."Èíslo výzvy",
 	pggvs."Poèet zamìstnancù",
	-- gg."EU" AS "Po¾adovaná dotace",
	-- gg."CZV" AS "Celkové zpùsobilé výdaje",

	
	o1.nazev as "hl.k.o",
	o1.mail as "Email",
	o1.telefon as "Tel",
	o1.mobil as "MobilniTel",
	o2.nazev2 as "Statutari",
	o2.mail2 as "MailStatut",
        o2.telefon2 as "TelStatut",
	o2.mobil2 as "MobilStatut"


FROM	isum.v_bi_umzprojekt p
INNER JOIN isum.v_bi_UmzPrjUmisteniKraj uk ON uk.id_projekt = p.id AND uk.typ = 'Realizace'
INNER JOIN isum.v_bi_umzprjggvs pggvs ON pggvs.id=p.id_zadatel  
-- INNER JOIN isum.v_bi_umzvyzva v ON p.id_vyzva=v.id
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id
LEFT JOIN 
 (select
 (LISTAGG (CONCAT(o."Jméno", (concat(' ',o."Pøíjmení"))), ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Pøíjmení")))) ) AS nazev,
 (LISTAGG (o."Email", ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Pøíjmení")))) ) AS mail,
 (LISTAGG (o."Telefon", ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Pøíjmení")))) ) AS telefon,
 (LISTAGG (o."Mobil", ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Pøíjmení")))) ) AS mobil,
 o.id_verzesubjektu as vazba
 from isum.v_bi_umsrsverzeosoby o
 inner join isum.v_bi_umzprjggvs vs on vs.id_verzesubjektu=o.id_verzesubjektu
 where o."Hlavní kontaktní osoba" ='A'
 group by o.id_verzesubjektu
 ) o1 on o1.vazba=pggvs.id_verzesubjektu
LEFT JOIN 
 (SELECT
 (LISTAGG (CONCAT(ox."Jméno", (concat(' ',ox."Pøíjmení"))), ', ') WITHIN GROUP (ORDER BY CONCAT(ox."Jméno", (concat(' ',ox."Pøíjmení")))) ) AS nazev2,
 (LISTAGG (ox."Email", ', ') WITHIN GROUP (ORDER BY CONCAT(ox."Jméno", (concat(' ',ox."Pøíjmení")))) ) AS mail2,
 (LISTAGG (ox."Telefon", ', ') WITHIN GROUP (ORDER BY CONCAT(ox."Jméno", (concat(' ',ox."Pøíjmení")))) ) AS telefon2,
 (LISTAGG (ox."Mobil", ', ') WITHIN GROUP (ORDER BY CONCAT(ox."Jméno", (concat(' ',ox."Pøíjmení")))) ) AS mobil2,
 ox.id_verzesubjektu as vazba2
 from isum.v_bi_umsrsverzeosoby ox
 inner join isum.v_bi_umzprjggvs vs on vs.id_verzesubjektu=ox.id_verzesubjektu
 where ox."Statutární zástupce"='A'
 group by ox.id_verzesubjektu
 ) o2 on o2.vazba2=pggvs.id_verzesubjektu


WHERE p."Registraèní èíslo projektu" is not null 
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 
AND uk."Název" = 'Moravskoslezský kraj'
AND p.velikostpodniku <> 'Velký podnik'
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PU30') 

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) DESC
