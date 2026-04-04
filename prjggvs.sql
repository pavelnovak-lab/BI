SELECT	p."Registrační číslo projektu",
	cis."Název" as "Velikost podniku",
	vs."Počet zaměstnanců",
	vs.id_velikostpodniku

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id 
INNER JOIN isum.v_bi_UmsCisZakladni cis ON vs.id_velikostpodniku = cis.id

WHERE p."Registrační číslo projektu" in ('CZ.01.2.06/0.0/0.0/20_357/0021909','CZ.01.2.06/0.0/0.0/20_357/0021691')

