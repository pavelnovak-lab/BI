SELECT 	p."Registrační číslo projektu",
	status.*

FROM		isum.v_bi_UmzProjekt p
INNER JOIN 	isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni=p.id

/* Proč tyto dvě vazby? - vycházím z odpovědi kolegy který má na starosti hodnocení a dle něj celkový počet bodů věcného h. na projektu za všechny kroky věc. h. lze získat takto:
 UMVHodnStatusDH. PocetBodu
Ale je potřeba najít ten správný záznam UMVHodnStatusDH – ten, který je vázán na správné UMVHodnDruhCis, UMVHodnKolo, NosHodnoceni a který má NEvyplněnou vazbu na UMVHodnKrokVecne
 */
-- INNER JOIN	isum.v_bi_umvhodndruhcis ciselnik ON status.id_druhhodn=ciselnik.id
-- INNER JOIN	isum.v_bi_umvhodnkolo kolo ON status.id_kolohodn=kolo.id

WHERE 	p."Registrační číslo projektu" = 'CZ.01.2.06/0.0/0.0/20_322/0025448'
-- AND	id_krokvechodn = 0
AND	status.id_noshodnoceni <> 0
AND 	status.kodpopisstatutu=32    /*vybere celkový výsledek fáze věcného hodnoení*/
AND 	status.id_kolohodn=171212   /*vybere jen hodnocení "ostré" žádosti projektu*/



--------------
SELECT 
h.*

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
INNER JOIN isum.v_bi_UmvHodnSchvaleni sch ON h.id=sch.id_hodnoceni

WHERE
p."Registrační číslo projektu" = 'CZ.01.2.06/0.0/0.0/20_322/0025448'
AND 	h.id_kolohodnoceni=171212   /* hodnocení "ostré" žádosti */
AND 	h.id_KrokVecHodn = 171214 /* 2. krok VH */ 
