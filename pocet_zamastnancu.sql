SELECT DISTINCT
        p."Registrační číslo projektu",
	p.kodwfstav,
	vs."Název subjektu",
       	vs."IČ",
       	vs."Počet zaměstnanců"

FROM   		 isum.v_bi_UmzProjekt p 
INNER JOIN	 isum.v_bi_UmzPrjGGVS vs ON vs.id=p.id_zadatel  
LEFT JOIN (
      SELECT	vvs."Název subjektu",
      		vvs."IČ",
      		vvs."Počet zaměstnanců"
	FROM	isum.v_bi_UmzPrjGGVS vvs 
	WHERE vvs."Počet zaměstnanců" < 50 ) nesoulad
	ON vs."IČ" = nesoulad."IČ"  AND vs."Počet zaměstnanců" >= 50

WHERE vs."Počet zaměstnanců" is not null
AND   p."Registrační číslo projektu" is not null 
-- AND   vs."Název subjektu" = 'Feropol s.r.o.'

-- AND EXISTS (
--     SELECT 1
--     FROM isum.v_bi_UmzPrjGGVS
--     WHERE vs."IČ"="IČ" AND ((vs."Počet zaměstnanců" < 50 AND "Počet zaměstnanců" > 50) OR (vs."Počet zaměstnanců" > 50 AND "Počet zaměstnanců" < 50))  )

-- ORDER BY vs."IČ", vs."Počet zaměstnanců"

