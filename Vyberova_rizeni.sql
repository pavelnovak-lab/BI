SELECT	p."Registrační číslo projektu",
	p."IČ" AS "IČ Žadatele",
	p.zadatel AS "Žadatel",
	vz.nazev AS "Název zakázky",
	vz.CASTKAPREDPZV AS "Cena VZ předpokládaná",
	vz.CENADLESMLOUVY AS "Cena VZ dle smlouvy",
   	nvl(nvl(nvl(vs."IČ",s."IČ"),vs.ICZAHRANICNI),s.ICZAHRANICNI) AS "IČ dodavatele",
	nvl(vs."Název subjektu",s."Název subjektu") AS "Název dodavatele"
	
FROM	isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmvVyberovaRizeni vz ON vz.id_nositelvr=p.id
INNER JOIN isum.v_bi_UMSCisZakladni cis ON cis.id=vz.id_vrstav and cis."Název" in ('Zadána','Splněna')

/* Vážu UmvVyberovaRizeni -> UMVVRDodavatel (používalo se do roku 2017) -> Umsrsverzesubjektu, nefunguje například u projektu CZ.01.1.02/0.0/0.0/15_002/0000006  */
LEFT JOIN isum.v_bi_UMVVRDodavatel dod ON dod.id_vyberovarizeni=vz.id
LEFT JOIN isum.v_bi_UmsrsVerzeSubjektu vs ON dod.id_verzesubjektu=vs.id

/* Typ kontraktu výběrového řízení je 'Smlouva' od pana Kotoučka (plněno od roku 2017) */
LEFT JOIN 	isum.v_bi_UMVVRDodatek d ON d.id_vyberovarizeni=vz.id AND d.ID_VERZESUBJEKTU>0 
LEFT JOIN 	isum.v_bi_UmsCisZakladni typd on typd.id=d.id_typ and typd."Kód"='2'
LEFT JOIN 	isum.v_bi_UmsrsVerzeSubjektu s ON s.id=d.id_verzesubjektu

WHERE p."Registrační číslo projektu"  is not null
-- p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/15_002/0000006','CZ.01.1.02/0.0/0.0/15_002/0000026')

ORDER BY p."Registrační číslo projektu"
