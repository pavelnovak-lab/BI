SELECT	p."Registraèní èíslo projektu",

/* Aby sestava nekonèila timeoutem, pou¾ívám radìji UMZPrjGGII, ne¾ UMZProjekt. Nemám ale IÈ a název ¾adatele - dotahuji z UmzPrjGGVS */
--	p.zadatel AS "®adatel",
--	p."IÈ" AS "IÈ ®adatele",
	pr."IÈ" AS "IÈ ¾adatele",
	pr."Název subjektu" AS "®adatel",
	vz.nazev AS "Název zakázky",
	vz.poradovecislo AS "Poøadové èíslo zakázky",

/* Alternativa k datùm subjektù -> Radìji UmzPrgGGVS ne¾ UmsrsVerzeSubjektu - neobsahuje v¹echna data - napø. projekt zmínìný v komentu ní¾e. Proè? */
	-- s."Název subjektu" AS "Název dodavatele",
	-- s."IÈ" AS "IÈ dodavatele",

	vs."IÈ" AS "IÈ dodavatele VS",
	vs."IÈ zahranièní / REGON",
	vs."Název subjektu" AS "Název dodavatele VS"
	
FROM		isum.v_bi_UmzPrjGGII p
INNER JOIN 	isum.v_bi_UmvVyberovaRizeni vz ON vz.id_nositelvr=p.id

-- Následnì se pøepracovala vazba a nyní je ukládán u smlouvy (pøes id_typ.kod =2), tedy dle vazby v_bi_UMVVRDodatek.id_VerzeSubjektu
-- Je¹tì existuje v MS 155 záznamù VZ, které nemají vazbu ani v v_bi_UMVVRDodatek ani v v_bi_UMVVRDodavatel (nezji¹»oval jsem konkrétnì které VZ)

/* Typ kontraktu výbìrového øízení je 'Smlouva' od pana Kotouèka (plnìno od roku 2017) */
INNER JOIN 	isum.v_bi_UMVVRDodatek d ON d.id_vyberovarizeni=vz.id AND d.ID_VERZESUBJEKTU>0 
INNER JOIN 	isum.v_bi_UmsCisZakladni typd on typd.id=d.id_typ and typd."Kód"='2'
INNER JOIN 	isum.v_bi_UmsrsVerzeSubjektu s ON s.id=d.id_verzesubjektu
INNER JOIN 	isum.v_bi_UMZPrjGGVS vs ON vs.id_verzesubjektu=s.id

/* Vá¾u tedy jinak UmvVyberovaRizeni -> UMVVRDodavatel (pou¾ívalo se do roku 2017) -> UmzPrjGGVS, nefunguje napøíklad u projektu CZ.01.1.02/0.0/0.0/15_002/0000006  */
-- INNER JOIN     isum.v_bi_UMVVRDodavatel dod ON dod.id_vyberovarizeni=vz.id
-- INNER JOIN     isum.v_bi_UMZPrjGGVS vs ON dod.id_verzesubjektu=vs.id
INNER JOIN     isum.v_bi_UmzPRJGGVS pr ON p.id_zadatel=pr.id

/* Tento èíselník mi dovolí odfiltrovat stav VØ splnìna a zadána */
INNER JOIN	  isum.v_bi_UMSCisZakladni cis ON cis.id=vz.id_vrstav AND cis."Název" in ('Zadána','Splnìna')


WHERE p."Registraèní èíslo projektu" in ('CZ.01.1.02/0.0/0.0/15_002/0000026', 'CZ.01.1.02/0.0/0.0/15_002/0000006')
-- AND	p."Registraèní èíslo projektu"  is not null
-- ORDER BY p."Registraèní èíslo projektu"








