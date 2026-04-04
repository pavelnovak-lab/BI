SELECT  p."Registrační číslo projektu",
	p.kodwfstav,
	vs."Název subjektu",
       	vs."IČ",
       	vs."Počet zaměstnanců",
 	p."Datum prvního podání",
	ropd.datumod AS "Datum vydání RoPD"

FROM   		 isum.v_bi_UmzProjekt p 
INNER JOIN	 isum.v_bi_UmzPrjGGVS vs ON vs.id=p.id_zadatel  
INNER JOIN	 
     (SELECT DISTINCT  vvs."IČ", vvs."Název subjektu"
     FROM	isum.v_bi_UmzPrjGGVS  vvs
     INNER JOIN	isum.v_bi_UmzProjekt pp  ON vvs.id=pp.id_zadatel  
     WHERE 	vvs."Počet zaměstnanců" >= 50 
     AND 	vvs."Počet zaměstnanců" is not null
     AND	pp."Registrační číslo projektu" is not null
     AND 	pp.kodwfstav not like ('PN%')

     INTERSECT

     SELECT DISTINCT vvvs."IČ", vvvs."Název subjektu"
     FROM	isum.v_bi_UmzPrjGGVS vvvs
     INNER JOIN	isum.v_bi_UmzProjekt ppp  ON vvvs.id=ppp.id_zadatel       
     WHERE 	vvvs."Počet zaměstnanců" < 50
     AND 	vvvs."Počet zaměstnanců" is not null
     AND	ppp."Registrační číslo projektu" is not null
     AND 	ppp.kodwfstav not like ('PN%')
     AND 	vvvs."Počet zaměstnanců" <> 0
     ) konfliktni
     ON konfliktni."IČ" = vs."IČ" AND konfliktni."Název subjektu" = vs."Název subjektu"
LEFT JOIN
     (SELECT hs.DATUMOD, proj.id
     FROM    isum.v_bi_UmzProjekt proj
     INNER JOIN isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=proj.id
     WHERE hs.STAVDO = 'PP30' ) ropd
     ON ropd.id=p.ID


WHERE p."Registrační číslo projektu" is not null
AND   p.kodwfstav not like ('PN%')


ORDER BY vs."IČ", vs."Počet zaměstnanců"







--------------------

-- SELECT DISTINCT
--         p."Registrační číslo projektu",
-- 	p.kodwfstav,
-- 	vs."Název subjektu",
--        	vs."IČ",
--        	vs."Počet zaměstnanců"

-- FROM   		 isum.v_bi_UmzProjekt p 
-- INNER JOIN	 isum.v_bi_UmzPrjGGVS vs ON vs.id=p.id_zadatel  

-- WHERE 		 vs."IČ"= '00008702'
-- AND   vs."Počet zaměstnanců" < 50	

-- ORDER BY vs."IČ", vs."Počet zaměstnanců"




-- SELECT DISTINCT  "IČ"
--      FROM	isum.v_bi_UmzPrjGGVS  
--      WHERE 	"Počet zaměstnanců" >= 50 
--      AND 	"IČ" = '00008702'

-- INTERSECT

-- SELECT DISTINCT "IČ"
--      FROM	isum.v_bi_UmzPrjGGVS 
--      WHERE 	"Počet zaměstnanců" < 50
--      AND 	"IČ" = '00008702'


-- SELECT "Počet zaměstnanců", id_velikostpodniku
-- FROM	isum.v_bi_UmzPrjGGVS WHERE "IČ" = '00015679'


SELECT 	p."Registrační číslo projektu",
	p."Název projektu CZ",
	v."Číslo výzvy",
	v."Název výzvy",
	p.kodwfstav,
	p.eu,
	p.czv,
	p.wfstav,
	p.wfstavdatum
--	hs.datumod,

FROM 		isum.v_bi_Umzprjgg p
-- INNER JOIN	isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id 
INNER JOIN	isum.v_bi_umzvyzva v ON p.id_vyzva=v.id

WHERE v."Číslo výzvy" in ('01_17_106','01_17_107')

-- AND hs.STAVDO in ('PP21','PP22')
-- AND p.kodwfstav in ('PP21','PP22')


AND EXISTS
(SELECT p."Registrační číslo projektu" 
	FROM 		isum.v_bi_Umzprjggii pp
	INNER JOIN	isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id 
	WHERE hs.STAVDO = 'PU27'
	AND pp.id=p.id)

-- ORDER BY "Počet dní po FNaP"
