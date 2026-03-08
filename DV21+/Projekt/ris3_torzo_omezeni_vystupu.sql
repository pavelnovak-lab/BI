CREATE or REPLACE view "RIS3_torzo" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 

SELECT p."Registraèní èíslo projektu" ,
       ds."Doména specializace (Kód)",
       ds."Doména specializace (Název)",
       ds."Procento" "Doména specializace (Procento)",
       ket."RIS3 KET (Kód)",    
       ket."RIS3 KET (Název)"


FROM projekt p
LEFT JOIN (
 SELECT rds."Kód" "Doména specializace (Kód)",    
	rds."Název" "Doména specializace (Název)",
	pr.id_projekt,
	pr."Procento",
	pr.id_ris3,
	pr.id id_ds
 FROM projekt_ris3 pr 
 INNER JOIN ciselnik_ris3_domeny_specializace rds ON pr.id_ris3 = rds.id) ds ON ds.id_projekt = p.id


LEFT JOIN (
 SELECT k."Kód" "RIS3 KET (Kód)",    
	k."Název" "RIS3 KET (Název)",
	pr.id_projekt,
	pr.id_hierarchie
 FROM projekt_ris3 pr 
 INNER JOIN ciselnik_ris3_ket k ON pr.id_ris3 = k.id) ket ON ket.id_projekt = p.id AND ket.id_hierarchie = ds.id_ds

WHERE
p."Registraèní èíslo projektu" IN (
-- 'CZ.01.01.01/03/23_024/0002849',
'CZ.01.01.01/07/23_013/0001301')

ORDER BY p."Registraèní èíslo projektu" , ds."Doména specializace (Kód)"
----------------------------------------
SELECT p."Registraèní èíslo projektu",
       ds."Kód" "Doména specializace (Kód)",    
       ds."Název" "Doména specializace (Název)",
       ds."Procento" "Doména specializace (Procento)",
       pr.* 

       -- 
       -- ket."RIS3 KET (Kód)",    
       -- ket."RIS3 KET (Název)"

FROM projekt p
inner JOIN projekt_ris3 pr ON pr.id_projekt = p.id
left JOIN ciselnik_ris3_domeny_specializace ds ON pr.id_ris3 = ds.id
LEFT JOIN (
 SELECT k."Kód" "RIS3 KET (Kód)",    
	k."Název" "RIS3 KET (Název)",
	pr.id_projekt,
	pr.id_hierarchie
 FROM projekt_ris3 pr 
 INNER JOIN ciselnik_ris3_ket k ON pr.id_ris3 = k.id) ket ON ket.id_projekt = p.id AND ket.id_hierarchie = ds.id_ris3



WHERE
p."Registraèní èíslo projektu" IN (
-- 'CZ.01.01.01/03/23_024/0002849',
'CZ.01.01.01/07/23_013/0001301')
