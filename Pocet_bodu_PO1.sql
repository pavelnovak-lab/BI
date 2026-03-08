SELECT p."Registraèní èíslo projektu" ,
       p.zadatel AS "®adatel",
       p."Název projektu CZ" AS "Název projektu",
       cis_2."Název" AS "Kraj realizace",	
       p."Datum registrace ¾ádosti",
-- Oøízne prvních 5 znakù (èíselný kód)
       SUBSTR( p.kompetencniutvar, 6 ) AS "Program podpory", 
       p.velikostpodniku AS "Velikost podniku",
       v."Èíslo výzvy",
       v."Název výzvy",
       status.pocetbodu AS "Celkem bodù VH",
       p.kodwfstav,
       p.wfstav,
       gg."EU" AS "Po¾adovaná dotace",
       gg."CZV" AS "Celkové zpùsobilé výdaje",
       gg."EU"/gg.czv AS "Míra podpory",
       krit.limitvyhovelbodu AS "Bodová hranice 1. krok VH",
       vh2.limitvyhovelbodu AS "Bodová hranice 2. krok VH",
-- ListAgg je omezený jen na 500 znakù, pøi pøeteèení oøízne
       LISTAGG(ci."Kód",'; ' on overflow truncate)  AS "Kód CZ NACE", 
       LISTAGG(ci."Název",'; ' on overflow truncate) AS "Název CZ NACE"
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni=p.id
INNER JOIN isum.v_bi_UMVHodnSoubKritVyz krit ON krit.id_vyzva=v.id
INNER JOIN isum.V_BI_UMZPRJKI ki ON ki.id_projekt=p.id
INNER JOIN isum.v_bi_UmsCisZakladni cis_2 ON ki.id_ki=cis_2.id AND cis_2.id_CisSeznam=198443
INNER JOIN isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel
INNER JOIN isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id
LEFT JOIN
(SELECT v.id,
	krit.limitvyhovelbodu 
 FROM isum.v_bi_UmzVyzva v 
 INNER JOIN isum.v_bi_UMVHodnSoubKritVyz krit ON krit.id_vyzva=v.id
 WHERE krit.id_KrokVecHodn = 171214
 AND krit.platnostdo is null) vh2 ON vh2.id=v.id



WHERE
-- p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_031/0007136'
p."Registraèní èíslo projektu" is not null
AND 	p.kodprioritniosa = '01.1'
AND	p.kodwfstav not in ('PP20','Z1','Z2','Z3','PP21','PP22','PN21','PN22')
-- AND	status.id_noshodnoceni <> 0
AND 	status.kodpopisstatutu=32    /*vybere celkový výsledek fáze vìcného hodnoení*/
AND 	status.id_kolohodn=171212   /*vybere jen hodnocení "ostré" ¾ádosti projektu*/
AND	krit.id_kolohodnoceni = 171212
AND 	(krit.id_KrokVecHodn = 171213 OR krit.id_KrokVecHodn = 171213)
AND	krit.platnostdo is null

GROUP BY p."Registraèní èíslo projektu" ,
       p.zadatel ,
       p."Název projektu CZ" ,
       cis_2."Název" ,	
       p."Datum registrace ¾ádosti",
       p.kompetencniutvar ,
       p.velikostpodniku ,
       v."Èíslo výzvy",
       v."Název výzvy",
       status.pocetbodu,
       p.kodwfstav,
       p.wfstav,
       gg."EU" ,
       gg."CZV" ,
       gg."EU"/gg.czv ,
       krit.limitvyhovelbodu ,
       vh2.limitvyhovelbodu

ORDER BY v."Èíslo výzvy", status.pocetbodu DESC
