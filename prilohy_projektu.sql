SELECT -- p."Registrační číslo projektu" ,
       -- pril."Název dokumentu",
       pril."LinkDMS"
FROM projekt p
INNER JOIN prilohy_projektu pril ON pril.id_nositelpril = p.id 

WHERE pril."Název dokumentu" like 'Hodnocení věcné%'
AND p."Registrační číslo projektu" IN ('CZ.01.01.01/01/24_062/0007052','CZ.01.01.01/01/24_062/0007581','CZ.01.01.01/01/24_062/0007592','CZ.01.01.01/01/24_062/0007637','CZ.01.01.01/01/24_062/0007643','CZ.01.01.01/01/24_062/0007645','CZ.01.01.01/01/24_062/0007666','CZ.01.01.01/01/24_062/0007675','CZ.01.01.01/01/24_062/0007678','CZ.01.01.01/01/24_062/0007463','CZ.01.01.01/01/24_062/0007669')
