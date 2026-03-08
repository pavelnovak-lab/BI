SELECT	p."Registraèní èíslo projektu",

/* Aby sestava nekonèila timeoutem, používám radìji UMZPrjGGII, než UMZProjekt. Nemám ale IÈ a název žadatele - dotahuji z UmzPrjGGVS */
--	p.zadatel AS "Žadatel",
--	p."IÈ" AS "IÈ Žadatele",
	pr."IÈ" AS "IÈ žadatele",
	pr."Název subjektu" AS "Žadatel",
	vz.nazev AS "Název zakázky",
	vz.poradovecislo AS "Poøadové èíslo zakázky",

/* Alternativa k datùm subjektù -> Radìji UmzPrgGGVS než UmsrsVerzeSubjektu - neobsahuje všechna data - napø. projekt zmínìný v komentu níže. Proè? */
	-- s."Název subjektu" AS "Název dodavatele",
	-- s."IÈ" AS "IÈ dodavatele",

	vs."IÈ" AS "IÈ dodavatele VS",
	vs."IÈ zahranièní / REGON",
	vs."Název subjektu" AS "Název dodavatele VS"
	
FROM		isum.v_bi_UmzPrjGGII p
INNER JOIN 	isum.v_bi_UmvVyberovaRizeni vz ON vz.id_nositelvr=p.id

/* Typ kontraktu výbìrového øízení je 'Smlouva' (ze zdrojáku od pana Kotouèka) - nevidím dùvod pro tento filtr. */
-- INNER JOIN 	isum.v_bi_UMVVRDodatek d ON d.id_vyberovarizeni=vz.id AND d.ID_VERZESUBJEKTU>0 and rownum=1 
-- INNER JOIN 	isum.v_bi_UmsCisZakladni typd on typd.id=d.id_typ and typd."Kód"='2'

/* Tato vazba nejsou v poøádku, nefungují u všech dodavatelù - napø. CZ.01.1.02/0.0/0.0/15_002/0000026 */
-- INNER JOIN 	isum.v_bi_UmsrsVerzeSubjektu s ON s.id=d.id_verzesubjektu

/* Vážu tedy jinak UmvVyberovaRizeni -> UMVVRDodavatel -> UmzPrjGGVS */
INNER JOIN     isum.v_bi_UMVVRDodavatel dod ON dod.id_vyberovarizeni=vz.id
INNER JOIN     isum.v_bi_UmzPrjGGVS vs ON dod.id_verzesubjektu=vs.id
INNER JOIN     isum.v_bi_UmzPRJGGVS pr ON p.id_zadatel=pr.id

/* Tento èíselník mi dovolí odfiltrovat stav VØ splnìna a zadána */
INNER JOIN	isum.v_bi_UMSCisZakladni cis ON cis.id=vz.id_vrstav

WHERE   cis."Název" in ('Zadána','Splnìna') 
-- AND	p."Registraèní èíslo projektu"  is not null
AND	p."Registraèní èíslo projektu" ='CZ.01.1.02/0.0/0.0/15_002/0000026'

-- ORDER BY p."Registraèní èíslo projektu"