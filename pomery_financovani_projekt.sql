SELECT	p."Registrační číslo projektu" ,
	pfh.*

from isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UMFPomeryHlavicka pfh ON pfh.id_nositelpompf = p.id
-- INNER JOIN isum.v_bi_UMFPomerFinancovani pf ON pf.id_nositelpompf = pfh.id

WHERE p."Registrační číslo projektu" = 'CZ.31.3.0/0.0/0.0/22_001/0000351'
