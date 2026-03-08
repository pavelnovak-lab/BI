SELECT	 p."Registraèní èíslo projektu" ,
	 v."Èíslo výzvy",
	 v."Název výzvy",
     	 p.kodwfstav ,
	 SUBSTR(p.kompetencniutvar, 10) AS "Program podpory" ,
       	 cis."Název" AS "Právní forma ¾adatele" ,
	 pf."Národní veøejné zdroje"
	 -- listagg(DISTINCT ci."Kód", '; ') as "Zdroje fin. na výzvì"

FROM  isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjggvs vs ON p.id_zadatel = vs.id AND vs.id_typsubjektu = 300784 -- ¾adatel pøíjemce
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vs.id_hosppravforma
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMFPFCelkem pf ON pf.id_projekt = p.id AND pf.id_faze=99991000000000005
-- INNER JOIN isum.v_bi_UMZRadekSabDP sabdp ON sabdp.id_nositelsablony = v.id
-- INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = sabdp.id_zdrojfin 

WHERE p."Registraèní èíslo projektu" is not null 
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP20','PP21','PP22','PP23a','PP23b','V5','PP27a','PP27b','PP29')  

AND p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.4','31.5','31.9','31.14','31.22') 

AND pf."Národní veøejné zdroje" > 0
