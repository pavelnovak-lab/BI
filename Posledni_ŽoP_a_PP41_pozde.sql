SELECT	p."Registrační číslo projektu",
	SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
	p.kodwfstav ,
	p.wfstavdatum,
	platba."Datum změny stavu" as "Proplacení poslední ŽoP",
	(select count(*)  
 	from isum.V_BI_UMSKALENDAR r 
 	where r.datum between platba."Datum změny stavu" and p.wfstavdatum 
	-- and r.dentydne not in (6,7) 
	-- and r.SVATEK='N'
	) AS "Počet dní stav WF a proplacení"


FROM	isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby

WHERE platba.kodwfstav in ('P10','P11')
AND   platba."Závěrečná platba" = 'A'
AND   p.kodwfstav in ( 'PP40', 'PP41' )


-- WHERE EXISTS
-- (SELECT platba.id
--  FROM   isum.v_bi_UmzProjekt pp
--  INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON pp.id=platba.id_NositelPlatby
--  WHERE platba.kodwfstav in ('P10','P11')
--  AND   platba."Závěrečná platba" = 'A'
--  AND   pp.kodwfstav in ( 'PP40', 'PP41' )
--  AND   pp.id  = p.id)


-- SELECT
-- pp."Registrační číslo projektu" ,
-- (select count(*)  
--  from isum.V_BI_UMSKALENDAR r 
--  where r.datum between platba."Datum změny stavu" and trunc(sysdate) 
-- -- and r.dentydne not in (6,7) 
-- -- and r.SVATEK='N'
-- ) AS "Počet dní po poslední ŽoP"

-- FROM   isum.v_bi_UmzProjekt pp
--  INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON pp.id=platba.id_NositelPlatby
--  WHERE platba.kodwfstav in ('P10','P11')
--  AND   platba."Závěrečná platba" = 'A'
--  AND   pp.kodwfstav = 'PP40'
--  AND   pp.id = 2014866
--  AND   "Počet dní po poslední ŽoP" > 20





-- select	 
-- "V_BI_UMZPROJEKT"."Registrační číslo projektu" as "Registrace",
-- "V_BI_UMZPROJEKT"."Název projektu CZ" as "Projekt",
-- "V_BI_UMZPROJEKT"."Datum registrace žádosti" as "Datum_registrace" 

--  from	"ISUM"."V_BI_UMZPROJEKT" "V_BI_UMZPROJEKT" 
--  where 	 "V_BI_UMZPROJEKT"."Registrační číslo projektu" is not null

-- /*definice parametru - zobrazení záznamu od data registrace zadaného uživatelem*/
-- /*nutno přidat logickou spojku "and", následně v závorkách definice, ke kterému atributu bude parametr navázán, následně operátor ">" pro porovnávání řetězců a navázání na parametr (parametr je označen dvojtečkou)*/

-- and ("V_BI_UMZPROJEKT"."Datum registrace žádosti" > (:P_DatumOD) or (:P_DatumOD) is null)

-- /*konstrukce "or (:P_DatumOD) is null" způsobí, že pokud uživatel nezadá žádný filtrační řetězec, výsledek zobrazení bude obsahovat všechny záznamy */

Dobrý den,
jak prosím zjistit rozdíl dvou datumů v SQL? Vím, že můžu použít třídu UmsKalendar, podobně jako v příkladu níže. Problém je ale v tom, že do WHERE pak nemůžu dát např. "Počet dní v aktual stavu" < 30, atd.

Prosím tedy o příklad, jak můžu spočítat rozdíl dvou datumových položek a dostat odpověď v počtu dní.

8<------------

SELECT	p."Registrační číslo projektu",
 	(select count(*)
 	from isum.V_BI_UMSKALENDAR r 
	 where r.datum between trunc(p.wfstavdatum) and trunc(sysdate) 
	 -- and r.dentydne not in (6,7) 
	 -- and r.SVATEK='N'
	) AS "Počet dní v aktual stavu"
FROM isum.v_bi_UmzProjekt p 
WHERE p.id = 911564985

8<--------------

Předem moc děkuji za odpověď a přeji hezký den,
Pavel Novák 
