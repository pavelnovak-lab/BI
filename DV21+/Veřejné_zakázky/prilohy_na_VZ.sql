CREATE or REPLACE view "prilohy_verejne_zakazky" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/VZ' AS 

SELECT vpril."Datum vytvoření",
       vpril."Pořadí" ,
       vpril."Název dokumentu",
       vpril."LinkDMS" 

FROM zakazka vz
INNER JOIN zakazka_priloha vpril ON vpril.id_nositelpril = vz.id 

WHERE vz."Pořadové číslo" = '00029592'

ORDER BY vpril."Pořadí" DESC 
