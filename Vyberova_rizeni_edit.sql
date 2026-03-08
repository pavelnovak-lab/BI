SELECT	p."Registraèní èíslo projektu",
	p."IÈ" AS "IÈ ®adatele",
	p.zadatel AS "®adatel",
	vz.nazev AS "Název zakázky",
	vz.CASTKAPREDPZV AS "Pøedpokládaná èástka ZV bez DPH",
	vz.CENADLESMLOUVY AS "Cena VZ dle smlouvy bez DPH",

--	vz.poradovecislo AS "Poøadové èíslo zakázky",

	/* Info o subjektu z tøídy UmsRSVerzeSubjektu */
   	vs."IÈ" AS "IÈ dodavatele VS",
	vs.ICZAHRANICNI,
	vs."Název subjektu" AS "Název dodavatele VS"

	/* Info o subjektu z tøídy UMzPrjGGVS */
	-- vs."IÈ" AS "IÈ dodavatele VS",
	-- vs."IÈ zahranièní / REGON",
	-- vs."Název subjektu" AS "Název dodavatele VS"
	
FROM 	isum.v_bi_UmzProjekt p
	INNER JOIN isum.v_bi_UmvVyberovaRizeni vz ON vz.id_nositelvr=p.id
	INNER JOIN isum.v_bi_UMSCisZakladni cis ON cis.id=vz.id_vrstav and cis."Název" in ('Zadána','Splnìna')

	/* Tato vazba není v poøádku, nefunguje u v¹ech dodavatelù - napø. CZ.01.1.02/0.0/0.0/15_002/0000006 */
	INNER JOIN isum.v_bi_UMVVRDodavatel dod ON dod.id_vyberovarizeni=vz.id
	
	INNER JOIN isum.v_bi_UmsrsVerzeSubjektu vs ON dod.id_verzesubjektu=vs.id

	/* Pro jistotu velmi podobná tøída UmsRSVerzeSubjektu */
--	INNER JOIN isum.v_bi_UmzPrjGGVS vs ON dod.id_verzesubjektu=vs.id
	
WHERE
-- p."Registraèní èíslo projektu"  is not null
p."Registraèní èíslo projektu" in ('CZ.01.1.02/0.0/0.0/15_002/0000006','CZ.01.1.02/0.0/0.0/15_002/0000026')

ORDER BY p."Registraèní èíslo projektu"





















