SELECT
	p."Registrační číslo projektu",
--	p.zadatel AS "Žadatel",
--	p."IČ" AS "IČ Žadatele",
	vz.nazev AS "Název zakázky",
	vz.poradovecislo AS "Pořadové číslo zakázky",

	-- s."Název subjektu" AS "Název dodavatele",
	-- s."IČ" AS "IČ dodavatele",

	vs."IČ" AS "IČ dodavatele VS",
	vs."IČ zahraniční / REGON",
	vs."Název subjektu" AS "Název dodavatele VS"
	
FROM		isum.v_bi_UmzProjGGII p
INNER JOIN 	isum.v_bi_UmvVyberovaRizeni vz ON vz.id_nositelvr=p.id
-- INNER JOIN 	isum.v_bi_UMVVRDodatek d ON d.id_vyberovarizeni=vz.id
-- AND d.ID_VERZESUBJEKTU>0 and rownum=1 

/* Tyto vazby nejsou v pořádku, nefungují u všech dodavatelů CZ.01.1.02/0.0/0.0/15_002/0000026 */
-- INNER JOIN 	isum.v_bi_UmsrsVerzeSubjektu s ON s.id=d.id_verzesubjektu
-- INNER JOIN 	isum.v_bi_UMZPrjGGVS vs ON vs.id_verzesubjektu=s.id

/* Zkusím tedy vázat jinak. vazba  UmvVyberovaRizeni  na UMVVRDodavatel rizeni a nasledne na PRJGGVs */
INNER JOIN     isum.v_bi_UMVVRDodavatel dod ON dod.id_vyberovarizeni=vz.id
INNER JOIN     isum.v_bi_UMZPrjGGVS vs ON dod.id_verzesubjektu=vs.id

/* Typ kontraktu mezi výběrového řízení je 'Smlouva' */
-- INNER JOIN 	isum.v_bi_UmsCisZakladni typd on typd.id=d.id_typ and typd."Kód"='2'


/* Tento číselník mi dovolí odfiltrovat splněné a zadané VZ */
INNER JOIN	isum.v_bi_UMSCisZakladni cis ON cis.id=vz.id_vrstav

WHERE   cis."Název" in ('Zadána','Splněna') /* Stav veřejné zakázky */
AND	p."Registrační číslo projektu" ='CZ.01.1.02/0.0/0.0/15_002/0000026'
-- AND   p."Registrační číslo projektu" ='CZ.01.1.02/0.0/0.0/15_002/0003539'
-- AND   p."Registrační číslo projektu" is not null 

-- ORDER BY p."Registrační číslo projektu" 





SELECT *
FROM isum.v_bi_UMZPrjGGII
WHERE id=1696439
