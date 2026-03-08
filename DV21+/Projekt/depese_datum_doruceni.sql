-- CREATE or REPLACE view "RIS3_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 
SELECT p."Registrační číslo projektu",
	s."Název subjektu" "Žadatel" ,
	d.*, az.*


FROM projekt p
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null  AND s.id_typsubjektuedit IN (413462) -- žadatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 
INNER JOIN depese d ON d.id_nositelzpravy = p.id
INNER JOIN adresat_zpravy az ON az.id_zprava = d.id 

WHERE -- p."Registrační číslo projektu" = 'CZ.01.01.01/07/24_046/0007272'
-- AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08')
az.id_obecroleext = 0
and az.id_extuzivatel = 0
AND (p."Registrační číslo projektu" = 'CZ.01.01.01/08/25_079/0008312' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-13'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/08/25_078/0008199' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-13'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/01/24_063/0006891' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-13'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/01/24_063/0006676' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-10'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/01/24_056/0007984' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-10'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/01/24_056/0006544' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-10'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/01/24_063/0006924' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-09'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/01/24_063/0006853' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.05.01/01/23_029/0004697' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.05.02/01/23_028/0004033' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/03/24_061/0007650' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/07/24_046/0007005' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/07/24_046/0007272' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.04.01/01/24_049/0007461' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.04.01/01/24_049/0007451' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.04.01/01/24_049/0007449' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.04.01/01/24_049/0007408' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.04.01/01/24_049/0007385' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.04.01/01/24_049/0007006' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.04.01/01/24_049/0006229' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.04.01/01/24_049/0005878' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.04.03/01/23_032/0005092' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.02.01/05/24_059/0006383' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.02.01/05/24_059/0006402' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-08'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/01/24_063/0006867' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-07'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/01/24_063/0006924' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-07'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/01/24_063/0006867' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-07'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/01/24_063/0006867' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-07'))
OR (p."Registrační číslo projektu" = 'CZ.01.01.01/01/24_063/0006908' AND FORMATDATE('yyyy-MM-dd', d."Datum odeslání") =  to_date('yyyy-MM-dd','2025-10-06'))
