select	 "V_BI_UMZPROJEKT"."Registrační číslo projektu" as "Registrační číslo projektu",
	"V_BI_UMZPROJEKT"."KODWFSTAV" as "Kód stavu projektu", 
	 "V_BI_UMZPROJEKT"."Název projektu CZ" as "Název projektu CZ",
	 "V_BI_UMZPROJEKT"."ZADATEL" as "ZADATEL",
	 "V_BI_UMFSMLOUVA"."Pořadí" as "Pořadí",
	 "V_BI_UMFSMLOUVA"."Číslo" as "Číslo",
	 "V_BI_UMFSMLOUVA"."NAZEV" as "NAZEV",
	 "V_BI_UMFSMLOUVA"."WFSTAV" as "WFSTAV",
	 "V_BI_UMFSMLOUVA"."KODWFSTAV" as "KODWFSTAV",
	 "V_BI_UMFSMLOUVA"."TYP" as "TYP" 
 from	"ISUM"."V_BI_UMFSMLOUVA" "V_BI_UMFSMLOUVA",
	"ISUM"."V_BI_UMZPROJEKT" "V_BI_UMZPROJEKT" 
 where   "V_BI_UMFSMLOUVA"."IDPROJEKT"="V_BI_UMZPROJEKT"."ID"
 -- and 	 "V_BI_UMZPROJEKT"."Registrační číslo projektu" in 
and 	 "V_BI_UMZPROJEKT"."Registrační číslo projektu"=:projekt
ORDER BY "V_BI_UMZPROJEKT"."Registrační číslo projektu", "V_BI_UMFSMLOUVA"."Pořadí"







SELECT
	-- count(sml.id) "Počet",
      	sml.typ,
	p."Registrační číslo projektu" 

FROM isum.v_bi_umfsmlouva sml
INNER JOIN isum.v_bi_UmzPrjGGII p ON sml.idprojekt = p.id

WHERE sml.typ = 'Právní akt schvalující projekt OSS/PO OSS'

-- GROUP BY sml.typ

------------

SELECT count(id)

FROM isum.v_bi_umzprjggii

WHERE p."Registrační číslo projektu" is not null


-------------------------------------------------------------------------------------------

SELECT  count(sml.id) "Počet",
      	sml.typ


FROM isum.v_bi_umfsmlouva sml
-- INNER JOIN isum.v_bi_UmzPrjGGII p ON sml.idprojekt = p.id

-- WHERE sml.typ = 'Právní akt schvalující projekt OSS/PO OSS'

GROUP BY sml.typ

ORDER BY "Počet"


