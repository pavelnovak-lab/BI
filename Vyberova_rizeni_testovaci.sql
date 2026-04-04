SELECT
p."Registrační číslo projektu",
pr."IČ" AS "IČ Žadatele",
p."Název projektu CZ",
p.zadatel,
vz.nazev as nazevvz,
dodavatel."Název subjektu" AS "Dodavatel název",
dodavatel."IČ" AS "IČ dodavatele"
-- vz.poradovecislo as cislovz,
-- cis."Název",

FROM  	  	isum.v_bi_umzprojekt p
INNER JOIN	isum.v_bi_umzprjggvs pr ON pr.id=p.id_zadatel  
INNER JOIN 	isum.v_bi_UMVVyberovaRizeni vz ON vz.id_nositelvr=p.id
INNER JOIN	isum.v_bi_UMSCisZakladni cis ON cis.id=vz.id_vrstav
INNER JOIN
(SELECT s."Název subjektu",
	s."IČ",
	vz.id
	FROM  isum.v_bi_UMVVRDodatek d
	INNER JOIN isum.v_bi_umsciszakladni typd on typd.id=d.id_typ and typd."Kód"='2'
	INNER JOIN isum.v_bi_umsrsverzesubjektu s on s.id=d.ID_VERZESUBJEKTU
	WHERE d.id_vyberovarizeni=vz.id and d.ID_VERZESUBJEKTU>0 and rownum=1) dodavatel ON dodavatel.id=vz.id

WHERE
-- p."Registrační číslo projektu" is not null
cis."Název" = 'Zadána'
AND   p."Registrační číslo projektu" ='CZ.01.1.02/0.0/0.0/15_002/0003539'

-- ORDER BY p."Registrační číslo projektu" 
 

