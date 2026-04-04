SELECT	p."Registrační číslo projektu",
	LISTAGG(DISTINCT adr.psc,'; ') WITHIN GROUP (ORDER BY adr.psc) AS "PSČ"
	-- LISTAGG(DISTINCT SUBSTR( ci."Kód", 1,2),'; ') AS "Kód CZ NACE"


FROM		isum.v_bi_UmzProjekt p			
INNER JOIN	isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel
INNER JOIN 	isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
INNER JOIN 	isum.v_bi_UmsRsVerzeAdresy adr on p.id_zadatel=adr.id_verzesubjektu

WHERE	p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42') 
AND	p.id_kompetence  =  6542521 /* 0116 Úspory energie */
-- AND	REGEXP_LIKE( adr.psc, '1[0-9]{4}' )
-- AND 	p."Registrační číslo projektu" in ('CZ.01.3.10/0.0/0.0/15_010/0000107','CZ.01.3.10/0.0/0.0/15_010/0000029','CZ.01.3.10/0.0/0.0/18_183/0017700')

AND EXISTS  
(SELECT	    pp.id
FROM		isum.v_bi_UmzProjekt pp			
INNER JOIN 	isum.v_bi_UmsRsVerzeAdresy adr on p.id_zadatel=adr.id_verzesubjektu
WHERE REGEXP_LIKE( adr.psc, '1[0-9]{4}' )
AND pp.id = p.id)

AND NOT EXISTS  
(SELECT	    pp.id
FROM		isum.v_bi_UmzProjekt pp			
INNER JOIN 	isum.v_bi_UmsRsVerzeAdresy adr on p.id_zadatel=adr.id_verzesubjektu
WHERE REGEXP_LIKE( adr.psc, '[2-9][0-9]{4}' )
AND pp.id = p.id)




GROUP BY p."Registrační číslo projektu"
