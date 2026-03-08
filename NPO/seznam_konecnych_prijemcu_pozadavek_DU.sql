SELECT	p.zadatel "Název koneèného pøíjemce fin. prostøedkù",
	CASE WHEN p."IÈ" is not null THEN p."IÈ"
	     ELSE rc.dn END "IÈ",
	p."Registraèní èíslo projektu" "Unikátní ID projektu",
	p."Název projektu CZ" "Název projektu" ,
	sum(rf.CASTKASCHVALENA) "Vý¹e fin. prostøedkù na projekt v Kè" ,
	p.kodspecifcil ,

	SUBSTR(ci."Kód", -3) "Identifikace Milníku/Cíle" ,
	ci."Název",
	p.specifcil
	
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.kodwfstav in ('P10','P11')
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 )
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = p.id_micil
LEFT JOIN (SELECT vs.id_prjgg ,
     	  	  to_char(vs."DATUMNAROZENI#Datum narození", 'DD. MM. YYYY') dn
	   FROM isum.v_bi_umzprjggvs vs -- ¾adatel pøíjemce
	   INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vs.id_hosppravforma

	   WHERE cis."Název" = 'Fyzická osoba podnikající bez IÈ'
	   AND vs.id_typsubjektu = 300784 -- ¾adatel
	   -- and p."Registraèní èíslo projektu" = 'CZ.31.3.0/0.0/0.0/22_001/0002571' 
	   ) rc ON rc.id_prjgg = p.id

     	  	  

WHERE p."Registraèní èíslo projektu" is not null 
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PU30') 
AND p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.4','31.5','31.14','31.22','31.26') -- komponenty MPO


HAVING 	sum(rf.CASTKASCHVALENA)  > 0

GROUP BY p.zadatel ,
	CASE WHEN p."IÈ" is not null THEN p."IÈ"
	     ELSE rc.dn END,
	p."Registraèní èíslo projektu",
	p."Název projektu CZ" ,
	p.id_micil,
	p.kodspecifcil ,
	p.specifcil ,
	ci."Kód" ,
	ci."Název"

ORDER BY p.kodspecifcil




-- ----------------------------------------
-- SELECT p."Registraèní èíslo projektu",
--        cis."Název" AS "Právní forma ¾adatele" ,
--        -- cis."Kód" "Kód PF",
--        ci."Název" "Typ subjektu",
--        vs."RÈ",
--        to_char(vs."DATUMNAROZENI#Datum narození", 'DD. MM. YYYY') "Datum narození"
-- FROM isum.v_bi_UmzProjekt p
-- INNER JOIN isum.v_bi_umzprjggvs vs ON p.id = vs.ID_PRJGG -- AND vs.id_typsubjektu = 300784 -- ¾adatel pøíjemce
-- INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vs.id_hosppravforma
-- INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  vs.id_typsubjektu

-- WHERE p."Registraèní èíslo projektu" = 'CZ.31.3.0/0.0/0.0/22_001/0002571'

