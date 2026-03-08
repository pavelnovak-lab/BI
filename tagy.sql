SELECT p."Registraèní èíslo projektu",
       SUBSTR (p.KodPrioritniOsa, 4) "Prioritní osa" ,
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
       p.kodwfstav ,
       LISTAGG(DISTINCT ci."Název", '; ') WITHIN GROUP(ORDER BY ci."Název")  "Tag",
       sum(castky.FMDOTACECELK) "Kráceno o",
       sum(rf.CASTKASCHVALENA) proplaceno,
       gg.eu "Po¾adováná dotace"	
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMZPrjGGTag tag ON p.id = tag.id_prjgg
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = tag.id_tag
LEFT JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
LEFT JOIN isum.v_bi_UMPCastky castky ON castky.id = platba.id_rozdilkorekce
LEFT JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356 -- øádky 10a   
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3',  '01.4', '01.5')
AND ci."Název" in ('Nereaguje','Proj pozastaven','Odnìtí dotace','Pøedán k ukonèení ØO','Proj. nerealizovan','Odstoupeni od proj.')
-- AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/17_176/0015744'
-- AND p.kodwfstav in ('PP30') 
GROUP BY p."Registraèní èíslo projektu", p.kodwfstav , SUBSTR (p.KodPrioritniOsa, 4) , gg.eu, SUBSTR(p.kompetencniutvar, 6 ) 

ORDER BY SUBSTR (p.KodPrioritniOsa, 4), SUBSTR(p.kompetencniutvar, 6 )


SELECT count(ci."Název"),
       p."Registraèní èíslo projektu"

FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UMZPrjGGTag tag ON p.id = tag.id_prjgg
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = tag.id_tag

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4')
AND p."Registraèní èíslo projektu" is not null

ORDER BY count(ci."Název")
