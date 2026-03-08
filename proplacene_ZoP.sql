SELECT p.kodprioritniosa,
       v."Èíslo výzvy" ,
       p."Registraèní èíslo projektu" ,
       p.kodwfstav ,
       platba."Datum zmìny stavu" "Datum proplacení Z®oP"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
-- INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id  AND rf.id_ukazatel in ( 361347, 361356 ) -- øádky cis.

WHERE p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.4','31.5','31.9','31.14','31.22','31.26')
AND platba.kodwfstav in ('P10','P11')
AND p.kodwfstav = 'PP37'
AND platba."Závìreèná platba" = 'A'

ORDER BY "Datum proplacení Z®oP"
----------------------------------------
SELECT	v."Èíslo výzvy" ,
	p."Registraèní èíslo projektu" ,
	vs."IÈ",
	vs."Název subjektu" ,
	ci."Název" "Velikost podniku",
	vs."Poèet zamìstnancù",
	p.kodwfstav 
 	-- p.eu

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel 
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  vs.id_velikostpodniku

WHERE -- p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.4','31.5','31.9','31.14','31.22','31.26') 
v."Èíslo výzvy" IN ('31_22_014','31_22_015')
AND p.kodwfstav in ('PP43','PP42','PP41')
