/* Princip dotazu je následující: vytvoř dvě tabulky a spoj je podle ID v třídě UmzProjekt - tabulky se jmenují poslední a předposlední a jsou popsané níže */

SELECT  posledni."Registrační číslo projektu",
	posledni."STAVZ" AS "Přepnuto ze stavu kód",
	posledni."STAVZNAZEV" AS "Přepnuto ze stavu název",
	posledni."CREATE_CAS"  AS "V PN20b od",
	FLOOR(posledni."CREATE_CAS"-predposledni."CREATE_CAS") AS "Počet dní od předchozího stavu"

FROM

/* První tabulka obsahuje sloupce z třídy UmzProjekt, která je navázaná na UmsWfHistorieStavu. Ten první "SELECT *" je jen úlitba za to, že do WHERE nemůžu napsat ani aliasy (SQL dotaz se vyhodnocuje právě nejprve od WHERE, tedy ještě před tím, než jsou aliasy načteny) ani do WHERE nedám indexovací funkci ROW_NUMBER. */

 (SELECT *

	FROM (SELECT p."Registrační číslo projektu",
	     	     hs."STAVZ",
		     hs."STAVZNAZEV",
		     hs."CREATE_CAS",
		     p.id,
/* Tenhle řádek je pro mě klíčový - indexuje vytvořené řádky podle srovnaného (DESC) sloupce "CREATE_CAS". Číslování rozpadá podle Reg. čísla projektu. */		     
		     (row_number() OVER (PARTITION BY p."Registrační číslo projektu" ORDER BY hs."CREATE_CAS" DESC)) as "Pořadí"

		FROM 	   isum.v_bi_umzprojekt p
		INNER JOIN isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id

		WHERE hs."STAVZNAZEV"  not like 'Předběžná%'
		 AND p."KODWFSTAV" = 'PN20b')

/* Od každého projektu beru první záznam podle indexů - viz předchozí koment. */
	WHERE "Pořadí" = 1) posledni

INNER JOIN

/* První tabulku spojím s druhou, klíč/vazba je úplně poslední řádek - ID v UMZProjekt */
 (SELECT *

	FROM (SELECT hs."CREATE_CAS",
		     p.id,
		     (row_number() OVER (PARTITION BY p."Registrační číslo projektu" ORDER BY hs."CREATE_CAS" DESC)) as "Pořadí"

		FROM       isum.v_bi_umzprojekt p
		INNER JOIN isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id

		WHERE hs."STAVZNAZEV" not like 'Předběžná%'
		 AND p."KODWFSTAV" = 'PN20b')

	WHERE "Pořadí" = 2) predposledni

ON posledni.id=predposledni.id
