WITH
prvnidruhy AS (
SELECT min(h."Pořadí") "Prvý pořadí",
       max(h."Pořadí") "Druhý pořadí",
       h.id_noshodnoceni,
       a."Pořadí" "Pořadí arbitr",
       count(h.id)
FROM hodnoceni h
LEFT JOIN (
     SELECT h."Pořadí",
     	    h.id_noshodnoceni,
	    h.id
     FROM hodnoceni h
     WHERE h."Platný" = 'A'
     AND h."Finalizováno" = 'A'
     AND h."Schváleno schvalovatelem" = 'A'
     AND h.id_krokvechodn = 488854 -- 2. krok VH
     AND h."Arbitr" = 'A' ) a ON a.id_noshodnoceni = h.id_noshodnoceni
WHERE h."Platný" = 'A'
AND h."Finalizováno" = 'A'
AND h."Schváleno schvalovatelem" = 'A'
AND h.id_krokvechodn = 488854 -- 2. krok VH
AND h."Arbitr" = 'N'
AND h.id_noshodnoceni =  61093599 -- p."Registrační číslo projektu" = 'CZ.01.01.01/01/22_002/0000120' -- má arbitra
GROUP BY h.id_noshodnoceni,
      	 a."Pořadí"
HAVING count(h.id) IN (2,3) /* k ostranění prj, pouze s jedním platným posudkem */ )


SELECT prvni."Výsledek (v bodech)" "První celkem bodů",
       druhy."Výsledek (v bodech)" "Druhý celkem bodů" ,
       pd."Druhý pořadí",
       druhy."Pořadí"
FROM prvnidruhy pd
INNER JOIN hodnoceni prvni ON prvni.id_noshodnoceni = pd.id_noshodnoceni AND prvni."Pořadí" = pd."Prvý pořadí" AND prvni.id_krokvechodn = 488854
INNER JOIN hodnoceni druhy ON druhy.id_noshodnoceni = pd.id_noshodnoceni AND druhy."Pořadí" = pd."Druhý pořadí" AND prvni.id_krokvechodn = 488854


