SELECT p."Registrační číslo projektu",
       pzf.*
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
-- INNER JOIN isum.v_bi_UMPCASTKY castky ON castky.id = platba.ID_SCHVALENECASTKY
-- INNER JOIN isum.V_BI_UMFSOUPISKA s ON s.id_platba = platba.id 
-- INNER JOIN isum.V_BI_UMFSOUPISKADOKLAD sd ON sd.id_soupiska = s.id
INNER JOIN isum.V_BI_UMFPFCELKEM pzf ON pzf.id_projekt = p.id 


WHERE --  pzf.id_faze IN  (99991000000000005, 99991000000000011)
(
p."Registrační číslo projektu" = 'CZ.31.1.0/0.0/0.0/24_135/0010838'

OR platba."Číslo žádosti o platbu" = 'CZ.01.3.10/0.0/0.0/17_101/0012901/2019/001/POST')

-- AND platba.souctovyradek IS NULL 

