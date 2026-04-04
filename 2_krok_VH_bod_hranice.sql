SELECT p."Registrační číslo projektu" ,
       v."Číslo výzvy",
       status.pocetbodu,
       krit.limitvyhovelbodu AS "Bodová hranice 1. krok VH",
       vh2.limitvyhovelbodu AS "Bodová hranice 2. krok VH"


FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni=p.id
INNER JOIN isum.v_bi_UMVHodnSoubKritVyz krit ON krit.id_vyzva=v.id
LEFT JOIN
(SELECT v.id,
	krit.limitvyhovelbodu 
 FROM isum.v_bi_UmzVyzva v 
 INNER JOIN isum.v_bi_UMVHodnSoubKritVyz krit ON krit.id_vyzva=v.id
 WHERE krit.id_KrokVecHodn = 171214
 AND krit.platnostdo is null) vh2 ON vh2.id=v.id

WHERE
p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/15_031/0007136','CZ.01.1.02/0.0/0.0/15_014/0000194')
-- p."Registrační číslo projektu" is not null
AND 	p.kodprioritniosa = '01.1'
AND	p.kodwfstav not in ('PP20','Z1','Z2','Z3','PP21','PP22','PN21','PN22')
-- AND	status.id_noshodnoceni <> 0
AND 	status.kodpopisstatutu=32    /*vybere celkový výsledek fáze věcného hodnoení*/
AND 	status.id_kolohodn=171212   /*vybere jen hodnocení "ostré" žádosti projektu*/
AND	krit.id_kolohodnoceni = 171212
AND 	krit.id_KrokVecHodn = 171213
AND 	krit.platnostdo is null


