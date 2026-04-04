SELECT PO1."Registrační číslo projektu" AS "Registrační číslo PO1",
       PO2."Registrační číslo projektu" AS "Registrační číslo PO2",
       PO3."Registrační číslo projektu" AS "Registrační číslo PO3",
       PO1.zadatel AS "Žadatel PO1",
       PO2.zadatel AS "Žadatel PO2",
       PO3.zadatel AS "Žadatel PO3",	
       PO1."IČ" AS "PO1 IČ",
       PO2."IČ" AS "P02 IČ"

FROM

(SELECT	p."Registrační číslo projektu" ,
	p.KodPrioritniOsa,
	p.zadatel,
	p."IČ",
	p.id_zadatel,
	p.wfstav,
	p.kodwfstav

FROM 	isum.v_bi_UmzProjekt p 

WHERE	p."Registrační číslo projektu" is not null
AND 	p.KodPrioritniOsa = '01.1') PO1

INNER JOIN

(SELECT	p."Registrační číslo projektu" ,
	p.KodPrioritniOsa,
	p.zadatel,
	p."IČ",
	p.id_zadatel,
	p.wfstav,
	p.kodwfstav

FROM 	isum.v_bi_UmzProjekt p 

WHERE	p."Registrační číslo projektu" is not null
AND 	p.KodPrioritniOsa = '01.2') PO2

ON PO1."IČ"=PO2."IČ"

INNER JOIN

(SELECT	p."Registrační číslo projektu" ,
	p.KodPrioritniOsa,
	p.zadatel,
	p."IČ",
	p.id_zadatel,
	p.wfstav,
	p.kodwfstav

FROM 	isum.v_bi_UmzProjekt p 

WHERE	p."Registrační číslo projektu" is not null
AND 	p.KodPrioritniOsa = '01.3') PO3

ON PO1."IČ"=PO3."IČ"
